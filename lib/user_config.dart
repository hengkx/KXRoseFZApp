import 'package:json_annotation/json_annotation.dart';

part 'user_config.g.dart';

@JsonSerializable()
class UserConfig {
  final List<Speed> speeds;

  UserConfig({this.speeds});

  factory UserConfig.fromJson(Map<String, dynamic> json) =>
      _$UserConfigFromJson(json);

  Map<String, dynamic> toJson() => _$UserConfigToJson(this);
}

@JsonSerializable()
class Speed {
  final int id;
  final String name;
  final bool use;
  final int time;
  Speed({this.id, this.name, this.use, this.time});

  factory Speed.fromJson(Map<String, dynamic> json) => _$SpeedFromJson(json);

  Map<String, dynamic> toJson() => _$SpeedToJson(this);
}
