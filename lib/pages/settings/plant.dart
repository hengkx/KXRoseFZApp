import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rose_fz/global.dart';
import 'package:rose_fz/models/flower.dart';
import 'package:rose_fz/pages/select_flower.dart';

class PlantSetting extends StatefulWidget {
  @override
  _PlantSettingState createState() {
    return new _PlantSettingState();
  }
}

class _PlantSettingState extends State<PlantSetting> {
  @override
  void initState() {
    super.initState();
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
      Global.userConfig.hangPlant = flower.plantId;
    }
    Global.saveUserConfig();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("种植设置"),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(plantTypes[index]),
            subtitle: Text(getPlantInfo(index)),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.of(context)
                  .push<Flower>(MaterialPageRoute(
                builder: (context) => SelectFlowerPage(),
              ))
                  .then((Flower flower) {
                setPlant(flower, index);
              });
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return new Container(height: 1.0, color: Colors.grey[300]);
        },
        itemCount: 3,
      ),
    );
  }
}
