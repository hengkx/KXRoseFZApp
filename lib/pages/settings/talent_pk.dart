import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rose_fz/global.dart';
import 'package:rose_fz/models/flower.dart';
import 'package:rose_fz/widgets/picker.dart';

class TalentPKSetting extends StatefulWidget {
  @override
  _TalentPKSettingState createState() {
    return new _TalentPKSettingState();
  }
}

class _TalentPKSettingState extends State<TalentPKSetting> {
  List<PickerItem> pickerItems = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 4; i++) {
      pickerItems.add(PickerItem(text: i.toString(), value: i));
    }
    init();
  }

  init() async {
    await Global.init();
  }

  var plantTypes = ['土盆', '水盆', '仙盆'];

  getPlantInfo(int index) {
    int id;
    if (index == 0) {
      id = Global.userConfig.earthrPlant;
    } else if (index == 1) {
      id = Global.userConfig.waterPlant;
    } else if (index == 2) {
      id = Global.userConfig.hangPlant;
    }
    if (id != null) {
      return Global.getFlowerInfoById(id).name;
    }
    return '未设置';
  }

  setPlant(Flower flower, int index) {
    if (index == 0) {
      Global.userConfig.earthrPlant = flower.plantId;
    }
    if (index == 1) {
      Global.userConfig.waterPlant = flower.plantId;
    }
    if (index == 2) {
      return Global.userConfig.hangPlant = flower.plantId;
    }
    Global.saveUserConfig();
    setState(() {});
  }

  handleSelect(PickerItem item) {
    print(item.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("竞技场设置"),
      ),
      body: ListView(
        children: <Widget>[
          Picker(
            label: '生命战旗',
            items: pickerItems,
            onSelect: handleSelect,
          ),
        ],
      ),
    );
  }
}
