import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingWidget extends StatefulWidget {
  @override
  _SettingWidgetState createState() {
    return new _SettingWidgetState();
  }
}

class _SettingWidgetState extends State<SettingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, 0),
      child: Column(
        children: <Widget>[
          Text("QQ交流群：276801258"),
          Text("交花友：519872449"),
          Text("版本：V 0.1.0"),
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
