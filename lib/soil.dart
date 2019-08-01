import 'config.dart';

class Soil {
  int no;
  // 种植时间
  DateTime plantTime;
  // 收获时间
  DateTime gainTime;
  String plantShowName;
  int type;
  String typeName;
  String decorpotName;

  int charm;
  int exp;
  int increase;
  int lucky;
  int speed;

  Soil(dynamic soil) {
    charm = soil["attribute"]["charm"];
    exp = soil["attribute"]["exp"];
    increase = soil["attribute"]["increase"];
    lucky = soil["attribute"]["lucky"];
    speed = soil["attribute"]["speed"];

    type = soil["SoilType"];
    typeName = getSoilType(soil["SoilType"]);
    if (soil["soilsate"] == 50) {
      plantShowName = "[枯萎]";
    } else if (soil["soilsate"] == 51) {
      plantShowName = "[空盆]";
    } else {
      var flower = getFlowerInfoById(soil["soilsate"]);
      if (flower != null) {
        plantShowName = flower.getAttribute("name");
        var season = flower.getAttribute("season");
        if (season != null) {
          plantShowName += " 第${soil["season"]}季";
        }
      }

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
  }

  getSoilType(int type) {
    switch (type) {
      case 0:
        return "土盆";
      case 1:
        return "水盆";
      case 2:
        return "仙盆(花架)";
      case 3:
        return "仙盆";
    }
  }

  getFlowerInfoById(int id) {
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
  }
}
