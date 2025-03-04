import 'package:rose_fz/models/flower.dart';
import 'package:rose_fz/models/soil.dart';
import 'package:rose_fz/utils/mg_data.dart';

import '../global.dart';
import '../response.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../utils/mg.dart';
import '../user_config.dart';
import 'select_flower.dart';

class PlantOperPage extends StatefulWidget {
  final Soil soil;
  final int count;

  PlantOperPage({Key key, @required this.soil, this.count}) : super(key: key);

  @override
  _PlantOperPageState createState() => _PlantOperPageState(soil, count);
}

class _PlantOperPageState extends State<PlantOperPage> {
  final ScrollController _controller = ScrollController();
  Soil soil;
  final int _count;
  final Map<int, int> _gainCount = {};
  Flower _flower;

  _PlantOperPageState(this.soil, this._count);

  int choiceIndex = 0;
  String usernic = '';
  List<String> logs = [];
  GetInitFirstResponse initFirstRes = new GetInitFirstResponse();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    var initFirst = await MGUtil.getInitFirst();
    this.setState(() {
      this.initFirstRes = initFirst;
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
    var speeds = Global.userConfig.speeds;
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
    if (_flower != null) {
      var res = await MGUtil.plant(soil.no, _flower.plantId);
      if (res.result == 0) {
        soil.soilsate = res.soilsate;
        soil.rosestate = res.rosestate;
        soil.gainTime = Soil.getGainTime(res.soilsate, res.rosebegintime);
        logs.add(res.toString());
      } else {
        logs.add("种植 ${res.resultstr}");
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
      logs.add("松土 ${res.resultstr}");
    }
    this.setState(() {
      this.logs = logs;
    });
    return res.result == 0;
  }

  Future<bool> gain() async {
    var res = await MGUtil.gain(soil.no);
    if (res.result == 0) {
      if (!_gainCount.containsKey(res.igainrosetype)) {
        _gainCount[res.igainrosetype] = 0;
      }
      _gainCount[res.igainrosetype] += res.igainrosecount;
      soil.rosestate = 0;
      soil.soilsate = 50;
      logs.add(res.toString());
      logs.add(
          '共收获 ${MGDataUtil.dicMapId['${res.igainrosetype}']?.name} ${_gainCount[res.igainrosetype]}');
    } else {
      logs.add("收获 ${res.resultstr}");
    }
    this.setState(() {
      this.logs = logs;
    });
    return res.result == 0;
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

  handleBeginWork() async {
    var soils = await MGUtil.getPlantInfo();
    soil = soils.firstWhere((item) => item.no == soil.no);
    execute();
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
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: FlatButton(
                    child: Text(
                      _flower != null ? _flower.name : "选择种子",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      Navigator.of(context)
                          .push<Flower>(MaterialPageRoute(
                        builder: (context) => SelectFlowerPage(soil: this.soil),
                      ))
                          .then((Flower flower) {
                        this.setState(() {
                          this._flower = flower;
                        });
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: FlatButton(
                    child: Text(
                      "开始工作",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      handleBeginWork();
                    },
                  ),
                ),
              ),
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
