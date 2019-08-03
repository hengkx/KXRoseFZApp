import 'package:xml/xml.dart';

import 'config.dart';

class Soil {
  int no;

  /// 种植时间
  DateTime plantTime;

  /// 收获时间
  DateTime gainTime;
  String plantShowName;
  int type;

  /// 50 枯萎 51 空盆 其余为花id
  int soilsate;
  String typeName;
  String decorpotName = "";
  String status;
  int rosestate;
  bool isDouble = false;

  /// 阳光
  bool isNoShine = false;

  /// 除草
  bool isClutter = false;

  /// 杀虫
  bool isNoFood = false;

  int charm;
  int exp;
  int increase;
  int lucky;
  int speed;

  Soil(dynamic soil) {
    type = soil["SoilType"];

    if (type == 3) {
      charm = soil["hpattribute"]["charm"];
      exp = soil["hpattribute"]["exp"];
      increase = soil["hpattribute"]["increase"];
      speed = soil["hpattribute"]["speed"];
    } else {
      charm = soil["attribute"]["charm"];
      exp = soil["attribute"]["exp"];
      increase = soil["attribute"]["increase"];
      lucky = soil["attribute"]["lucky"];
      speed = soil["attribute"]["speed"];
    }

    typeName = getSoilType(soil["SoilType"]);
    soilsate = soil["soilsate"];
    if (soilsate == 50) {
      plantShowName = "[枯萎]";
    } else if (soilsate == 51) {
      plantShowName = "[空盆]";
    } else {
      var flower = getFlowerInfoById(soilsate);
      if (flower != null) {
        plantShowName = flower.getAttribute("name");
        var season = flower.getAttribute("season");
        if (season != null) {
          plantShowName += " 第${soil["season"]}季";
        }
      }
      isDouble = soil["isDouble"] == 1;
      isNoShine = soil["isnoshine"] == 1;
      isNoFood = soil["isnofood"] == 1;
      isClutter = soil["isclutter"] == 1;
      var strTimes = soil["rosebegintime"].toString().split("-");
      plantTime = DateTime.parse(
          "${strTimes[0]}-${strTimes[1]}-${strTimes[2]} ${strTimes[3]}:${strTimes[4]}:${strTimes[5]}");

      var times = flower.getAttribute("times").split(",");
      gainTime = plantTime.add(new Duration(minutes: int.parse(times[3])));
    }
    if (soil["decorpot"] != null) {
      var props = Config.propConfig
          .findAllElements("item")
          .where((xe) => xe.getAttribute("id") == "${soil["decorpot"]}")
          .toList();
      if (props.length > 0) {
        decorpotName = props[0].getAttribute("name");
      }
    }
    rosestate = soil["rosestate"];
    status = getStatus(rosestate);
  }

  static getGainTime(int id, String beginTime) {
    var flower = getFlowerInfoById(id);

    var strTimes = beginTime.toString().split("-");
    var plantTime = DateTime.parse(
        "${strTimes[0]}-${strTimes[1]}-${strTimes[2]} ${strTimes[3]}:${strTimes[4]}:${strTimes[5]}");

    var times = flower.getAttribute("times").split(",");
    return plantTime.add(new Duration(minutes: int.parse(times[3])));
  }

  getSoilType(int type) {
    switch (type) {
      case 0:
        return "土盆";
      case 1:
        return "水盆";
      case 2:
        return "仙盆"; // 仙盆不能种植
      case 3:
        return "仙盆";
    }
  }

  String getStatus(int rosestate) {
    switch (rosestate) {
      case 1:
        return "[种子]";
      case 2:
        return "[发芽]";
      case 3:
        return "[嫩叶]";
      case 4:
        return "[花蕾]";
      case 5:
        return "[开花]";
      default:
        return "[空]";
    }
  }

  static XmlElement getFlowerInfoById(int id) {
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
      return res[0];
    }
    return null;
  }

  String getAttrString() {
    if (this.type == 3) {
      return "加速: ${this.speed / 10}% 增产: ${this.increase / 10}% 魅力: ${this.charm / 10}% 经验: ${this.exp / 10}%";
    }
    return "加速: ${this.speed}% 增产: ${this.increase}% 魅力: ${this.charm}% 经验: ${this.exp}% 幸运值: ${this.lucky}";
  }
}
