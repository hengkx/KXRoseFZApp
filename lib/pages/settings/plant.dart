import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../user_config.dart';
import '../../widgets/text_field_alert.dart';
import '../../config.dart';
import '../select_flower.dart';

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
    await Config.init();
  }

  var plantTypes = ['土盆', '水盆', '仙盆'];

  getPlantInfo(int index) {
    int id;
    if (index == 0) {
      id = Config.userConfig.earthrPlant;
    } else if (index == 1) {
      id = Config.userConfig.waterPlant;
    } else if (index == 2) {
      id = Config.userConfig.hangPlant;
    }
    if (id != null) {
      return Config.getFlowerInfoById(id).name;
    }
    return '未设置';
  }

  setPlant(Flower flower, int index) {
    if (index == 0) {
      Config.userConfig.earthrPlant = flower.plantId;
    }
    if (index == 1) {
      Config.userConfig.waterPlant = flower.plantId;
    }
    if (index == 2) {
      return Config.userConfig.hangPlant = flower.plantId;
    }
    Config.saveUserConfig();
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
