// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

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

GetUserInfoResponse _$GetUserInfoResponseFromJson(Map<String, dynamic> json) {
  return GetUserInfoResponse(
    result: json['result'],
    resultstr: json['resultstr'],
    uin: json['uin'],
    usernic: json['usernic'] as String,
    userGender: json['userGender'] as int,
    hasphoto: json['hasphoto'] as int,
    is_gamevip: json['is_gamevip'] as int,
    gameviplevel: json['gameviplevel'] as int,
    annualvip: json['annualvip'] as int,
    supervip: json['supervip'] as int,
  );
}

Map<String, dynamic> _$GetUserInfoResponseToJson(
        GetUserInfoResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'resultstr': instance.resultstr,
      'uin': instance.uin,
      'usernic': instance.usernic,
      'userGender': instance.userGender,
      'hasphoto': instance.hasphoto,
      'is_gamevip': instance.is_gamevip,
      'gameviplevel': instance.gameviplevel,
      'annualvip': instance.annualvip,
      'supervip': instance.supervip,
    };

UseFertilizerResponse _$UseFertilizerResponseFromJson(
    Map<String, dynamic> json) {
  return UseFertilizerResponse(
    result: json['result'],
    resultstr: json['resultstr'],
    uin: json['uin'],
    rosebegintime: json['rosebegintime'] as String,
    ferticount: json['ferticount'] as int,
    gaincount: json['gaincount'] as int,
    leftcount: json['leftcount'] as int,
    rosestate: json['rosestate'] as int,
    soilno: json['soilno'] as int,
    stealcount: json['stealcount'] as int,
    usetype: json['usetype'] as int,
  );
}

Map<String, dynamic> _$UseFertilizerResponseToJson(
        UseFertilizerResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'resultstr': instance.resultstr,
      'uin': instance.uin,
      'rosebegintime': instance.rosebegintime,
      'ferticount': instance.ferticount,
      'gaincount': instance.gaincount,
      'leftcount': instance.leftcount,
      'rosestate': instance.rosestate,
      'soilno': instance.soilno,
      'stealcount': instance.stealcount,
      'usetype': instance.usetype,
    };
