import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';

class SettingWidget extends StatefulWidget {
  @override
  _SettingWidgetState createState() {
    return new _SettingWidgetState();
  }
}

class _SettingWidgetState extends State<SettingWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  PackageInfo packageInfo;
  String version;
  init() async {
    packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, 0),
      child: Column(
        children: <Widget>[
          Text("QQ交流群：276801258"),
          Text("交花友：519872449"),
          Text("版本：$version"),
          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: new Text('切换登录'),
            onPressed: () {
              Navigator.of(context).pushNamed("/login");
            },
          )
        ],
      ),
    );
  }
}
