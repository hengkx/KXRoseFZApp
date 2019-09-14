import 'package:rose_fz/models/flower.dart';
import 'package:rose_fz/models/soil.dart';

class PlantUtil {
  static bool isPlant(Flower flower, Soil soil) {
    if (soil == null) {
      return true;
    }
    if (flower.combineId != null ||
        (!flower.isMoneyBuy() && flower.count <= 0)) {
      return false;
    }
    if (soil.type == 0) {
      return flower.type == 2 ||
          flower.type == 100 ||
          (flower.type == 99 && soil.potLevel >= flower.potLevel);
    } else if (soil.type == 1) {
      return flower.type == 1 && soil.potLevel >= flower.potLevel;
    } else if (soil.type == 3) {
      if (soil.hanglevel == 4) {
        return flower.type == 2 ||
            flower.type == 3 ||
            (flower.type == 99 && flower.season < 4);
      } else {
        return flower.type == 3 && flower.potLevel <= soil.hanglevel;
      }
    }
    return false;
  }
}
