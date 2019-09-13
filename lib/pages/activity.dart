import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../user.dart';
import '../utils/mg.dart';
import '../config.dart';

final dateFormat = new DateFormat('yyyy-MM-dd HH:mm');

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() {
    return new _ActivityState();
  }
}

class ActConfig {
  String id;
  String name;
  int start;
  int end;
  String desc;
  bool isActive;
  int sort;
}

List<int> includeActivities = [26, 36, 42, 76, 78];
List<int> excludeActivities = [62, 77];

class _ActivityState extends State<Activity> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Config.init();
    if (User.initFirstRes != null && User.initFirstRes.huaYuanTreasure == 1) {
      ActConfig actConfig = ActConfig();
      actConfig.id = 'huayuantreasure2017_npc';
      actConfig.name = '花园寻宝';
      actConfig.desc = '花园寻宝';
      actConfig.isActive = true;
      actConfig.sort = 999;
      actConfigs.add(actConfig);
    }
    DateTime now = DateTime.now();
    var unixtime = now.millisecondsSinceEpoch / 1000;
    var limit = Config.actGuideConfig.findAllElements('limit').toList()[0];
    for (var item in limit.findAllElements('item')) {
      var id = item.getAttribute('id');
      if (item.getAttribute('start') != null &&
          !excludeActivities.contains(int.parse(id))) {
        ActConfig actConfig = ActConfig();
        actConfig.id = id;
        actConfig.name = item.getAttribute('name');
        actConfig.start = int.parse(item.getAttribute('start'));
        actConfig.end = int.parse(item.getAttribute('end'));
        actConfig.desc = item.getAttribute('desc');
        actConfig.isActive =
            unixtime > actConfig.start && unixtime < actConfig.end;
        actConfig.sort = actConfig.isActive ? int.parse(actConfig.id) : 0;
        actConfigs.add(actConfig);
      }
    }
    actConfigs.sort((a, b) => b.sort - a.sort);
    setState(() {
      actConfigs = actConfigs;
    });
  }

  List<ActConfig> actConfigs = [];
  final SlidableController slidableController = SlidableController();

  showSnackBar(String tip) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(tip),
      duration: Duration(seconds: 1),
    ));
  }

  /// 夏日大作战
  xiaRiDaZuoZhan(ActConfig actConfig) async {
    var parmas = {'request': 1, 'cmd': 188};
    var initRes = await MGUtil.activityOper(parmas);
    if (initRes['result'] == 0) {
      var digCount = int.parse(initRes['free'][0]);
      var catchCount = int.parse(initRes['free'][1]);
      var globalCatchCount = int.parse(initRes['leftGlobalRewardCnt'][0]);
      // 挖宝
      if (digCount > 0) {
        for (var i = 0; i < digCount; i++) {
          parmas = {'request': 3, 'cmd': 188, 'auto': 0, 'count': 1};
          var digRes = await MGUtil.activityOper(parmas);
          if (digRes['result'] == 0) {
            showActivityOperAward(actConfig, digRes['award']);
          } else {
            showActivityOperSnackBar(actConfig, digRes['resultstr']);
          }
        }
      }
      // 捕抓小螃蟹
      if (catchCount > 0) {
        parmas = {
          'request': 4,
          'cmd': 188,
          'auto': 0,
          'count': catchCount,
          'index': 1
        };
        var catchRes = await MGUtil.activityOper(parmas);
        if (catchRes['result'] == 0) {
          showActivityOperAward(actConfig, catchRes['award']);
        } else {
          showActivityOperSnackBar(actConfig, catchRes['resultstr']);
        }
      }
      // 全服抓螃蟹
      if (globalCatchCount > 0) {
        parmas = {'request': 11, 'cmd': 188, 'index': 1};
        var globalCatchRes = await MGUtil.activityOper(parmas);
        if (globalCatchRes['result'] == 0) {
          showActivityOperAward(actConfig, globalCatchRes['award']);
        } else {
          showActivityOperSnackBar(actConfig, globalCatchRes['resultstr']);
        }
      }
    } else {
      showActivityOperSnackBar(actConfig, initRes['resultstr']);
    }
  }

  /// 拯救计划
  zhengJiuJiHua(ActConfig actConfig) async {
    var parmas = {'request': 1, 'cmd': 225};
    var initRes = await MGUtil.activityOper(parmas);
    if (initRes['result'] == 0) {
      var freeCount = initRes['free'];
      if (freeCount > 0) {
        var index = initRes['birds'].indexOf('$freeCount') + 1;
        parmas = {
          'request': 3,
          'cmd': 225,
          'auto': 0,
          'count': 1,
          'index': index
        };
        var res = await MGUtil.activityOper(parmas);
        if (res['result'] == 0) {
          showActivityOperAward(actConfig, res['award']);
        } else {
          showActivityOperSnackBar(actConfig, res['resultstr']);
        }
      }
    } else {
      showActivityOperSnackBar(actConfig, initRes['resultstr']);
    }
  }

  /// 捕虫大作战
  buChongDaZuoZhan(ActConfig actConfig) async {
    var parmas = {'request': 1, 'cmd': 170};
    var initRes = await MGUtil.activityOper(parmas);
    if (initRes['result'] == 0) {
      var freeCount = initRes['free'];
      List<dynamic> insects = initRes['insect'];
      int index = 0;
      for (var i = 0; i < insects.length; i++) {
        var insect = insects[i];
        if (insect['catchFlgs'] == 0) {
          index = i + 1;
          // 毛毛虫
          if (freeCount == 1 && insect['type'] == 1) {
            break;
          }
          // 舞蝶蛾
          if (freeCount == 2 && insect['type'] == 2) {
            break;
          }
        }
      }
      if (freeCount > 0) {
        parmas = {
          'request': 3,
          'cmd': 170,
          'auto': 0,
          'page': 1,
          'paytype': 1,
          'type': 1,
          'index': index,
        };
        var res = await MGUtil.activityOper(parmas);
        if (res['result'] == 0) {
          showActivityOperAward(actConfig, res['award']);
        } else {
          showActivityOperSnackBar(actConfig, res['resultstr']);
        }
      }
    } else {
      showActivityOperSnackBar(actConfig, initRes['resultstr']);
    }
  }

  void showActivityOperAward(ActConfig actConfig, List<dynamic> awards) {
    for (var item in awards) {
      int id = item['id'];
      int type = item['type'];
      int count = item['count'];
      if (type == 4) {
        return showActivityOperSnackBar(actConfig, '获得 经验值 $count');
      }
      // print('$id $type $count');
      // 31007 0 5 3级灵石
      // 0 6 500
      var prop = Config.getPropById(id);
      if (prop != null) {
        return showActivityOperSnackBar(
            actConfig, '获得 ${prop.getAttribute('name')} $count 个');
      }
      var flower = Config.getFlowerInfoBySeedId(id);
      if (flower != null) {
        return showActivityOperSnackBar(
            actConfig, '获得 ${flower.getAttribute('name')} $count 个');
      }
      var petPK = Config.getPetPKById(id);
      if (petPK != null) {
        return showActivityOperSnackBar(
            actConfig, '获得 ${petPK.getAttribute('name')} $count 个');
      }
      print(item);
      showActivityOperSnackBar(actConfig, '$id $type $count');
    }
  }

  showActivityOperSnackBar(ActConfig actConfig, String content) {
    showSnackBar('${actConfig.name} $content');
  }

  // /// 中秋月圆
  // zhongQiuYueYuan(ActConfig actConfig) async {
  //   int cmd = 227;
  //   var parmas = {'request': 1, 'cmd': cmd};
  //   var initRes = await MGUtil.activityOper(parmas);
  //   if (initRes['result'] == 0) {
  //     var freeCount = initRes['free'];
  //     if (freeCount > 0) {
  //       parmas = {
  //         'request': 3,
  //         'cmd': cmd,
  //         'auto': 0,
  //         'count': 1,
  //       };
  //       var res = await MGUtil.activityOper(parmas);
  //       if (res['result'] == 0) {
  //         showActivityOperAward(actConfig, res['award']);
  //       } else {
  //         showActivityOperSnackBar(actConfig, res['resultstr']);
  //       }
  //     }
  //   } else {
  //     showActivityOperSnackBar(actConfig, initRes['resultstr']);
  //   }
  // }

  /// 足球小将 cmd = 182
  /// 燃花灯 cmd = 186
  /// 中秋月圆 cmd = 227
  commonActivity(ActConfig actConfig, int cmd,
      [Map<String, int> otherParams]) async {
    var parmas = {'request': 1, 'cmd': cmd};
    var initRes = await MGUtil.activityOper(parmas);
    if (initRes['result'] == 0) {
      var freeCount = initRes['free'];
      if (freeCount > 0) {
        parmas = {
          'request': 3,
          'cmd': cmd,
          'auto': 0,
          'count': 1,
        };
        if (otherParams != null) {
          parmas.addAll(otherParams);
        }
        var res = await MGUtil.activityOper(parmas);
        if (res['result'] == 0) {
          showActivityOperAward(actConfig, res['award']);
          if (res['specAward'] != null) {
            showActivityOperAward(actConfig, res['specAward']);
          }
        } else {
          showActivityOperSnackBar(actConfig, res['resultstr']);
        }
      }
    } else {
      showActivityOperSnackBar(actConfig, initRes['resultstr']);
    }
  }

  /// 花园寻宝
  huaYuanTreasure(ActConfig actConfig) async {
    int cmd = 155;
    var parmas = {'request': 1, 'cmd': cmd};
    var initRes = await MGUtil.activityOper(parmas);
    if (initRes['result'] == 0) {
      var freeCount = initRes['globalPrize'];
      while (freeCount > 0) {
        var count = freeCount > 5 ? 5 : freeCount;
        parmas = {
          'request': 4,
          'cmd': cmd,
          'type': 1,
          'count': count,
        };
        var res = await MGUtil.activityOper(parmas);
        if (res['result'] == 0) {
          freeCount -= count;
          showActivityOperAward(actConfig, res['award']);
        } else {
          showActivityOperSnackBar(actConfig, res['resultstr']);
        }
      }
    } else {
      showActivityOperSnackBar(actConfig, initRes['resultstr']);
    }
  }

  handleTap(ActConfig actConfig) async {
    switch (actConfig.name) {
      case '花园寻宝':
        await huaYuanTreasure(actConfig);
        break;
      case '夏日大作战':
        await xiaRiDaZuoZhan(actConfig);
        break;
      case '拯救计划':
        await zhengJiuJiHua(actConfig);
        break;
      case '捕虫大作战':
        await buChongDaZuoZhan(actConfig);
        break;
      case '中秋月圆':
        await commonActivity(actConfig, 227);
        break;
      case '足球小将':
        await commonActivity(actConfig, 182);
        break;
      case '燃花灯':
        await commonActivity(actConfig, 186, {'index': 1, 'auto': 0});
        break;
      default:
        showActivityOperSnackBar(
            actConfig, actConfig.isActive ? '活动未实现' : '活动时间未到');
        return;
    }
    showActivityOperSnackBar(actConfig, '执行完毕');
  }

  void handleActivity() async {
    for (var item in actConfigs) {
      if (item.isActive) {
        await handleTap(item);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MaterialButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: new Text('一键完成'),
          onPressed: handleActivity,
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              var actConfig = actConfigs[index];
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
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    actConfig.name,
                                    style: TextStyle(
                                      color: actConfig.isActive
                                          ? Colors.black
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                              actConfig.desc,
                              style: new TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              actConfig.start != null
                                  ? '${dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(actConfig.start * 1000))} - ${dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(actConfig.end * 1000))}'
                                  : '',
                              style: new TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () => handleTap(actConfig),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return new Container(height: 1.0, color: Colors.grey[300]);
            },
            itemCount: actConfigs.length,
          ),
        )
      ],
    );
  }
}
