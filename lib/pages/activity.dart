import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

class _ActivityState extends State<Activity> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Config.init();
    DateTime now = DateTime.now();
    var unixtime = now.millisecondsSinceEpoch / 1000;
    var limit = Config.actGuideConfig.findAllElements('limit').toList()[0];
    for (var item in limit.findAllElements('item')) {
      if (item.getAttribute('start') != null) {
        ActConfig actConfig = ActConfig();
        actConfig.id = item.getAttribute('id');
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
      if (freeCount > 0) {
        // 舞毒蛾  可能需要从insect里面取type 数组的index
        parmas = {
          'request': 3,
          'cmd': 170,
          'auto': 0,
          'page': 1,
          'index': 2,
          'type': 1,
          'pageType': 1
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

  void showActivityOperAward(ActConfig actConfig, List<Map> awards) {
    for (var item in awards) {
      showActivityOperAward(actConfig, '${item.toString()}');
    }
  }

  showActivityOperSnackBar(ActConfig actConfig, String content) {
    showSnackBar('${actConfig.name} $content');
  }

  void handleTap(ActConfig actConfig) async {
    switch (actConfig.name) {
      case '夏日大作战':
        await xiaRiDaZuoZhan(actConfig);
        break;
      case '拯救计划':
        await zhengJiuJiHua(actConfig);
        break;
      case '捕虫大作战':
        await buChongDaZuoZhan(actConfig);
        break;
      default:
        showActivityOperSnackBar(
            actConfig, actConfig.isActive ? '活动未实现' : '活动时间未到');
        return;
    }
    showActivityOperSnackBar(actConfig, '执行完毕');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        var actConfig = actConfigs[index];
        final List<Widget> slideActions = [];
        final List<Widget> slideSecondaryActions = [];
        return Slidable(
          key: ValueKey(actConfig.id),
          controller: slidableController,
          actionPane: SlidableDrawerActionPane(),
          actions: slideActions,
          secondaryActions: slideSecondaryActions,
          enabled: false,
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
                          '${dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(actConfig.start * 1000))} - ${dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(actConfig.end * 1000))}',
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
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return new Container(height: 1.0, color: Colors.grey[300]);
      },
      itemCount: actConfigs.length,
    );
  }
}
