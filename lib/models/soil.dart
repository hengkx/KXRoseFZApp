import 'package:rose_fz/global.dart';
import 'package:rose_fz/utils/mg_data.dart';

class Soil {
  int no;

  /// 种植时间
  DateTime plantTime;

  /// 收获时间
  DateTime gainTime;
  String plantShowName;

  /// 0 土盆 1水盆 2 仙盆花架 3 仙盆
  int type;

  /// 50 枯萎 51 空盆 其余为花id
  int soilsate;

  /// 仙盆等级
  int hanglevel;

  /// 花盆等级
  int potLevel;

  /// 第几季
  int season;

  String typeName;
  String decorpotName = "";

  /// 1 种子 2 发芽 3 嫩叶 4 花蕾 5 开花
  int rosestate;

  /// 花当前状态
  String status;

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
    hanglevel = soil["hanglevel"];
    potLevel = soil["potlevel"];
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
    season = soil["season"];
    if (soilsate == 50) {
      plantShowName = "[枯萎]";
    } else if (soilsate == 51) {
      plantShowName = "[空盆]";
    } else {
      var flower = Global.getFlowerInfoById(soilsate);
      if (flower != null) {
        plantShowName = flower.name;
        if (flower.season != null && flower.season != 0) {
          plantShowName += " 第$season季";
        }
      }
      isDouble = soil["isDouble"] == 1;
      isNoShine = soil["isnoshine"] == 1;
      isNoFood = soil["isnofood"] == 1;
      isClutter = soil["isclutter"] == 1;
      var strTimes = soil["rosebegintime"].toString().split("-");
      plantTime = DateTime.parse(
          "${strTimes[0]}-${strTimes[1]}-${strTimes[2]} ${strTimes[3]}:${strTimes[4]}:${strTimes[5]}");

      gainTime =
          getGainTime(soilsate, soil["rosebegintime"].toString(), season);
    }
    if (soil["decorpot"] != null) {
      decorpotName = MGDataUtil.getInfoByID(soil["decorpot"]).name;
    }
    rosestate = soil["rosestate"];
    status = getStatus(rosestate);
  }

  static getGainTime(int id, String beginTime, [int season = 1]) {
    var flower = Global.getFlowerInfoById(id);

    var strTimes = beginTime.toString().split("-");
    var plantTime = DateTime.parse(
        "${strTimes[0]}-${strTimes[1]}-${strTimes[2]} ${strTimes[3]}:${strTimes[4]}:${strTimes[5]}");

    var times = flower.times.split(",");
    if (season > 1) {
      var multiSeasons = flower.multiSeason.split(",");
      return plantTime.add(new Duration(minutes: int.parse(multiSeasons[3])));
    }
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

  String getAttrString() {
    if (this.type == 3) {
      return "加速: ${this.speed / 10}% 增产: ${this.increase / 10}% 魅力: ${this.charm / 10}% 经验: ${this.exp / 10}%";
    }
    return "加速: ${this.speed}% 增产: ${this.increase}% 魅力: ${this.charm}% 经验: ${this.exp}% 幸运值: ${this.lucky}";
  }
}
