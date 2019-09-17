import 'package:json_annotation/json_annotation.dart';

part 'user_config.g.dart';

@JsonSerializable()
class UserConfig {
  /// 加速化肥
  final List<SpeedFertilizer> speeds;

  /// 战旗

  @JsonKey(defaultValue: {})
  Map<int, int> warFlags;

  /// 宝宝训练
  @JsonKey(defaultValue: {})
  Map<int, int> trainPets;

  /// 宝宝契约
  @JsonKey(defaultValue: {})
  Map<int, int> contractPets;

  /// 提升品质
  int quality;

  /// 土盆种植
  int earthrPlant;

  /// 水盆种植
  int waterPlant;

  /// 仙盆种植
  int hangPlant;

  UserConfig({this.speeds, this.warFlags});

  factory UserConfig.fromJson(Map<String, dynamic> json) =>
      _$UserConfigFromJson(json);

  Map<String, dynamic> toJson() => _$UserConfigToJson(this);
}

@JsonSerializable()
class SpeedFertilizer {
  final int id;
  final String name;
  bool use;
  int time;
  SpeedFertilizer({this.id, this.name, this.use, this.time});

  factory SpeedFertilizer.fromJson(Map<String, dynamic> json) =>
      _$SpeedFertilizerFromJson(json);

  Map<String, dynamic> toJson() => _$SpeedFertilizerToJson(this);
}
