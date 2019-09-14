import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kx_rose_fz/utils/db.dart';
import 'package:kx_rose_fz/utils/uin_crypt.dart';
import 'package:package_info/package_info.dart';
import '../user.dart';
import '../utils/mg.dart';
import '../widgets/plant.dart';
import '../widgets/task.dart';
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

  @override
  void initState() {
    super.initState();
    getUserInfo();
    init();
  }

  int tabIndex = 0;
  PackageInfo packageInfo;
  String version;
  init() async {
    packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = packageInfo.version;
    });
  }

  void getUserInfo() async {
    var getUserInfoResponse = await MGUtil.getUserInfo();
    User.initFirstRes = await MGUtil.getInitFirst();
    User.userInfo = getUserInfoResponse;
    if (getUserInfoResponse.result == 1000005) {
      login();
    }
    setState(() {
      tabIndex = 0;
    });
  }

  var _pageList = [
    PlantWidget(),
    Activity(),
    ExchangeWidget(),
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
        Navigator.of(context).pushNamed(url);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // var db = DBUtil();
    // db.getAllRequestLogs( limit: 1, offset: 0).then((val) {
    //   print(val);
    // });
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
          children: <Widget>[
            Container(
              height: 100,
              child: UserAccountsDrawerHeader(
                accountName: Text(User.userInfo?.usernic ?? '未登录'),
                accountEmail:
                    Text('${UinCrypt.decryptUin('${User.userInfo?.uin}')}'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
            getDrawerItem('默认种植设置', '/settings/plant'),
            getDrawerItem('加速化肥设置', '/settings/speed'),
            getDrawerItem('切换帐号', '/login'),
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
  }
}
