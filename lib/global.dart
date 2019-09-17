import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math' show Random;
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:rose_fz/models/flower.dart';
import 'package:rose_fz/utils/mg_data.dart';
import 'package:rose_fz/utils/xml.dart';
import 'package:xml/xml.dart';
import 'package:path_provider/path_provider.dart';
import './user_config.dart';

class ExchangeItem {
  final int id;
  final String name;
  ExchangeItem({this.id, this.name});
}

class Global {
  static Map<String, dynamic> config;
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
    if (config == null) {
      config = Map();
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
        var folderPathUrl = loadConfig
            .findAllElements('folderPath')
            .toList()[0]
            .getAttribute('url');
        var actGuideConfigUrl = loadConfig
            .findAllElements('item')
            .where((xe) => xe.getAttribute("id") == 'actGuideConfig')
            .toList()[0]
            .getAttribute('url');
        var flowerConfigUrl = loadConfig
            .findAllElements('item')
            .where((xe) => xe.getAttribute("id") == 'flowerConfig')
            .toList()[0]
            .getAttribute('url');
        var configZipUrl = loadConfig
            .findAllElements('item')
            .where((xe) => xe.getAttribute("id") == 'config_zip')
            .toList()[0]
            .getAttribute('url');

        XmlDocument doc;

        File actGuideConfigFile = File("${directory.path}/$actGuideConfigUrl");
        if (!actGuideConfigFile.existsSync()) {
          res = await dio.get<String>('$folderPathUrl$actGuideConfigUrl');
          actGuideConfigFile.writeAsStringSync(res.data);
          doc = parse(res.data);
        } else {
          doc = parse(actGuideConfigFile.readAsStringSync());
        }

        config['actGuide'] = doc.findAllElements('data').toList()[0];

        File flowerConfigFile = File("${directory.path}/$flowerConfigUrl");
        if (!flowerConfigFile.existsSync()) {
          res = await dio.get<String>('$folderPathUrl$flowerConfigUrl');
          flowerConfigFile.writeAsStringSync(res.data);
          doc = parse(res.data);
        } else {
          doc = parse(flowerConfigFile.readAsStringSync());
        }
        config['flower'] = doc.findAllElements('flower').toList()[0];
        config['variationFlowerSeed'] =
            doc.findAllElements('variationFlowerSeed').toList()[0];

        File configZipFile = File("${directory.path}/$configZipUrl");
        var configFileDir = Directory(
            "${directory.path}/${configZipUrl.replaceAll('.game', '')}");
        if (!configZipFile.existsSync()) {
          await dio.download('$folderPathUrl$configZipUrl', configZipFile.path);
        }
        // 判断配置压缩包有没有解压
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
        configFileDir.listSync().forEach((fse) {
          File file = File(fse.path);
          var key = file.path
              .substring(file.path.lastIndexOf('/') + 1)
              .replaceAll('.xml', '');
          doc = parse(file.readAsStringSync());
          switch (key) {
            case 'propConfig':
              config['prop'] = doc.findAllElements('propConfig').toList()[0];
              config['special'] = doc.findAllElements('special').toList()[0];
              config['meterial'] = doc.findAllElements('meterial').toList()[0];
              config['decoration'] =
                  doc.findAllElements('decrateConfig').toList()[0];
              config['otherProps'] =
                  doc.findAllElements('otherProps').toList()[0];
              config['bouquet'] = doc.findAllElements('bouquet').toList()[0];
              break;
            case 'ruleConfig':
              config['gameRules'] =
                  doc.findAllElements('ruleConfig').toList()[0];
              config['gameExpLevel'] =
                  doc.findAllElements('expLevel').toList()[0];
              break;
            case 'adventureConfig':
              config['adventureEvent'] =
                  doc.findAllElements('AdventureEvent').toList()[0];
              config['adventureMap'] =
                  doc.findAllElements('AdventureMap').toList()[0];
              break;
            case 'pergolaDecorateCfg':
              var decorateCfgs = XML.toDecorate(doc);
              config['shelf'] = Map();
              config['shelf']['decorate'] = decorateCfgs[0];
              config['shelf']['patch'] = decorateCfgs[1];
              break;
            default:
              config[key.replaceAll('Config', '')] = doc.rootElement;
              break;
          }
        });
      }
      MGDataUtil.initInfoMap();
    }
  }

  static saveUserConfig() async {
    final directory = await getApplicationDocumentsDirectory();
    final userConfigPath = "${directory.path}/userConfig.json";

    File file = File(userConfigPath);
    print(json.encode(Global.userConfig));
    file.writeAsStringSync(json.encode(Global.userConfig));
  }

  /// 通过种子id查询鲜花信息
  static XmlElement getFlowerInfoBySeedId(int id) {
    var res = Global.config['flower']
        .findAllElements("item")
        .where((xe) => xe.getAttribute("seedID") == "$id")
        .toList();
    if (res.length > 0) {
      return res[0];
    }
    return null;
  }

  static Flower getFlowerInfoById(int id) {
    var res = Global.config['flower']
        .findAllElements("item")
        .where((xe) => xe.getAttribute("id") == "$id")
        .toList();
    if (res.length == 0) {
      res = Global.config['rose']
          .findAllElements("item")
          .where((xe) => xe.getAttribute("id") == "$id")
          .toList();
    }
    if (res.length > 0) {
      return XML.toFlower(res[0]);
    }
    return null;
  }

  static XmlElement getPropById(int id) {
    var res = Global.config['prop']
        .findAllElements("item")
        .where((xe) =>
            xe.getAttribute("id") == "$id" || xe.getAttribute("svrID") == "$id")
        .toList();
    if (res.length > 0) {
      return res[0];
    }
    return null;
  }

  static XmlElement getPetPKById(int id) {
    var res = Global.config['propConfig']
        .findAllElements("item")
        .where((xe) => xe.getAttribute("id") == "$id")
        .toList();
    if (res.length > 0) {
      return res[0];
    }
    return null;
  }

  static XmlElement getPergolaDecorateById(int id) {
    var res = Global.config['pergolaDecorateConfig']
        .findAllElements("item")
        .where((xe) => xe.getAttribute("id") == "$id")
        .toList();
    if (res.length > 0) {
      return res[0];
    }
    return null;
  }
}
