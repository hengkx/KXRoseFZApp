import 'package:kx_rose_fz/models/flower.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:xml/xml.dart';

class XE {
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
}
