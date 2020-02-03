import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
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

class Warehouse extends StatefulWidget {
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

class _ActivityState extends State<Warehouse> {
  @override
  void initState() {
    super.initState();

    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      switch (event) {
        case RewardedVideoAdEvent.loaded:
          RewardedVideoAd.instance.show();
          break;
        case RewardedVideoAdEvent.failedToLoad:
          //读取失败！
          showSnackBar("加载失败");
          break;
        case RewardedVideoAdEvent.opened:
          break;
        case RewardedVideoAdEvent.leftApplication:
          break;
        case RewardedVideoAdEvent.closed:
          showSnackBar("关闭");
          break;
        case RewardedVideoAdEvent.rewarded:
          showSnackBar("奖励");
          break;
        case RewardedVideoAdEvent.started:
          showSnackBar("开始");
          break;
        case RewardedVideoAdEvent.completed:
          showSnackBar("播放结束");
          break;
      }
    };
  }

  showSnackBar(String tip) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(tip),
      duration: Duration(seconds: 1),
    ));
  }

  void handleActivity() async {
    RewardedVideoAd.instance.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-6326384735097338/5666161357'
          : 'ca-app-pub-6326384735097338/7963638745',
      targetingInfo: Global.targetingInfo,
    );
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
                  child: new Text('测试广告'),
                  onPressed: handleActivity,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
