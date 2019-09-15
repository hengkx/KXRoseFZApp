class DecorateConfig {
  final int id;
  final String name;
  final String desc;
  final int requireLv;
  int period = 0;
  int type = 0;
  int prizeQB = 0;

  DecorateConfig({
    this.id,
    this.name,
    this.desc,
    this.requireLv,
    this.period,
    this.type,
  });
}
