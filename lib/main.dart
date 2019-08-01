import 'package:flutter/material.dart';

import 'login.dart';
import 'config.dart';
import 'soil.dart';
import 'utils/http.dart';
import 'utils/mg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '开心玫瑰辅助V',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => MyHomePage(),
        '/login': (_) => LoginPage(),
        //....
      },
      initialRoute: '/',
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  void login() {
    Navigator.of(context).pushNamed("/login");
  }

  String usernic = '';
  List<Soil> soils = new List<Soil>();

  Future<void> loadPlant() async {
    var data = await MGUtil.getPlantInfo();

    this.setState(() {
      soils = data;
    });
  }

  @override
  void initState() {
    super.initState();

    (() async {
      await Config.init();

      var getUserInfoResponse = await MGUtil.getUserInfo();
      print(getUserInfoResponse.toJson());
      if (getUserInfoResponse.result == 1000005) {
        login();
      } else {
        loadPlant();
        this.setState(() {
          usernic = getUserInfoResponse.usernic;
        });
      }
      print(getUserInfoResponse.usernic);
    })();
  }

  void showMyMaterialDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text("title"),
            content: new Text("内容内容内容内容内容内容内容内容内容内容内容"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                },
                child: new Text("确认"),
              ),
              new FlatButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                },
                child: new Text("取消"),
              ),
            ],
          );
        });
  }

  List<Widget> getChildrens(BuildContext context, Soil soil) {
    List fertilizers = new List();
    fertilizers.add({"id": 506, "name": "普通时效化肥"});
    fertilizers.add({"id": 507, "name": "急速时效化肥"});
    fertilizers.add({"id": 508, "name": "增产时效化肥"});
    fertilizers.add({"id": 1, "name": "普通化肥"});
    fertilizers.add({"id": 2, "name": "急速化肥"});
    fertilizers.add({"id": 3, "name": "增产化肥"});
    fertilizers.add({"id": 31004, "name": "超级急速化肥"});

    List<Widget> childrens = new List<Widget>();

    fertilizers.forEach((item) {
      childrens.add(new SimpleDialogOption(
        child: new Text(item["name"]),
        onPressed: () async {
          var data = await MGUtil.useFertilizer(soil.no, item["id"]);
          print(data.toJson());
          Navigator.of(context).pop(item["name"]);
        },
      ));
    });
    return childrens;
  }

  void showMySimpleDialog(BuildContext context, Soil soil) {
    showDialog(
        context: context,
        builder: (context) {
          return new SimpleDialog(
            title: new Text("使用化肥"),
            children: getChildrens(context, soil),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("开心玫瑰辅助"),
      ),
      body: RefreshIndicator(
        onRefresh: loadPlant,
        child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              var soil = soils[index];

              return GestureDetector(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(soil.typeName),
                        Text(soil.plantShowName),
                        Text(soil.gainTime != null
                            ? soil.gainTime.toString()
                            : ""),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("加速:"),
                        Text("${soil.speed}%"),
                        Text("增产:"),
                        Text("${soil.increase}%"),
                        Text("魅力:"),
                        Text("${soil.charm}%"),
                        Text("经验:"),
                        Text("${soil.exp}%"),
                        Text("幸运值:"),
                        Text("${soil.lucky}"),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  print(soil);
                  showMySimpleDialog(context, soil);
                  // showMyMaterialDialog(context);
                },
              );

              // return new Text(
              //     "${soil.plantShowName} ${soil.charm} $index ${soil.typeName} ${soil.decorpotName}");
              // // return new Text(
              //     "text $index ${getSoilPlantShowName(soil["soilsate"], soil["season"])} ${getSoilType(soil["SoilType"])}");
            },
            separatorBuilder: (BuildContext context, int index) {
              return new Container(height: 1.0, color: Colors.red);
            },
            itemCount: soils.length),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: login,
        tooltip: '换号',
        child: Text(
          '换号',
        ),
      ),
    );
  }
}
