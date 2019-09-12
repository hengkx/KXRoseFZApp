import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math' show Random;
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:xml/xml.dart' as xml;
import 'package:path_provider/path_provider.dart';
import './user_config.dart';

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
    final directory = await getApplicationDocumentsDirectory();
    final cfgDir = new Directory('${directory.path}/config');
    if (!cfgDir.existsSync()) {
      cfgDir.createSync();
    }
    print(cfgDir.path);
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
    if (actGuideConfig == null ||
        flowerConfig == null ||
        propConfig == null ||
        roseConfig == null ||
        taskConfig == null) {
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
        var flowerConfigUrl = '';
        var configZipUrl = '';
        for (var item in loadConfig.findAllElements('folderPath')) {
          folderPathUrl = item.getAttribute('url');
          break;
        }
        for (var item in loadConfig.findAllElements('item')) {
          if (actGuideConfigUrl != '' &&
              flowerConfigUrl != '' &&
              configZipUrl != '') {
            break;
          }
          if (item.getAttribute('id') == 'actGuideConfig') {
            actGuideConfigUrl = item.getAttribute('url');
          } else if (item.getAttribute('id') == 'flowerConfig') {
            flowerConfigUrl = item.getAttribute('url');
          } else if (item.getAttribute('id') == 'config_zip') {
            configZipUrl = item.getAttribute('url');
          }
        }
        File actGuideConfigFile = File("${directory.path}/$actGuideConfigUrl");
        if (!actGuideConfigFile.existsSync()) {
          res = await dio.get<String>('$folderPathUrl$actGuideConfigUrl');
          actGuideConfigFile.writeAsStringSync(res.data);
          actGuideConfig = xml.parse(res.data);
        } else {
          actGuideConfig = xml.parse(actGuideConfigFile.readAsStringSync());
        }

        File flowerConfigFile = File("${directory.path}/$flowerConfigUrl");
        if (!flowerConfigFile.existsSync()) {
          res = await dio.get<String>('$folderPathUrl$flowerConfigUrl');
          flowerConfigFile.writeAsStringSync(res.data);
          flowerConfig = xml.parse(res.data);
        } else {
          flowerConfig = xml.parse(flowerConfigFile.readAsStringSync());
        }

        File configZipFile = File("${directory.path}/$configZipUrl");
        var configFileDir = Directory(
            "${directory.path}/${configZipUrl.replaceAll('.game', '')}");
        if (!configZipFile.existsSync()) {
          await dio.download('$folderPathUrl$configZipUrl', configZipFile.path);
        }
        if (!configFileDir.existsSync()) {
          List<int> bytes = configZipFile.readAsBytesSync();
          Archive archive = ZipDecoder().decodeBytes(bytes);
          for (ArchiveFile file in archive) {
            String filename = file.name;
            if (file.isFile) {
              List<int> data = file.content;
              File('${configFileDir.path}/$filename')
                ..createSync(recursive: true)
                ..writeAsBytesSync(data);
            } else {
              Directory('${configFileDir.path}/$filename')
                ..create(recursive: true);
            }
          }
        }

        roseConfig = xml.parse(
            File('${configFileDir.path}/roseConfig.xml').readAsStringSync());
        taskConfig = xml.parse(
            File('${configFileDir.path}/taskConfig.xml').readAsStringSync());
        propConfig = xml.parse(
            File('${configFileDir.path}/propConfig.xml').readAsStringSync());
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
