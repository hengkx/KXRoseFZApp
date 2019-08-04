import 'dart:convert';
import 'dart:io';
import 'package:KXRoseFZApp/user_config.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;
import 'package:path_provider/path_provider.dart';

class Config {
  static xml.XmlDocument flowerConfig;
  static xml.XmlDocument roseConfig;
  static xml.XmlDocument propConfig;
  static UserConfig userConfig;

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
