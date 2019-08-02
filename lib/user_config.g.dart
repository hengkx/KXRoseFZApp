// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserConfig _$UserConfigFromJson(Map<String, dynamic> json) {
  return UserConfig(
    speeds: (json['speeds'] as List)
        ?.map((e) => e == null
            ? null
            : SpeedFertilizer.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserConfigToJson(UserConfig instance) =>
    <String, dynamic>{
      'speeds': instance.speeds,
    };

SpeedFertilizer _$SpeedFertilizerFromJson(Map<String, dynamic> json) {
  return SpeedFertilizer(
    id: json['id'] as int,
    name: json['name'] as String,
    use: json['use'] as bool,
    time: json['time'] as int,
  );
}

Map<String, dynamic> _$SpeedFertilizerToJson(SpeedFertilizer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'use': instance.use,
      'time': instance.time,
    };
