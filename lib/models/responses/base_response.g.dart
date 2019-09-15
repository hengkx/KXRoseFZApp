// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) {
  return BaseResponse(
    result: json['result'] as int,
    resultstr: json['resultstr'] as String,
    uin: json['uin'] as String,
  );
}

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'resultstr': instance.resultstr,
      'uin': instance.uin,
    };
