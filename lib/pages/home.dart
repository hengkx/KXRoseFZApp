import 'package:flutter/material.dart';

import '../utils/mg.dart';
import '../widgets/plant.dart';
import '../widgets/setting.dart';
import './exchange.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void login() {
    Navigator.of(context).pushNamed("/login").then((_) {
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
      this.setState(() {
        usernic = getUserInfoResponse.usernic;
      });
    }
  }

  var _pageList = [
    new Plant(),
    new ExchangeWidget(),
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
        items: [
          getBottomNavigationBarItem("首页", Icons.home),
          getBottomNavigationBarItem("兑换", Icons.compare_arrows),
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
