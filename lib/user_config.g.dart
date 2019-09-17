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
    warFlags: (json['warFlags'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(int.parse(k), e as int),
        ) ??
        {},
  )
    ..trainPets = (json['trainPets'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(int.parse(k), e as int),
        ) ??
        {}
    ..contractPets = (json['contractPets'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(int.parse(k), e as int),
        ) ??
        {}
    ..quality = json['quality'] as int
    ..earthrPlant = json['earthrPlant'] as int
    ..waterPlant = json['waterPlant'] as int
    ..hangPlant = json['hangPlant'] as int;
}

Map<String, dynamic> _$UserConfigToJson(UserConfig instance) =>
    <String, dynamic>{
      'speeds': instance.speeds,
      'warFlags': instance.warFlags?.map((k, e) => MapEntry(k.toString(), e)),
      'trainPets': instance.trainPets?.map((k, e) => MapEntry(k.toString(), e)),
      'contractPets':
          instance.contractPets?.map((k, e) => MapEntry(k.toString(), e)),
      'quality': instance.quality,
      'earthrPlant': instance.earthrPlant,
      'waterPlant': instance.waterPlant,
      'hangPlant': instance.hangPlant,
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
