import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../pages/plant_oper.dart';
import '../utils/mg.dart';
import '../soil.dart';
import '../config.dart';

final dateFormat = new DateFormat('MM-dd HH:mm');

class Plant extends StatefulWidget {
  @override
  _PlantState createState() {
    return new _PlantState();
  }
}

class _PlantState extends State<Plant> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Config.init();
    await loadPlant();
  }

  List<Soil> soils = new List<Soil>();

  Future<void> loadPlant() async {
    var data = await MGUtil.getPlantInfo();

    this.setState(() {
      soils = data;
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

  Color getSoilTypeColor(int type) {
    switch (type) {
      case 0:
        return Colors.brown[900];
      case 1:
        return Colors.blue;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.orange;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: loadPlant,
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            var soil = soils[index];

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            alignment: Alignment(0, 0),
                            height: 18,
                            width: 36,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              border: new Border.all(
                                width: 1,
                                color: getSoilTypeColor(soil.type),
                              ),
                            ),
                            child: Text(
                              soil.typeName,
                              style: new TextStyle(
                                color: getSoilTypeColor(soil.type),
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Text(soil.plantShowName),
                                Text(
                                  soil.status,
                                  style: new TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            soil.gainTime != null
                                ? dateFormat.format(soil.gainTime)
                                : "",
                            style: new TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Row(children: <Widget>[
                        Text(soil.decorpotName,
                            style: new TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ))
                      ]),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                                // "加速: ${soil.speed}% 增产: ${soil.increase}% 魅力: ${soil.charm}% 经验: ${soil.exp}% 幸运值: ${soil.lucky}",
                                soil.getAttrString(),
                                style: new TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ))),
                        // Text("加速:"),
                        // Text("${soil.speed}%"),
                        // Text("增产:"),
                        // Text("${soil.increase}%"),
                        // Text("魅力:"),
                        // Text("${soil.charm}%"),
                        // Text("经验:"),
                        // Text("${soil.exp}%"),
                        // Text("幸运值:"),
                        // Text("${soil.lucky}"),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                print(soil);
                // showMySimpleDialog(context, soil);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlantOperPage(soil: soil),
                ));
                // showMyMaterialDialog(context);
              },
            );

            // return new Text(
            //     "${soil.plantShowName} ${soil.charm} $index ${soil.typeName} ${soil.decorpotName}");
            // // return new Text(
            //     "text $index ${getSoilPlantShowName(soil["soilsate"], soil["season"])} ${getSoilType(soil["SoilType"])}");
          },
          separatorBuilder: (BuildContext context, int index) {
            return new Container(height: 1.0, color: Colors.grey[300]);
          },
          itemCount: soils.length),
    );
  }
}
