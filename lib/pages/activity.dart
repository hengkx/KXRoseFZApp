import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rose_fz/models/responses/award.dart';
import 'package:rose_fz/utils/mg_data.dart';
import 'package:rose_fz/global.dart';
import 'package:rose_fz/user.dart';
import 'package:rose_fz/utils/mg.dart';

final dateFormat = new DateFormat('yyyy-MM-dd HH:mm:ss');

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
  int cmd;
  dynamic initRes;
}

// List<int> includeActivities = [15, 26, 36, 42, 76, 78];
const List<int> excludeActivities = [51, 62, 71, 72, 77];

const activityCmds = {
  '花园寻宝': 155,
  '全民吃火锅': 160,
  '捕虫大作战': 170,
  '足球小将': 182,
  '弹弹珠': 183,
  '燃花灯': 186,
  '夏日大作战': 188,
  '幸福蛋': 198,
  '星愿': 199,
  '魔幻夺宝': 201,
  '大富翁': 209,
  '拯救兔兔': 212,
  '致富密码': 216,
  '周末活动': 220,
  '拯救计划': 225,
  '中秋月圆': 227,
  '欢乐小黄鸭': 229,
};

class _ActivityState extends State<Activity> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Global.init();
    ActConfig actConfig = ActConfig();
    actConfig.id = '15';
    actConfig.name = '幸福蛋';
    actConfig.desc = '小镇幸福蛋每日首敲必得稀有道具，还有多倍积分噢！';
    actConfig.isActive = true;
    actConfig.sort = 1000;
    actConfig.cmd = activityCmds[actConfig.name];
    actConfigs.add(actConfig);
    if (User.initFirstRes != null) {
      if (User.initFirstRes.huaYuanTreasure == 1) {
        ActConfig actConfig = ActConfig();
        actConfig.id = 'huayuantreasure2017_npc';
        actConfig.name = '花园寻宝';
        actConfig.desc = '花园寻宝';
        actConfig.isActive = true;
        actConfig.sort = 999;
        actConfig.cmd = activityCmds[actConfig.name];
        actConfigs.add(actConfig);
      }
      if (User.initFirstRes.weekendWelfare == 1) {
        ActConfig actConfig = ActConfig();
        actConfig.id = 'weekendwelfare_npc';
        actConfig.name = '周末活动';
        actConfig.desc = '周末活动';
        actConfig.isActive = true;
        actConfig.sort = 999;
        actConfig.cmd = activityCmds[actConfig.name];
        actConfigs.add(actConfig);
      }
    }
    DateTime now = DateTime.now();
    var unixtime = now.millisecondsSinceEpoch / 1000;
    var limit = Global.config['actGuide'].findAllElements('limit').toList()[0];
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
        actConfig.cmd = activityCmds[actConfig.name];
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
    int cmd = actConfig.cmd;
    var initRes = actConfig.initRes;
    if (initRes['result'] == 0) {
      var digCount = int.parse(initRes['free'][0]);
      var catchCount = int.parse(initRes['free'][1]);
      var globalCatchCount = int.parse(initRes['leftGlobalRewardCnt'][0]);
      // 挖宝
      if (digCount > 0) {
        for (var i = 0; i < digCount; i++) {
          var parmas = {'request': 3, 'cmd': cmd, 'auto': 0, 'count': 1};
          await activityOper(actConfig, parmas);
        }
      }
      // 捕抓小螃蟹
      if (catchCount > 0) {
        var parmas = {
          'request': 4,
          'cmd': 188,
          'auto': 0,
          'count': catchCount,
          'index': 1
        };
        await activityOper(actConfig, parmas);
      }
      // 全服抓螃蟹
      if (globalCatchCount > 0) {
        var parmas = {'request': 11, 'cmd': 188, 'index': 1};
        await activityOper(actConfig, parmas);
      }
    }
  }

  /// 星源
  xingYuan(ActConfig actConfig) async {
    int cmd = actConfig.cmd;
    var initRes = actConfig.initRes;
    if (initRes['result'] == 0) {
      var count = initRes['free'];
      var globalRewardCount = int.parse(initRes['leftGlobalRewardCnt'][0]);
      if (globalRewardCount > 0) {
        var parmas = {'request': 4, 'cmd': cmd, 'count': globalRewardCount};
        await activityOper(actConfig, parmas);
      }
      if (count > 0) {
        var parmas = {
          'request': 3,
          'cmd': cmd,
          'auto': 1,
          'count': 1,
          'index': 29 // 北极
        };
        await activityOper(actConfig, parmas);
      }
    }
  }

  /// 拯救计划
  zhengJiuJiHua(ActConfig actConfig) async {
    int cmd = actConfig.cmd;
    var initRes = actConfig.initRes;
    if (initRes['result'] == 0) {
      var freeCount = initRes['free'];
      if (freeCount > 0) {
        int index = initRes['birds'].indexOf('$freeCount') + 1;
        var parmas = {
          'request': 3,
          'cmd': cmd,
          'auto': 0,
          'count': 1,
          'index': index
        };
        await activityOper(actConfig, parmas);
      }
    }
  }

  /// 捕虫大作战
  buChongDaZuoZhan(ActConfig actConfig) async {
    int cmd = actConfig.cmd;
    var initRes = actConfig.initRes;
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
        var parmas = {
          'request': 3,
          'cmd': cmd,
          'auto': 0,
          'page': 1,
          'paytype': 1,
          'type': 1,
          'index': index,
        };
        await activityOper(actConfig, parmas);
      }
    }
  }

  void showActivityOperAward(ActConfig actConfig, List<dynamic> awards) {
    List<String> tips = [];
    for (var item in awards) {
      int id = item['id'];
      int count = item['count'];
      var mgInfo = MGDataUtil.dicMapId['$id'];
      var award = Award.fromJson(item);
      tips.add(
          '${MGDataUtil.getPropItemName(award)} $count ${mgInfo?.unit ?? ''}');
    }
    if (tips.length > 0) {
      showActivityOperSnackBar(actConfig, '获得 ${tips.join(',')}');
    }
  }

  showActivityOperSnackBar(ActConfig actConfig, String content) {
    showSnackBar('${actConfig.name} $content');
  }

  /// 足球小将 cmd = 182
  /// 燃花灯 cmd = 186
  /// 中秋月圆 cmd = 227
  /// 大富翁 cmd = 209
  commonActivity(ActConfig actConfig, [Map<String, int> otherParams]) async {
    int cmd = actConfig.cmd;
    var initRes = actConfig.initRes;
    if (initRes['result'] == 0) {
      var freeCount = initRes['free'];
      if (freeCount > 0) {
        var parmas = {
          'request': 3,
          'cmd': cmd,
          'auto': 0,
          'count': 1,
        };
        if (otherParams != null) {
          parmas.addAll(otherParams);
        }
        await activityOper(actConfig, parmas);
      }
      // 大富翁领取全局
      var leftGlobalRewardCnt = initRes['leftGlobalRewardCnt'] ?? 0;
      while (leftGlobalRewardCnt > 0) {
        int count = leftGlobalRewardCnt > 5 ? 5 : leftGlobalRewardCnt;
        var parmas = {
          'request': 10,
          'cmd': cmd,
          'count': count,
        };
        var res = await activityOper(actConfig, parmas);
        if (res['result'] == 0) {
          leftGlobalRewardCnt -= count;
        }
      }
    }
  }

  /// 花园寻宝
  huaYuanTreasure(ActConfig actConfig) async {
    int cmd = actConfig.cmd;
    var initRes = actConfig.initRes;
    if (initRes['result'] == 0) {
      var freeCount = initRes['globalPrize'];
      while (freeCount > 0) {
        int count = freeCount > 5 ? 5 : freeCount;
        var parmas = {
          'request': 4,
          'cmd': cmd,
          'type': 1,
          'count': count,
        };
        var res = await activityOper(actConfig, parmas);
        if (res['result'] == 0) {
          freeCount -= count;
        }
      }
    }
  }

  Future<dynamic> activityOper(ActConfig cfg, dynamic parmas) async {
    var res = await MGUtil.activityOper(parmas);
    if (res['result'] == 0) {
      if (res['award'] != null) {
        showActivityOperAward(cfg, res['award']);
      }
      if (res['specAward'] != null) {
        showActivityOperAward(cfg, res['specAward']);
      }
    } else {
      showActivityOperSnackBar(cfg, res['resultstr']);
    }
    return res;
  }

  /// 幸福蛋
  xingFuDan(ActConfig actConfig) async {
    int cmd = actConfig.cmd;
    var initRes = actConfig.initRes;
    if (initRes['result'] == 0) {
      var activity;
      for (var item in initRes['subActivity']) {
        if (item['type'] == 1) {
          activity = item;
          break;
        }
      }
      if (activity != null) {
        if (activity['left'] > 0) {
          var parmas = {
            'request': 3,
            'cmd': cmd,
            'auto': 0,
            'count': 1,
            'index': activity['uniqID'] as int
          };
          if (DateTime.now().millisecondsSinceEpoch / 1000 >
              activity['coolEndT']) {
            await activityOper(actConfig, parmas);
          } else {
            var coolEndT = DateFormat("yyyy-MM-dd HH:mm:ss").format(
                DateTime.fromMillisecondsSinceEpoch(
                    activity['coolEndT'] * 1000));
            showActivityOperSnackBar(actConfig, '冷却时间$coolEndT');
          }
        }
      }
    }
  }

  /// 周末活动
  zhouMoHuoDong(ActConfig actConfig) async {
    int cmd = actConfig.cmd;
    var initRes = actConfig.initRes;
    if (initRes['result'] == 0) {
      for (var i = 0; i < initRes['dailyTask'].length; i++) {
        var item = initRes['dailyTask'][i];

        if (item['done'] >= item['need'] && item['status'] == 0) {
          var parmas = {'request': 2, 'cmd': cmd, 'index': i + 1};

          await activityOper(actConfig, parmas);
        }
      }
    }
  }

  /// 全民吃火锅
  quanMinChiHuoGuo(ActConfig actConfig) async {
    int cmd = actConfig.cmd;
    var initRes = actConfig.initRes;
    if (initRes['result'] == 0) {
      var freeBamboo = initRes['freeBamboo'];
      var freeWood = initRes['freeWood'];
      if (freeWood > 0) {
        var parmas = {
          'paytype': 1,
          'request': 3,
          'cmd': cmd,
          'auto': 0,
          'type': 1,
          'isspecial': 0
        };
        await activityOper(actConfig, parmas);
      }
      if (freeBamboo > 0) {
        var parmas = {
          'paytype': 1,
          'request': 3,
          'cmd': cmd,
          'auto': 0,
          'type': 2,
        };
        await activityOper(actConfig, parmas);
      }
    }
  }

  handleTap(ActConfig actConfig, [bool isBatch = false]) async {
    if (actConfig.cmd != null) {
      var parmas = {'request': 1, 'cmd': actConfig.cmd};
      actConfig.initRes = await activityOper(actConfig, parmas);
      if (actConfig.initRes['result'] != 0) {
        return;
      }
    }
    switch (actConfig.name) {
      case '全民吃火锅':
        await quanMinChiHuoGuo(actConfig);
        break;
      case '周末活动':
        await zhouMoHuoDong(actConfig);
        break;
      case '星愿':
        await xingYuan(actConfig);
        break;
      case '幸福蛋':
        await xingFuDan(actConfig);
        break;
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
      case '弹弹珠':
      case '大富翁':
      case '中秋月圆':
      case '足球小将':
      case '欢乐小黄鸭':
        await commonActivity(actConfig);
        break;
      case '燃花灯':
      case '魔幻夺宝':
      case '拯救兔兔':
      case '致富密码':
        await commonActivity(actConfig, {'index': 1});
        break;
      default:
        showActivityOperSnackBar(
            actConfig, actConfig.isActive ? '活动未实现' : '活动时间未到');
        return;
    }
    if (!isBatch) {
      showActivityOperSnackBar(actConfig, '执行完毕');
    }
  }

  void handleActivity() async {
    for (var item in actConfigs) {
      if (item.isActive) {
        await handleTap(item, true);
      }
    }
    showSnackBar('一键执行完毕');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text('一键完成'),
                  onPressed: handleActivity,
                ),
              ),
            ),
          ],
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
                                    actConfig.name, // + actConfig.id,
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
