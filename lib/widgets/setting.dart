import 'dart:math';
import '../user_config.dart';
import '../widgets/text_field_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';

import '../config.dart';

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
    print(Config.userConfig.toJson());
  }

  PackageInfo packageInfo;
  String version;
  init() async {
    packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = packageInfo.version;
    });
  }

  _onReorder(int oldIndex, int newIndex) {
    print('oldIndex: $oldIndex , newIndex: $newIndex');
    setState(() {
      if (newIndex == Config.userConfig.speeds.length) {
        newIndex = Config.userConfig.speeds.length - 1;
      }
      var item = Config.userConfig.speeds.removeAt(oldIndex);
      Config.userConfig.speeds.insert(newIndex, item);
      saveConfig();
    });
  }

  showSettingTimeDialog(SpeedFertilizer speedFertilizer) {
    showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return TextFieldAlertDialog(
          context: context,
          title: "设置时间",
          value: "${speedFertilizer.time}",
        );
      },
    ).then((String text) {
      if (text != null) {
        setState(() {
          speedFertilizer.time = int.parse(text);
          saveConfig();
        });
      }
    });
  }

  saveConfig() {
    Config.saveUserConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, 0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ReorderableListView(
              header: Container(
                height: 50,
                padding: EdgeInsets.only(left: 15),
                color: Colors.grey[200],
                alignment: Alignment(-1, 0),
                child: Text("加速化肥"),
              ),
              children: Config.userConfig.speeds
                  .map((item) => Row(
                        key: ObjectKey(item),
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              title: Text(item.name),
                              value: item.use,
                              secondary: IconButton(
                                icon: Icon(Icons.settings),
                                color: Colors.blueAccent,
                                onPressed: () {
                                  showSettingTimeDialog(item);
                                },
                              ),
                              subtitle: Text("大于 ${item.time} 分钟使用"),
                              onChanged: (bool value) {
                                setState(() {
                                  item.use = !item.use;
                                  saveConfig();
                                });
                              },
                            ),
                          ),
                        ],
                      ))
                  .toList(),
              onReorder: _onReorder,
            ),
          ),
          Text("QQ交流群：276801258"),
          Text("交花友：519872449"),
          Text("版本：$version"),
          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: new Text('切换帐号'),
            onPressed: () {
              Navigator.of(context).pushNamed("/login");
            },
          )
        ],
      ),
    );
  }
}
