import 'package:KXRoseFZApp/config.dart';
import 'package:KXRoseFZApp/response.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../utils/mg.dart';
import '../soil.dart';
import '../user_config.dart';
import 'select_flower.dart';

class PlantOperPage extends StatefulWidget {
  final Soil soil;

  PlantOperPage({Key key, @required this.soil}) : super(key: key);

  @override
  _PlantOperPageState createState() => _PlantOperPageState(soil);
}

class _PlantOperPageState extends State<PlantOperPage> {
  _PlantOperPageState(this.soil);
  final Soil soil;
  ScrollController _controller = ScrollController();

  int choiceIndex = 0;
  String usernic = '';
  Flower flower;
  List<String> logs = new List<String>();
  GetInitFirstResponse initFirstRes = new GetInitFirstResponse();
  dynamic initFirst;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    initFirst = await MGUtil.getInitFirst();
    this.setState(() {
      this.initFirstRes = GetInitFirstResponse.fromJson(initFirst);
    });
  }

  bool isExistFertilizer(SpeedFertilizer speedFertilizer) {
    switch (speedFertilizer.id) {
      case 1:
        return initFirstRes.commonferti > 0;
      case 2:
        return initFirstRes.quickferti > 0;
      case 506:
        return initFirstRes.timeCommonFerti > 0;
      case 507:
        return initFirstRes.timeQuickFerti > 0;
      case 31004:
        return initFirstRes.superQuickFerti > 0;
    }
    return false;
  }

  SpeedFertilizer matchFertilizer(int minute) {
    var speeds = Config.userConfig.speeds;
    for (var i = 0; i < speeds.length; i++) {
      var speedFertilizer = speeds[i];
      if (speeds[i].use &&
          speeds[i].time <= minute &&
          isExistFertilizer(speedFertilizer)) {
        return speeds[i];
      }
    }
    return null;
  }

  Future<bool> plant() async {
    if (flower != null) {
      var res = await MGUtil.plant(soil.no, flower.plantId);
      if (res.result == 0) {
        soil.soilsate = res.soilsate;
        soil.rosestate = res.rosestate;
        soil.gainTime = Soil.getGainTime(res.soilsate, res.rosebegintime);
        logs.add(res.toString());
      } else {
        logs.add(res.resultstr);
      }
      this.setState(() {
        this.logs = logs;
      });
      return res.result == 0;
    } else {
      logs.add("请先选择所需要种植的种子");
      this.setState(() {
        this.logs = logs;
      });
    }
    return false;
  }

  Future<bool> hoe() async {
    var res = await MGUtil.hoe(soil.no);
    if (res.result == 0) {
      soil.soilsate = 51;
      logs.add(res.toString());
    } else {
      logs.add(res.resultstr);
    }
    this.setState(() {
      this.logs = logs;
    });
    return res.result == 0;
  }

  Future<bool> gain() async {
    var gainRes = await MGUtil.gain(soil.no);
    if (gainRes.result == 0) {
      soil.soilsate = 50;
      logs.add(gainRes.toString());
    } else {
      logs.add(gainRes.resultstr);
    }
    this.setState(() {
      this.logs = logs;
    });
    return gainRes.result == 0;
  }

  void execute() async {
    if (soil.rosestate == 5) {
      if (await gain()) {
        execute();
      }
      return;
    }
    if (soil.soilsate == 50) {
      if (await hoe()) {
        execute();
      }
      return;
    } else if (soil.soilsate == 51) {
      if (await plant()) {
        execute();
      }
      return;
    }
    var minute = soil.gainTime.difference(DateTime.now()).inMinutes;
    var speedFertilizer = matchFertilizer(minute);
    logs.add("$minute 分钟 后开花");
    if (speedFertilizer != null) {
      logs.add("自动使用 ${speedFertilizer.name}");
      var res = await MGUtil.useFertilizer(soil.no, speedFertilizer.id);
      print(res.toJson());
      if (res.result == 0) {
        switch (speedFertilizer.id) {
          case 1:
            initFirstRes.commonferti--;
            break;
          case 2:
            initFirstRes.quickferti--;
            break;
          case 506:
            initFirstRes.timeCommonFerti--;
            break;
          case 507:
            initFirstRes.timeQuickFerti--;
            break;
          case 31004:
            initFirstRes.superQuickFerti--;
            break;
        }
        if (res.rosestate == 5) {
          if (await gain()) {
            execute();
            return;
          }
        } else {
          soil.gainTime = Soil.getGainTime(soil.soilsate, res.rosebegintime);
          execute();
        }
      } else {
        logs.add(res.resultstr);
      }
    } else {
      logs.add("未能找到合适的化肥使用");
    }

    this.setState(() {
      this.logs = logs;
      Timer(Duration(milliseconds: 100),
          () => _controller.jumpTo(_controller.position.maxScrollExtent));
    });
  }

  @override
  Widget build(BuildContext context) {
    var labelStyle = new TextStyle(color: Colors.grey);
    var valueStyle = new TextStyle(color: Colors.black);
    // ${soil.gainTime.difference(DateTime.now()).inMinutes}
    return Scaffold(
      appBar: AppBar(
        title: Text("盆 ${soil.no} "),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                child: Text(flower != null ? flower.name : "请选择"),
                onPressed: () {
                  Navigator.of(context)
                      .push<Flower>(MaterialPageRoute(
                    builder: (context) => SelectFlowerPage(
                      initFirstRes: initFirst,
                    ),
                  ))
                      .then((Flower flower) {
                    this.setState(() {
                      this.flower = flower;
                    });
                  });
                },
              ),
              FlatButton(
                child: Text("开始工作"),
                onPressed: () {
                  execute();
                },
              )
            ],
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: "普通化肥：",
                          style: labelStyle,
                          children: <TextSpan>[
                            TextSpan(
                                text: "${initFirstRes.commonferti}",
                                style: valueStyle)
                          ]),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: "急速化肥：",
                          style: labelStyle,
                          children: <TextSpan>[
                            TextSpan(
                                text: "${initFirstRes.quickferti}",
                                style: valueStyle)
                          ]),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: "普通时效：",
                          style: labelStyle,
                          children: <TextSpan>[
                            TextSpan(
                                text: "${initFirstRes.timeCommonFerti}",
                                style: valueStyle)
                          ]),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: "急速时效：",
                          style: labelStyle,
                          children: <TextSpan>[
                            TextSpan(
                                text: "${initFirstRes.timeQuickFerti}",
                                style: valueStyle)
                          ]),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: "超级急速：",
                          style: labelStyle,
                          children: <TextSpan>[
                            TextSpan(
                                text: "${initFirstRes.superQuickFerti}",
                                style: valueStyle)
                          ]),
                    ),
                  )
                ],
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller: _controller,
              padding: new EdgeInsets.all(5.0),
              itemCount: logs.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(logs[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}
