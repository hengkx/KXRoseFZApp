class Flower {
  final int plantId;
  final int seedId;
  final int season;
  final int potLevel;

  /// 1 水生 2 藤类 3 仙藤 99 陆植 100 玫瑰
  int type;
  final int seedPrice;
  final int seedPriceQPoint;
  int count;
  final String name;
  final String pyName;
  final String combineId;
  final String times;
  final String multiSeason;

  Flower({
    this.plantId,
    this.seedId,
    this.type,
    this.seedPrice,
    this.count,
    this.seedPriceQPoint,
    this.pyName,
    this.name,
    this.season,
    this.potLevel,
    this.combineId,
    this.times,
    this.multiSeason,
  });

  String getTypeName() {
    switch (type) {
      case 1:
        return "水生";
      case 2:
        return "藤类";
      case 3:
        return "仙藤";
      case 99:
        return "陆植";
      case 100:
        return "玫瑰";
    }
    return "";
  }

  bool isBuy() {
    return seedPrice != 0 || seedPriceQPoint != 0;
  }

  /// 能不能金币购买
  bool isMoneyBuy() {
    return seedPrice != 0;
  }
}
