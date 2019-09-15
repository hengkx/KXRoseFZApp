// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'award.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Award _$AwardFromJson(Map<String, dynamic> json) {
  return Award(
    json['id'] as int,
    json['type'] as int,
    json['count'] as int,
    json['name'] as String,
  );
}

Map<String, dynamic> _$AwardToJson(Award instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'count': instance.count,
      'name': instance.name,
    };
