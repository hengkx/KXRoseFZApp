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

FruitGift _$FruitGiftFromJson(Map<String, dynamic> json) {
  return FruitGift(
    type: json['type'] as int,
    id: json['id'] as int,
    count: json['count'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$FruitGiftToJson(FruitGift instance) => <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'count': instance.count,
      'name': instance.name,
    };

Gift _$GiftFromJson(Map<String, dynamic> json) {
  return Gift(
    miliandanadd: json['miliandanadd'] as int,
    tips: json['tips'] as String,
  );
}

Map<String, dynamic> _$GiftToJson(Gift instance) => <String, dynamic>{
      'miliandanadd': instance.miliandanadd,
      'tips': instance.tips,
    };

GetInitFirstResponse _$GetInitFirstResponseFromJson(Map<String, dynamic> json) {
  return GetInitFirstResponse(
    result: json['result'],
    resultstr: json['resultstr'],
    uin: json['uin'],
    timeCommonFerti: json['prop506'] as int ?? 0,
    timeQuickFerti: json['prop507'] as int ?? 0,
    timeMoreFerti: json['prop508'] as int ?? 0,
    moreferti: json['moreferti'] as int,
    superQuickFerti: json['prop31004'] as int ?? 0,
    commonferti: json['commonferti'] as int,
    quickferti: json['quickferti'] as int,
  )..huaYuanTreasure = json['huayuantreasure2017_npc'] as int ?? 0;
}

Map<String, dynamic> _$GetInitFirstResponseToJson(
        GetInitFirstResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'resultstr': instance.resultstr,
      'uin': instance.uin,
      'prop506': instance.timeCommonFerti,
      'prop507': instance.timeQuickFerti,
      'prop508': instance.timeMoreFerti,
      'moreferti': instance.moreferti,
      'prop31004': instance.superQuickFerti,
      'commonferti': instance.commonferti,
      'quickferti': instance.quickferti,
      'huayuantreasure2017_npc': instance.huaYuanTreasure,
    };

PlantResponse _$PlantResponseFromJson(Map<String, dynamic> json) {
  return PlantResponse(
    result: json['result'],
    resultstr: json['resultstr'],
    uin: json['uin'],
    soilno: json['soilno'] as int,
    soilsate: json['soilsate'] as int,
    rosestate: json['rosestate'] as int,
    addexperice: json['addexperice'] as int,
    rosebegintime: json['rosebegintime'] as String,
    fruitgift: (json['fruitgift'] as List)
        ?.map((e) =>
            e == null ? null : FruitGift.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    gift: (json['gift'] as List)
        ?.map(
            (e) => e == null ? null : Gift.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PlantResponseToJson(PlantResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'resultstr': instance.resultstr,
      'uin': instance.uin,
      'soilno': instance.soilno,
      'soilsate': instance.soilsate,
      'rosestate': instance.rosestate,
      'addexperice': instance.addexperice,
      'rosebegintime': instance.rosebegintime,
      'fruitgift': instance.fruitgift,
      'gift': instance.gift,
    };

GainResponse _$GainResponseFromJson(Map<String, dynamic> json) {
  return GainResponse(
    result: json['result'],
    resultstr: json['resultstr'],
    uin: json['uin'],
    soilno: json['soilno'] as int,
    igainrosetype: json['igainrosetype'] as int,
    igainrosecount: json['igainrosecount'] as int,
    addcharm: json['addcharm'] as int,
    addexperice: json['addexperice'] as int,
    fruitgift: (json['fruitgift'] as List)
        ?.map((e) =>
            e == null ? null : FruitGift.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    gift: (json['gift'] as List)
        ?.map(
            (e) => e == null ? null : Gift.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GainResponseToJson(GainResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'resultstr': instance.resultstr,
      'uin': instance.uin,
      'soilno': instance.soilno,
      'igainrosetype': instance.igainrosetype,
      'igainrosecount': instance.igainrosecount,
      'addcharm': instance.addcharm,
      'addexperice': instance.addexperice,
      'fruitgift': instance.fruitgift,
      'gift': instance.gift,
    };

HoeResponse _$HoeResponseFromJson(Map<String, dynamic> json) {
  return HoeResponse(
    result: json['result'],
    resultstr: json['resultstr'],
    uin: json['uin'],
    soilno: json['soilno'] as int,
    fruitgift: (json['fruitgift'] as List)
        ?.map((e) =>
            e == null ? null : FruitGift.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    gift: (json['gift'] as List)
        ?.map(
            (e) => e == null ? null : Gift.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$HoeResponseToJson(HoeResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'resultstr': instance.resultstr,
      'uin': instance.uin,
      'soilno': instance.soilno,
      'fruitgift': instance.fruitgift,
      'gift': instance.gift,
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
    isDouble: json['isDouble'] as int,
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
      'isDouble': instance.isDouble,
    };

UserTask _$UserTaskFromJson(Map<String, dynamic> json) {
  return UserTask(
    continueNum: json['continueNum'] as int,
    data1: json['data1'] as int,
    data2: json['data2'] as int,
    data3: json['data3'] as int,
    data4: json['data4'] as int,
    data5: json['data5'] as int,
    endTime: json['endTime'] as int,
    finishNum: json['finishNum'] as int,
    finishTime: json['finishTime'] as int,
    state: json['state'] as int,
    taskID: json['taskID'] as int,
  );
}

Map<String, dynamic> _$UserTaskToJson(UserTask instance) => <String, dynamic>{
      'continueNum': instance.continueNum,
      'data1': instance.data1,
      'data2': instance.data2,
      'data3': instance.data3,
      'data4': instance.data4,
      'data5': instance.data5,
      'endTime': instance.endTime,
      'finishNum': instance.finishNum,
      'finishTime': instance.finishTime,
      'state': instance.state,
      'taskID': instance.taskID,
    };

TaskResponse _$TaskResponseFromJson(Map<String, dynamic> json) {
  return TaskResponse(
    result: json['result'],
    resultstr: json['resultstr'],
    uin: json['uin'],
    userTasks: (json['user_task'] as List)
            ?.map((e) =>
                e == null ? null : UserTask.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$TaskResponseToJson(TaskResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'resultstr': instance.resultstr,
      'uin': instance.uin,
      'user_task': instance.userTasks,
    };
