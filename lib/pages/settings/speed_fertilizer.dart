import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../user_config.dart';
import '../../widgets/text_field_alert.dart';
import '../../global.dart';

class SpeedFertilizerSetting extends StatefulWidget {
  @override
  _SpeedFertilizerSettingState createState() {
    return new _SpeedFertilizerSettingState();
  }
}

class _SpeedFertilizerSettingState extends State<SpeedFertilizerSetting> {
  _onReorder(int oldIndex, int newIndex) {
    print('oldIndex: $oldIndex , newIndex: $newIndex');
    setState(() {
      if (newIndex == Global.userConfig.speeds.length) {
        newIndex = Global.userConfig.speeds.length - 1;
      }
      var item = Global.userConfig.speeds.removeAt(oldIndex);
      Global.userConfig.speeds.insert(newIndex, item);
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
    Global.saveUserConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("加速化肥设置"),
      ),
      body: ReorderableListView(
        children: Global.userConfig.speeds
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
                    )
                  ],
                ))
            .toList(),
        onReorder: _onReorder,
      ),
    );
  }
}
