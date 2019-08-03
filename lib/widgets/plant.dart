import 'package:KXRoseFZApp/widgets/round_rect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  Future<void> useMoreFertilizer(int no, int type, bool repeat) async {
    var res = await MGUtil.useFertilizer(no, type);
    String tip = "";
    if (res.result == 0) {
      tip = "增产使用成功 ${res.isDouble == 1 ? '增产成功' : '增产失败'}";
      if (res.isDouble != 1 && repeat) {
        return useMoreFertilizer(no, type, repeat);
      }
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(tip)));
      await loadPlant();
    } else {
      tip = res.resultstr;
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(tip)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: loadPlant,
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            var soil = soils[index];

            return Slidable(
              key: ValueKey(index),
              actionPane: SlidableDrawerActionPane(),
              actions: <Widget>[
                SlideAction(
                  child: Text(
                    "连续增产",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.lightBlue,
                  onTap: () => useMoreFertilizer(soil.no, 3, true),
                ),
                SlideAction(
                  child: Text(
                    "增产",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                  onTap: () => useMoreFertilizer(soil.no, 3, false),
                ),
              ],
              secondaryActions: <Widget>[
                SlideAction(
                  child: Text(
                    "增产",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                  onTap: () => useMoreFertilizer(soil.no, 508, false),
                ),
                SlideAction(
                  child: Text(
                    "连续增产",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.lightBlue,
                  onTap: () => useMoreFertilizer(soil.no, 508, true),
                ),
              ],
              // dismissal: SlidableDismissal(
              //   child: SlidableDrawerDismissal(),
              // ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: <Widget>[
                            RoundRect(
                              text: soil.typeName,
                              color: getSoilTypeColor(soil.type),
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
                          Expanded(
                            child: Text(
                              soil.decorpotName,
                              style: new TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              RoundRect(
                                text: "晒阳光",
                                color: Colors.yellow,
                                margin: EdgeInsets.only(left: 10),
                                visible: soil.isNoShine,
                              ),
                              RoundRect(
                                text: "杀虫",
                                color: Colors.green,
                                margin: EdgeInsets.only(left: 10),
                                visible: soil.isNoFood,
                              ),
                              RoundRect(
                                text: "除草",
                                color: Colors.orange,
                                margin: EdgeInsets.only(left: 10),
                                visible: soil.isClutter,
                              ),
                            ],
                          ),
                        ]),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              // "加速: ${soil.speed}% 增产: ${soil.increase}% 魅力: ${soil.charm}% 经验: ${soil.exp}% 幸���值: ${soil.lucky}",
                              soil.getAttrString(),
                              style: new TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ),
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
                          Text(
                            soil.isDouble ? "已增产" : "",
                            style: new TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          )
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
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return new Container(height: 1.0, color: Colors.grey[300]);
          },
          itemCount: soils.length),
    );
  }
}
