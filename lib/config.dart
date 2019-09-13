import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math' show Random;
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:kx_rose_fz/pages/select_flower.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:xml/xml.dart';
import 'package:path_provider/path_provider.dart';
import './user_config.dart';

class ExchangeItem {
  final int id;
  final String name;
  ExchangeItem({this.id, this.name});
}

class Config {
  static XmlDocument flowerConfig;
  static XmlDocument roseConfig;
  static XmlDocument propConfig;
  static XmlDocument taskConfig;
  static XmlDocument actGuideConfig;
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
          'https://meigui.qq.com/Strategy.xml?v=${Random().nextDouble()}');

      final items = parse(res.data).findAllElements('item').toList();
      if (items.length > 0) {
        final loadConfigUrl = items[0].getAttribute('url').replaceAll('./', '');
        final loadConfigPath = "${directory.path}/$loadConfigUrl";
        File loadConfigFile = File(loadConfigPath);
        XmlDocument loadConfig;
        if (!loadConfigFile.existsSync()) {
          res = await dio.get<String>('https://meigui.qq.com/$loadConfigUrl');
          loadConfigFile.writeAsStringSync(res.data);
          loadConfig = parse(res.data);
        } else {
          loadConfig = parse(loadConfigFile.readAsStringSync());
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
          actGuideConfig = parse(res.data);
        } else {
          actGuideConfig = parse(actGuideConfigFile.readAsStringSync());
        }

        File flowerConfigFile = File("${directory.path}/$flowerConfigUrl");
        if (!flowerConfigFile.existsSync()) {
          res = await dio.get<String>('$folderPathUrl$flowerConfigUrl');
          flowerConfigFile.writeAsStringSync(res.data);
          flowerConfig = parse(res.data);
        } else {
          flowerConfig = parse(flowerConfigFile.readAsStringSync());
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

        roseConfig = parse(
            File('${configFileDir.path}/roseConfig.xml').readAsStringSync());
        taskConfig = parse(
            File('${configFileDir.path}/taskConfig.xml').readAsStringSync());
        propConfig = parse(
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

  /// 通过种子id查询鲜花信息
  static XmlElement getFlowerInfoBySeedId(int id) {
    var res = Config.flowerConfig
        .findAllElements("item")
        .where((xe) => xe.getAttribute("seedID") == "$id")
        .toList();
    if (res.length > 0) {
      return res[0];
    }
    return null;
  }

  static Flower xeToFlower(XmlElement item) {
    var plantId = int.parse(item.getAttribute("id"));
    int type = int.parse(item.getAttribute("type") ?? "99");
    int potLevel = int.parse(item.getAttribute("potLevel") ?? "0");
    int season = int.parse(item.getAttribute("season") ?? "0");
    var seedId = int.parse(item.getAttribute("seedID"));
    int seedPrice = int.parse(item.getAttribute("seedPrice"));
    var name = item.getAttribute("name");
    var flower = Flower(
      plantId: plantId,
      seedId: seedId,
      type: type,
      season: season,
      potLevel: potLevel,
      seedPrice: seedPrice,
      seedPriceQPoint: int.parse(item.getAttribute("seedPriceQPoint")),
      pyName: PinyinHelper.getShortPinyin(name),
      name: name,
    );

    return flower;
  }

  static Flower getFlowerInfoById(int id) {
    var res = Config.flowerConfig
        .findAllElements("item")
        .where((xe) => xe.getAttribute("id") == "$id")
        .toList();
    if (res.length == 0) {
      res = Config.roseConfig
          .findAllElements("item")
          .where((xe) => xe.getAttribute("id") == "$id")
          .toList();
    }
    if (res.length > 0) {
      return xeToFlower(res[0]);
    }
    return null;
  }

  static XmlElement getPropById(int id) {
    var res = Config.propConfig
        .findAllElements("item")
        .where((xe) =>
            xe.getAttribute("id") == "$id" || xe.getAttribute("svrID") == "$id")
        .toList();
    if (res.length > 0) {
      return res[0];
    }
    return null;
  }
}
