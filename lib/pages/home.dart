import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/mg.dart';
import '../widgets/plant.dart';
import '../widgets/task.dart';
import '../widgets/setting.dart';
import './exchange.dart';
import './activity.dart';
import './one_key_login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = const MethodChannel('rose.hengkx.com/qq');
  void login() async {
    var qqLoginUrl = await platform.invokeMethod("getQQLoginUrl");
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => LoginPage(url: qqLoginUrl),
    ))
        .then((_) {
      getUserInfo();
    });
  }

  int tabIndex = 0;
  String usernic = '';

  void getUserInfo() async {
    var getUserInfoResponse = await MGUtil.getUserInfo();
    print(getUserInfoResponse.toJson());
    if (getUserInfoResponse.result == 1000005) {
      login();
    } else {
      setState(() {
        usernic = getUserInfoResponse.usernic;
      });
    }
  }

  var _pageList = [
    new Plant(),
    new Activity(),
    new ExchangeWidget(),
    new Task(),
    new SettingWidget(),
  ];

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void showMyMaterialDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text("title"),
            content: new Text("内容内容内容内容内容内容内容内容内容内容内容"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                },
                child: new Text("确认"),
              ),
              new FlatButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                },
                child: new Text("取消"),
              ),
            ],
          );
        });
  }

  getBottomNavigationBarItem(String title, IconData icon) {
    return new BottomNavigationBarItem(
      title: Text(title),
      icon: Icon(icon),
      activeIcon: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          getBottomNavigationBarItem("兑换", Icons.compare_arrows),
          getBottomNavigationBarItem("任务", Icons.assignment),
          getBottomNavigationBarItem("设置", Icons.settings),
        ],
        currentIndex: tabIndex,
        fixedColor: Theme.of(context).primaryColor,
        onTap: (index) {
          setState(() {
            tabIndex = index;
          });
        },
      ),
    );
  }
}
