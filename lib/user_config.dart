import 'package:json_annotation/json_annotation.dart';

part 'user_config.g.dart';

@JsonSerializable()
class UserConfig {
  final List<SpeedFertilizer> speeds;

  UserConfig({this.speeds});

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
