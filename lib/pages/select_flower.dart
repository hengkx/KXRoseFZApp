import 'package:KXRoseFZApp/config.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';

import '../utils/mg.dart';

class SelectFlowerPage extends StatefulWidget {
  @override
  _SelectFlowerPageState createState() => _SelectFlowerPageState();
}

class Flower {
  final int plantId;
  final int type; // 1 水生 2 藤类 3 仙藤 99 陆植 100 玫瑰
  final int seedPrice;
  final int seedPriceQPoint;
  final String name;
  final String pyName;

  Flower(
      {this.plantId,
      this.type,
      this.seedPrice,
      this.seedPriceQPoint,
      this.pyName,
      this.name});
}

class _SelectFlowerPageState extends State<SelectFlowerPage> {
  void login() {
    Navigator.of(context).pushNamed("/login").then((_) {
      getUserInfo();
    });
  }

  int choiceIndex = 0;
  String usernic = '';
  List<Flower> flowers = new List<Flower>();

  void getUserInfo() async {
    var getUserInfoResponse = await MGUtil.getUserInfo();
    print(getUserInfoResponse.toJson());
    if (getUserInfoResponse.result == 1000005) {
      login();
    } else {
      this.setState(() {
        usernic = getUserInfoResponse.usernic;
      });
    }
    print(getUserInfoResponse.usernic);
  }

  @override
  void initState() {
    super.initState();
    // getUserInfo();
    init();
  }

  init() async {
    await Config.init();
    Config.flowerConfig.findAllElements("item").forEach((item) {
      var plantId = int.parse(item.getAttribute("id"));
      if (item.getAttribute("combineid") == null && plantId != 0) {
        var name = item.getAttribute("name");
        flowers.add(new Flower(
            plantId: plantId,
            type: item.getAttribute("type") != null
                ? int.parse(item.getAttribute("type"))
                : 99,
            seedPrice: int.parse(item.getAttribute("seedPrice")),
            seedPriceQPoint: int.parse(item.getAttribute("seedPriceQPoint")),
            pyName: PinyinHelper.getShortPinyin(name),
            name: name));
      }
    });
    print(flowers.length);
    this.setState(() {
      flowers = flowers;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("选择花"),
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            var flower = flowers[index];
            return GestureDetector(
              child: new Text("${flower.name} ${flower.pyName} ${flower.type}"),
              onTap: () {
                Navigator.of(context).pop(flower);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return new Container(height: 1.0, color: Colors.grey[300]);
          },
          itemCount: flowers.length),
    );
  }
}
