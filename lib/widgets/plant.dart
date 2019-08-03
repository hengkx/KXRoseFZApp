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

  List<Soil> soils = [];
  final SlidableController slidableController = SlidableController();

  Future<void> loadPlant() async {
    var data = await MGUtil.getPlantInfo();

    this.setState(() {
      soils = data;
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

  showSnackBar(String tip) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(tip)));
  }

  List<Widget> getSlideActions(Soil soil) {
    final List<Widget> slideActions = [];
    if (soil.soilsate != 50 && soil.soilsate != 51 && soil.rosestate != 5) {
      slideActions.add(SlideAction(
        child: Text(
          "铲花",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.orange,
        onTap: () => hoe(soil),
      ));
      if (!soil.isDouble) {
        slideActions.add(SlideAction(
          child: Text(
            "连续增产",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.lightBlue,
          onTap: () => useMoreFertilizer(soil.no, 3, true),
        ));
        slideActions.add(SlideAction(
          child: Text(
            "增产",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.green,
          onTap: () => useMoreFertilizer(soil.no, 3, false),
        ));
      }
    }
    return slideActions;
  }

  hoe(Soil soil) async {
    var res = await MGUtil.hoe(soil.no);
    if (res.result == 0) {
      showSnackBar("松土成功");
      loadPlant();
    } else {
      showSnackBar(res.resultstr);
    }
  }

  gain(Soil soil) async {
    var res = await MGUtil.gain(soil.no);
    if (res.result == 0) {
      showSnackBar("收获成功");
      loadPlant();
    } else {
      showSnackBar(res.resultstr);
    }
  }

  plant(Soil soil) async {
    showSnackBar("功能待开发");
  }

  plantAction(Soil soil) async {
    bool isExecuteSucc = false;
    if (soil.isNoFood) {
      var res = await MGUtil.plantAction(soil.no, 1);
      if (res.result == 0) {
        isExecuteSucc = true;
        showSnackBar("杀虫成功");
      } else {
        showSnackBar(res.resultstr);
      }
    }
    if (soil.isNoShine) {
      var res = await MGUtil.plantAction(soil.no, 2);
      if (res.result == 0) {
        isExecuteSucc = true;
        showSnackBar("晒阳光成功");
      } else {
        showSnackBar(res.resultstr);
      }
    }
    if (soil.isClutter) {
      var res = await MGUtil.plantAction(soil.no, 3);
      if (res.result == 0) {
        isExecuteSucc = true;
        showSnackBar("除草成功");
      } else {
        showSnackBar(res.resultstr);
      }
    }
    if (isExecuteSucc) {
      loadPlant();
    }
  }

  List<Widget> getSlideSecondaryActions(Soil soil) {
    final List<Widget> slideActions = [];
    if (soil.soilsate == 50) {
      slideActions.add(SlideAction(
        child: Text(
          "松土",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.orange,
        onTap: () => hoe(soil),
      ));
    } else if (soil.soilsate == 51) {
      slideActions.add(SlideAction(
        child: Text(
          "种植",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.green.shade700,
        onTap: () => plant(soil),
      ));
    } else {
      if (soil.rosestate == 5) {
        slideActions.add(SlideAction(
          child: Text(
            "收获",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.orange,
          onTap: () => gain(soil),
        ));
      } else {
        if (soil.isClutter || soil.isNoFood || soil.isNoShine) {
          slideActions.add(SlideAction(
            child: Text(
              "一键操作",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.orange,
            onTap: () => plantAction(soil),
          ));
        }
        if (!soil.isDouble) {
          slideActions.add(SlideAction(
            child: Text(
              "时效增产",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
            onTap: () => useMoreFertilizer(soil.no, 508, false),
          ));
          slideActions.add(SlideAction(
            child: Text(
              "连续增产",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlue,
            onTap: () => useMoreFertilizer(soil.no, 508, true),
          ));
        }
      }
    }
    return slideActions;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: loadPlant,
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          var soil = soils[index];
          final List<Widget> slideActions = getSlideActions(soil);
          final List<Widget> slideSecondaryActions =
              getSlideSecondaryActions(soil);
          return Slidable(
            key: ValueKey(soil.no),
            controller: slidableController,
            actionPane: SlidableDrawerActionPane(),
            actions: slideActions,
            secondaryActions: slideSecondaryActions,
            enabled: soil.type != 2,
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
                                Text(
                                  soil.plantShowName,
                                  style: TextStyle(
                                    color: soil.type != 2
                                        ? Colors.black
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                            soil.getAttrString(),
                            style: new TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ),
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
                if (soil.type != 2) {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => PlantOperPage(soil: soil),
                  // ));
                }
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return new Container(height: 1.0, color: Colors.grey[300]);
        },
        itemCount: soils.length,
      ),
    );
  }
}
