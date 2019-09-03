import 'dart:convert';
import 'dart:io';
import 'package:KXRoseFZApp/user_config.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;
import 'package:path_provider/path_provider.dart';

class ExchangeItem {
  final int id;
  final String name;
  ExchangeItem({this.id, this.name});
}

class Config {
  static xml.XmlDocument flowerConfig;
  static xml.XmlDocument roseConfig;
  static xml.XmlDocument propConfig;
  static xml.XmlDocument taskConfig;
  static UserConfig userConfig;

  static List<ExchangeItem> exhanges = [
    ExchangeItem(id: 1, name: "红玫瑰种子"),
    ExchangeItem(id: 2, name: "白玫瑰种子"),
    ExchangeItem(id: 3, name: "黄玫瑰种子"),
    ExchangeItem(id: 4, name: "粉玫瑰种子"),
    ExchangeItem(id: 5, name: "蓝玫瑰种子"),
    ExchangeItem(id: 6, name: "橙玫瑰种子"),
    ExchangeItem(id: 7, name: "紫玫瑰种子"),
    ExchangeItem(id: 8, name: "绿玫瑰种子"),
    ExchangeItem(id: 9, name: "黑玫瑰种子"),
    ExchangeItem(id: 22001, name: "青玫瑰种子"),
    ExchangeItem(id: 22002, name: "香槟玫瑰种子"),
  ];

  static init() async {
    if (flowerConfig == null) {
      String flowerConfigXml =
          await rootBundle.loadString('assets/flowerConfig.xml');
      flowerConfig = xml.parse(flowerConfigXml);
    }

    if (roseConfig == null) {
      String roseConfigXml =
          await rootBundle.loadString('assets/roseConfig.xml');
      roseConfig = xml.parse(roseConfigXml);
    }

    if (propConfig == null) {
      String propConfigXml =
          await rootBundle.loadString('assets/propConfig.xml');
      propConfig = xml.parse(propConfigXml);
    }

    if (taskConfig == null) {
      String taskConfigXml =
          await rootBundle.loadString('assets/taskConfig.xml');
      taskConfig = xml.parse(taskConfigXml);
    }

    if (userConfig == null) {
      final directory = await getApplicationDocumentsDirectory();
      final userConfigPath = "${directory.path}/userConfig.json";

      File file = new File(userConfigPath);
      String userConfigJson = "";
      if (!await file.exists()) {
        userConfigJson = await rootBundle.loadString('assets/userConfig.json');
      } else {
        userConfigJson = await file.readAsString();
      }
      userConfig = UserConfig.fromJson(json.decode(userConfigJson));
    }
  }

  static saveUserConfig() async {
    final directory = await getApplicationDocumentsDirectory();
    final userConfigPath = "${directory.path}/userConfig.json";

    File file = new File(userConfigPath);
    print(json.encode(Config.userConfig));
    file.writeAsStringSync(json.encode(Config.userConfig));
  }
}
