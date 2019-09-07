import 'dart:convert';
import 'dart:io';
import './user_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;
import 'package:path_provider/path_provider.dart';
import 'dart:math' show Random;

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
  static xml.XmlDocument actGuideConfig;
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

    final directory = await getApplicationDocumentsDirectory();
    if (userConfig == null) {
      final userConfigPath = "${directory.path}/userConfig.json";

      File file = File(userConfigPath);
      String userConfigJson = "";
      if (!await file.exists()) {
        userConfigJson = await rootBundle.loadString('assets/userConfig.json');
      } else {
        userConfigJson = await file.readAsString();
      }
      userConfig = UserConfig.fromJson(json.decode(userConfigJson));
    }
    if (actGuideConfig == null) {
      Dio dio = new Dio();
      var res = await dio.get<String>(
          'https://meigui.qq.com/Strategy.xml?v=${new Random().nextDouble()}');

      final items = xml.parse(res.data).findAllElements('item').toList();
      if (items.length > 0) {
        final loadConfigUrl = items[0].getAttribute('url').replaceAll('./', '');
        final loadConfigPath = "${directory.path}/$loadConfigUrl";
        File loadConfigFile = File(loadConfigPath);
        xml.XmlDocument loadConfig;
        if (!loadConfigFile.existsSync()) {
          res = await dio.get<String>('https://meigui.qq.com/$loadConfigUrl');
          loadConfigFile.writeAsStringSync(res.data);
          loadConfig = xml.parse(res.data);
        } else {
          loadConfig = xml.parse(loadConfigFile.readAsStringSync());
        }
        var folderPathUrl = '';
        var actGuideConfigUrl = '';
        for (var item in loadConfig.findAllElements('folderPath')) {
          folderPathUrl = item.getAttribute('url');
          break;
        }
        for (var item in loadConfig.findAllElements('item')) {
          if (item.getAttribute('id') == 'actGuideConfig') {
            actGuideConfigUrl = item.getAttribute('url');
            break;
          }
        }
        File actGuideConfigFile = File(
            "${directory.path}/${actGuideConfigUrl.replaceAll('config/', '')}");
        if (!actGuideConfigFile.existsSync()) {
          res = await dio.get<String>('$folderPathUrl$actGuideConfigUrl');
          actGuideConfigFile.writeAsStringSync(res.data);
          actGuideConfig = xml.parse(res.data);
        } else {
          actGuideConfig = xml.parse(actGuideConfigFile.readAsStringSync());
        }
      }
    }
  }

  static saveUserConfig() async {
    final directory = await getApplicationDocumentsDirectory();
    final userConfigPath = "${directory.path}/userConfig.json";

    File file = File(userConfigPath);
    print(json.encode(Config.userConfig));
    file.writeAsStringSync(json.encode(Config.userConfig));
  }
}
