import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;

class Config {
  static xml.XmlDocument flowerConfig;
  static xml.XmlDocument roseConfig;
  static xml.XmlDocument propConfig;

  static init() async {
    String flowerConfigXml =
        await rootBundle.loadString('assets/flowerConfig.xml');
    flowerConfig = xml.parse(flowerConfigXml);

    String roseConfigXml = await rootBundle.loadString('assets/roseConfig.xml');
    roseConfig = xml.parse(roseConfigXml);

    String propConfigXml = await rootBundle.loadString('assets/propConfig.xml');
    propConfig = xml.parse(propConfigXml);
  }
}
