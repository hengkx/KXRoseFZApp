// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserConfig _$UserConfigFromJson(Map<String, dynamic> json) {
  return UserConfig(
    speeds: (json['speeds'] as List)
        ?.map(
            (e) => e == null ? null : Speed.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserConfigToJson(UserConfig instance) =>
    <String, dynamic>{
      'speeds': instance.speeds,
    };

Speed _$SpeedFromJson(Map<String, dynamic> json) {
  return Speed(
    id: json['id'] as int,
    name: json['name'] as String,
    use: json['use'] as bool,
    time: json['time'] as int,
  );
}

Map<String, dynamic> _$SpeedToJson(Speed instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'use': instance.use,
      'time': instance.time,
    };
