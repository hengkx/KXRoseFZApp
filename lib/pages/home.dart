import 'package:flutter/material.dart';

import '../utils/mg.dart';
import '../widgets/plant.dart';
import '../widgets/setting.dart';

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

  int choiceIndex = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("开心玫瑰辅助 - by hengkx"),
      ),
      body: usernic != ''
          ? (choiceIndex == 0 ? Plant() : SettingWidget())
          : Text("请先登录"),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                "首页",
              ),
              activeIcon: Icon(
                Icons.home,
                color: Theme.of(context).primaryColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text(
                "设置",
              ),
              activeIcon: Icon(
                Icons.settings,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
          currentIndex: choiceIndex,
          fixedColor: Theme.of(context).primaryColor,
          onTap: (index) {
            if (index == 0) {
              setState(() {
                choiceIndex = 0;
              });
            } else {
              setState(() {
                choiceIndex = 1;
              });
            }
          }),
    );
  }
}
