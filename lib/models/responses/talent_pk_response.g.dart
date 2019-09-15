// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talent_pk_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalentPKResponse _$TalentPKResponseFromJson(Map<String, dynamic> json) {
  return TalentPKResponse(
    json['result'],
    json['resultstr'],
    json['uin'],
    json['selfaward'] as int,
    json['free'] as int,
    json['iswin'] as int,
    json['advNum'] as int,
    json['advProgress'] as int,
    json['pcnum'] as int,
    json['cnum'] as int,
    json['ccdtime'] as int,
    json['selfrank'] as int,
    (json['rivals'] as List)
        ?.map((e) =>
            e == null ? null : Rivals.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['selfinfo'] == null
        ? null
        : Selfinfo.fromJson(json['selfinfo'] as Map<String, dynamic>),
    (json['selftoken'] as List)?.map((e) => e as String)?.toList(),
    (json['selfmatrix'] as List)
        ?.map((e) =>
            e == null ? null : Selfmatrix.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['selfrunes'] as List)
        ?.map((e) =>
            e == null ? null : Selfrunes.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['enemyinfo'] == null
        ? null
        : Enemyinfo.fromJson(json['enemyinfo'] as Map<String, dynamic>),
    (json['enemytoken'] as List)?.map((e) => e as String)?.toList(),
    (json['enemyrunes'] as List)
        ?.map((e) =>
            e == null ? null : Enemyrunes.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['enemymatrix'] as List)
        ?.map((e) =>
            e == null ? null : Enemymatrix.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['combat'] as List)
        ?.map((e) =>
            e == null ? null : Combat.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['contwin'] as int,
    (json['award'] as List)
        ?.map(
            (e) => e == null ? null : Award.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['lv'] as int,
    json['success'] as int,
    json['failed'] as int,
    (json['win1'] as List)?.map((e) => e as String)?.toList(),
    (json['win2'] as List)?.map((e) => e as String)?.toList(),
    (json['winmax1'] as List)?.map((e) => e as String)?.toList(),
    (json['winmax2'] as List)?.map((e) => e as String)?.toList(),
    (json['lose1'] as List)?.map((e) => e as String)?.toList(),
    (json['lose2'] as List)?.map((e) => e as String)?.toList(),
    (json['losemax1'] as List)?.map((e) => e as String)?.toList(),
    (json['losemax2'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$TalentPKResponseToJson(TalentPKResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'resultstr': instance.resultstr,
      'uin': instance.uin,
      'iswin': instance.isWin,
      'advNum': instance.advNum,
      'advProgress': instance.advProgress,
      'pcnum': instance.pcnum,
      'cnum': instance.cnum,
      'ccdtime': instance.ccdtime,
      'selfrank': instance.selfRank,
      'rivals': instance.rivals,
      'selfinfo': instance.selfinfo,
      'selftoken': instance.selftoken,
      'selfmatrix': instance.selfmatrix,
      'selfrunes': instance.selfrunes,
      'enemyinfo': instance.enemyinfo,
      'enemytoken': instance.enemytoken,
      'enemyrunes': instance.enemyrunes,
      'enemymatrix': instance.enemymatrix,
      'combat': instance.combat,
      'contwin': instance.contwin,
      'award': instance.award,
      'lv': instance.lv,
      'success': instance.success,
      'failed': instance.failed,
      'win1': instance.win1,
      'win2': instance.win2,
      'winmax1': instance.winmax1,
      'winmax2': instance.winmax2,
      'lose1': instance.lose1,
      'lose2': instance.lose2,
      'losemax1': instance.losemax1,
      'losemax2': instance.losemax2,
      'free': instance.free,
      'selfaward': instance.selfAward,
    };

Rivals _$RivalsFromJson(Map<String, dynamic> json) {
  return Rivals(
    json['rank'] as int,
    json['nickname'] as String,
  );
}

Map<String, dynamic> _$RivalsToJson(Rivals instance) => <String, dynamic>{
      'rank': instance.rank,
      'nickname': instance.nickname,
    };

Selfinfo _$SelfinfoFromJson(Map<String, dynamic> json) {
  return Selfinfo(
    json['level'] as int,
    json['nickname'] as String,
    json['gender'] as int,
    json['rank'] as int,
  );
}

Map<String, dynamic> _$SelfinfoToJson(Selfinfo instance) => <String, dynamic>{
      'level': instance.level,
      'nickname': instance.nickname,
      'gender': instance.gender,
      'rank': instance.rank,
    };

Selfmatrix _$SelfmatrixFromJson(Map<String, dynamic> json) {
  return Selfmatrix(
    json['id'] as int,
    json['level'] as int,
    json['pos'] as int,
    json['hp'] as int,
    json['attack'] as int,
    json['speed'] as int,
    json['power'] as int,
    json['qual'] == null
        ? null
        : Qual.fromJson(json['qual'] as Map<String, dynamic>),
    json['aow_exp'] as int,
    json['aow_id'] as int,
    json['aow_expneed'] as int,
    json['aow_nextexpneed'] as int,
    json['aow_next'] as int,
  );
}

Map<String, dynamic> _$SelfmatrixToJson(Selfmatrix instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'pos': instance.pos,
      'hp': instance.hp,
      'attack': instance.attack,
      'speed': instance.speed,
      'power': instance.power,
      'qual': instance.qual,
      'aow_exp': instance.aowExp,
      'aow_id': instance.aowId,
      'aow_expneed': instance.aowExpneed,
      'aow_nextexpneed': instance.aowNextexpneed,
      'aow_next': instance.aowNext,
    };

Qual _$QualFromJson(Map<String, dynamic> json) {
  return Qual(
    json['lv'] as int,
  );
}

Map<String, dynamic> _$QualToJson(Qual instance) => <String, dynamic>{
      'lv': instance.lv,
    };

Selfrunes _$SelfrunesFromJson(Map<String, dynamic> json) {
  return Selfrunes(
    json['id'] as int,
    json['left'] as int,
  );
}

Map<String, dynamic> _$SelfrunesToJson(Selfrunes instance) => <String, dynamic>{
      'id': instance.id,
      'left': instance.left,
    };

Enemyinfo _$EnemyinfoFromJson(Map<String, dynamic> json) {
  return Enemyinfo(
    json['teammoral'] as int,
    json['uin'] as int,
    json['rank'] as int,
    json['nickname'] as String,
    json['gender'] as int,
  );
}

Map<String, dynamic> _$EnemyinfoToJson(Enemyinfo instance) => <String, dynamic>{
      'teammoral': instance.teammoral,
      'uin': instance.uin,
      'rank': instance.rank,
      'nickname': instance.nickname,
      'gender': instance.gender,
    };

Enemyrunes _$EnemyrunesFromJson(Map<String, dynamic> json) {
  return Enemyrunes(
    json['id'] as int,
    json['left'] as int,
  );
}

Map<String, dynamic> _$EnemyrunesToJson(Enemyrunes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'left': instance.left,
    };

Enemymatrix _$EnemymatrixFromJson(Map<String, dynamic> json) {
  return Enemymatrix(
    json['id'] as int,
    json['level'] as int,
    json['pos'] as int,
    json['hp'] as int,
    json['attack'] as int,
    json['speed'] as int,
    json['power'] as int,
    json['qual'] == null
        ? null
        : Qual.fromJson(json['qual'] as Map<String, dynamic>),
    json['aow_exp'] as int,
    json['aow_id'] as int,
    json['aow_next'] as int,
    json['aow_expneed'] as int,
    json['aow_nexexpneed'] as int,
  );
}

Map<String, dynamic> _$EnemymatrixToJson(Enemymatrix instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'pos': instance.pos,
      'hp': instance.hp,
      'attack': instance.attack,
      'speed': instance.speed,
      'power': instance.power,
      'qual': instance.qual,
      'aow_exp': instance.aowExp,
      'aow_id': instance.aowId,
      'aow_next': instance.aowNext,
      'aow_expneed': instance.aowExpneed,
      'aow_nexexpneed': instance.aowNexexpneed,
    };

Combat _$CombatFromJson(Map<String, dynamic> json) {
  return Combat(
    json['uin'] as int,
    json['id'] as int,
    (json['ra'] as List)?.map((e) => e as String)?.toList(),
    (json['rs'] as List)?.map((e) => e as String)?.toList(),
    (json['effect'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$CombatToJson(Combat instance) => <String, dynamic>{
      'uin': instance.uin,
      'id': instance.id,
      'ra': instance.ra,
      'rs': instance.rs,
      'effect': instance.effect,
    };
