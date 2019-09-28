import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rose_fz/global.dart';
import 'package:rose_fz/pages/talent_pk.dart';
import 'package:rose_fz/store/index.dart';
import 'package:rose_fz/store/models/user_model.dart';
import 'package:package_info/package_info.dart';
import '../user.dart';
import '../utils/mg.dart';
import '../widgets/plant.dart';
import '../widgets/task.dart';
import './activity.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = const MethodChannel('rose.hengkx.com/qq');
  void login() async {
    // var qqLoginUrl = await platform.invokeMethod("getQQLoginUrl");
    // Navigator.of(context)
    //     .push(MaterialPageRoute(
    //   builder: (context) => LoginPage(url: qqLoginUrl),
    // ))
    //     .then((_) {
    //   getUserInfo();
    // });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(
        appId: Platform.isAndroid
            ? 'ca-app-pub-6326384735097338~9850326329'
            : 'ca-app-pub-6326384735097338~4924544925',
        analyticsEnabled: true);
    init();
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['玫瑰小镇', '休闲', '网页游戏', '种花'],
      childDirected: false,
      testDevices: <String>[
        '6E12CFF42AD75DB204F205C78113B0D2',
        '500127c8dad2d2f05a12a1c733e8f888'
      ], // Android emulators are considered test devices
    );
    var myInterstitial = InterstitialAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-6326384735097338/2687195758'
          : 'ca-app-pub-6326384735097338/4843968696',
      targetingInfo: targetingInfo,
    );
    myInterstitial
      ..load()
      ..show(
        anchorOffset: 0,
        horizontalCenterOffset: 0,
        anchorType: AnchorType.bottom,
      );
  }

  int tabIndex = 0;
  PackageInfo packageInfo;
  String version;
  init() async {
    packageInfo = await PackageInfo.fromPlatform();
    await Global.init();
    setState(() {
      version = packageInfo.version;
    });
    getUserInfo();
  }

  void getUserInfo() async {
    User.initFirstRes = await MGUtil.getInitFirst();
    setState(() {
      tabIndex = 0;
    });
    var res = await Store.value<UserModel>(context).getUserInfo();
    if (res.result != 0) {
      Store.value<UserModel>(context).login(context);
    }
  }

  var _pageList = [
    PlantWidget(),
    Activity(),
    TalentPKPage(),
    Task(),
  ];

  getBottomNavigationBarItem(String title, IconData icon) {
    return BottomNavigationBarItem(
      title: Text(title),
      icon: Icon(icon),
      activeIcon: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  getDrawerItem(String title, String url) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(url).then((_) {
          if (url.contains('login')) {
            getUserInfo();
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, userModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("开心小镇 - by hengkx"),
          ),
          body: _pageList[tabIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed, // 不设置超过3个后未选中不显示出来
            items: [
              getBottomNavigationBarItem("首页", Icons.home),
              getBottomNavigationBarItem("活动", Icons.assistant),
              getBottomNavigationBarItem("竞技场", Icons.add_box),
              getBottomNavigationBarItem("任务", Icons.assignment),
            ],
            currentIndex: tabIndex,
            fixedColor: Theme.of(context).primaryColor,
            onTap: (index) {
              setState(() {
                tabIndex = index;
              });
            },
          ),
          drawer: Drawer(
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                Container(
                  height: 124,
                  child: UserAccountsDrawerHeader(
                    accountName: Text(userModel.user?.name ?? '未登录'),
                    accountEmail: Text('${userModel.user?.uin}'),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                ),
                getDrawerItem('默认种植设置', '/settings/plant'),
                getDrawerItem('加速化肥设置', '/settings/speed'),
                getDrawerItem('竞技场设置', '/settings/pk'),
                getDrawerItem('日志', '/log'),
                getDrawerItem('万能种子兑换', '/exchange'),
                ListTile(
                  title: Text('切换帐号'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    userModel.switchLogin(context);
                  },
                ),
                Text(
                  "版本：$version",
                  textAlign: TextAlign.center,
                ),
                Text(
                  "QQ交流群：276801258",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
