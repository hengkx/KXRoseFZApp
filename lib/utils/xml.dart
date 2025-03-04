import 'package:rose_fz/models/decorate_config.dart';
import 'package:rose_fz/models/flower.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:xml/xml.dart';

class XML {
  static Flower toFlower(XmlElement item) {
    var plantId = int.parse(item.getAttribute("id"));
    String combineId = item.getAttribute("combineid");
    int type = int.parse(item.getAttribute("type") ?? "99");
    int potLevel = int.parse(item.getAttribute("potLevel") ?? "0");
    int season = int.parse(item.getAttribute("season") ?? "0");
    var seedId = int.parse(item.getAttribute("seedID") ?? '0');
    int seedPrice = int.parse(item.getAttribute("seedPrice"));
    var name = item.getAttribute("name");
    var times = item.getAttribute("times");
    var multiSeason = item.getAttribute("multiSeason");
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
      combineId: combineId,
      times: times,
      multiSeason: multiSeason,
    );

    return flower;
  }

  static List<Map<int, DecorateConfig>> toDecorate(XmlDocument doc) {
    Map<int, DecorateConfig> decorate = Map();
    Map<int, DecorateConfig> patch = Map();
    for (var item in doc
        .findAllElements('decorate')
        .toList()[0]
        .findAllElements('item')) {
      var decorateConfig = DecorateConfig(
        id: int.parse(item.getAttribute('id')),
        name: item.getAttribute('name'),
        desc: item.getAttribute('desc'),
        requireLv: int.parse(item.getAttribute('requireLv')),
      );
      if (item.getAttribute('period') != null) {
        decorateConfig.period = int.parse(item.getAttribute('period'));
        decorateConfig.type = 1;
      }
      if (item.getAttribute('prizeQB') != null) {
        decorateConfig.prizeQB = int.parse(item.getAttribute('prizeQB'));
      }
      decorate[decorateConfig.id] = decorateConfig;
    }
    for (var item
        in doc.findAllElements('patch').toList()[0].findAllElements('item')) {
      var decorateConfig = DecorateConfig(
        id: int.parse(item.getAttribute('id')),
        name: item.getAttribute('name'),
        desc: item.getAttribute('desc'),
      );
      if (item.getAttribute('type') != null) {
        decorateConfig.type = int.parse(item.getAttribute('type'));
      }
      patch[decorateConfig.id] = decorateConfig;
    }
    return [decorate, patch];
  }
}
