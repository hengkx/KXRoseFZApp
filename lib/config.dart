import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;

class Config {
  static xml.XmlDocument flowerConfig;
  static xml.XmlDocument roseConfig;
  static xml.XmlDocument propConfig;

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
  }
}
