import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rose_fz/global.dart';
import 'package:rose_fz/models/flower.dart';
import 'package:rose_fz/widgets/picker.dart';

final List<PickerItem> warFlags = [
  PickerItem(value: 1, text: '生命战旗'),
  PickerItem(value: 2, text: '攻击战旗'),
  PickerItem(value: 3, text: '暴击战旗'),
  PickerItem(value: 4, text: '闪避战旗'),
];

final List<PickerItem> trainPets = [
  PickerItem(value: 5, text: '土布鸟'),
  PickerItem(value: 1, text: '小火猴'),
  PickerItem(value: 2, text: '水水兔'),
  PickerItem(value: 3, text: '木木熊'),
  PickerItem(value: 4, text: '金多鼠'),
  PickerItem(value: 6, text: '侦查狗'),
];

class TalentPKSetting extends StatefulWidget {
  @override
  _TalentPKSettingState createState() {
    return new _TalentPKSettingState();
  }
}

class _TalentPKSettingState extends State<TalentPKSetting> {
  List<PickerItem> pickerItems = [];
  List<PickerItem> trainPetPickerItems = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 4; i++) {
      pickerItems.add(PickerItem(text: i.toString(), value: i));
    }
    for (var i = 0; i < 3; i++) {
      trainPetPickerItems.add(PickerItem(text: i.toString(), value: i));
    }
    init();
  }

  init() async {
    await Global.init();
  }

  handleWarFlagChange(int index, PickerItem item) {
    setState(() {
      Global.userConfig.warFlags[index] = item?.value ?? 0;
      Global.saveUserConfig();
    });
  }

  handlePetChange(int index, PickerItem item) {
    setState(() {
      Global.userConfig.trainPets[index] = item?.value ?? 0;
      Global.saveUserConfig();
    });
  }

  handleContactPetChange(int index, PickerItem item) {
    setState(() {
      Global.userConfig.contractPets[index] = item?.value ?? 0;
      Global.saveUserConfig();
    });
  }

  handleQualityChange(PickerItem item) {
    setState(() {
      Global.userConfig.quality = item?.value;
      Global.saveUserConfig();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    items.add(Container(
      margin: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(
                  '战旗',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
    warFlags.forEach((item) {
      items.add(Picker(
        label: item.text,
        items: pickerItems,
        value: Global.userConfig.warFlags[item.value] ?? 0,
        onChange: (val) => handleWarFlagChange(item.value, val),
      ));
    });
    items.add(Container(
      margin: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(
                  '训练',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
    trainPets.forEach((item) {
      items.add(Picker(
        label: item.text,
        items: trainPetPickerItems,
        value: Global.userConfig.trainPets[item.value] ?? 0,
        onChange: (val) => handlePetChange(item.value, val),
      ));
    });
    items.add(Container(
      margin: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(
                  '品质',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
    items.add(Picker(
      label: '提升品质',
      items: trainPets,
      value: Global.userConfig.quality,
      onChange: handleQualityChange,
    ));
    items.add(Container(
      margin: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(
                  '契约',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
    trainPets.forEach((item) {
      items.add(Picker(
        label: item.text,
        items: pickerItems,
        value: Global.userConfig.contractPets[item.value] ?? 0,
        onChange: (val) => handleContactPetChange(item.value, val),
      ));
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("竞技场设置"),
      ),
      body: ListView(
        children: items,
      ),
    );
  }
}
