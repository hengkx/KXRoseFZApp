import 'package:json_annotation/json_annotation.dart';
import 'package:rose_fz/models/responses/award.dart';
import 'package:rose_fz/models/responses/base_response.dart';

part 'talent_pk_response.g.dart';

@JsonSerializable()
class TalentPKResponse extends BaseResponse {
  @JsonKey(name: 'iswin')
  int isWin;

  int advNum;

  int advProgress;

  @JsonKey(name: 'pcnum')
  int pcnum;

  @JsonKey(name: 'cnum')
  int cnum;

  @JsonKey(name: 'ccdtime')
  int ccdtime;

  @JsonKey(name: 'selfrank')
  int selfRank;

  @JsonKey(name: 'rivals')
  List<Rivals> rivals;

  @JsonKey(name: 'selfinfo')
  Selfinfo selfinfo;

  @JsonKey(name: 'selftoken')
  List<String> selftoken;

  @JsonKey(name: 'selfmatrix')
  List<Selfmatrix> selfmatrix;

  @JsonKey(name: 'selfrunes')
  List<Selfrunes> selfrunes;

  @JsonKey(name: 'enemyinfo')
  Enemyinfo enemyinfo;

  @JsonKey(name: 'enemytoken')
  List<String> enemytoken;

  @JsonKey(name: 'enemyrunes')
  List<Enemyrunes> enemyrunes;

  @JsonKey(name: 'enemymatrix')
  List<Enemymatrix> enemymatrix;

  @JsonKey(name: 'combat')
  List<Combat> combat;

  @JsonKey(name: 'contwin')
  int contwin;

  List<Award> award;

  @JsonKey(name: 'lv')
  int lv;

  @JsonKey(name: 'success')
  int success;

  @JsonKey(name: 'failed')
  int failed;

  @JsonKey(name: 'win1')
  List<String> win1;

  @JsonKey(name: 'win2')
  List<String> win2;

  @JsonKey(name: 'winmax1')
  List<String> winmax1;

  @JsonKey(name: 'winmax2')
  List<String> winmax2;

  @JsonKey(name: 'lose1')
  List<String> lose1;

  @JsonKey(name: 'lose2')
  List<String> lose2;

  @JsonKey(name: 'losemax1')
  List<String> losemax1;

  @JsonKey(name: 'losemax2')
  List<String> losemax2;

  int free;

  @JsonKey(name: 'selfaward')
  int selfAward;

  TalentPKResponse(
    result,
    resultstr,
    uin,
    this.selfAward,
    this.free,
    this.isWin,
    this.advNum,
    this.advProgress,
    this.pcnum,
    this.cnum,
    this.ccdtime,
    this.selfRank,
    this.rivals,
    this.selfinfo,
    this.selftoken,
    this.selfmatrix,
    this.selfrunes,
    this.enemyinfo,
    this.enemytoken,
    this.enemyrunes,
    this.enemymatrix,
    this.combat,
    this.contwin,
    this.award,
    this.lv,
    this.success,
    this.failed,
    this.win1,
    this.win2,
    this.winmax1,
    this.winmax2,
    this.lose1,
    this.lose2,
    this.losemax1,
    this.losemax2,
  ) : super(result: result, resultstr: resultstr, uin: uin);

  factory TalentPKResponse.fromJson(Map<String, dynamic> srcJson) =>
      _$TalentPKResponseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TalentPKResponseToJson(this);
}

@JsonSerializable()
class Rivals extends Object {
  @JsonKey(name: 'rank')
  int rank;

  @JsonKey(name: 'nickname')
  String nickname;

  Rivals(
    this.rank,
    this.nickname,
  );

  factory Rivals.fromJson(Map<String, dynamic> srcJson) =>
      _$RivalsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RivalsToJson(this);
}

@JsonSerializable()
class Selfinfo extends Object {
  @JsonKey(name: 'level')
  int level;

  @JsonKey(name: 'nickname')
  String nickname;

  @JsonKey(name: 'gender')
  int gender;

  @JsonKey(name: 'rank')
  int rank;

  Selfinfo(
    this.level,
    this.nickname,
    this.gender,
    this.rank,
  );

  factory Selfinfo.fromJson(Map<String, dynamic> srcJson) =>
      _$SelfinfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SelfinfoToJson(this);
}

@JsonSerializable()
class Selfmatrix extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'level')
  int level;

  @JsonKey(name: 'pos')
  int pos;

  @JsonKey(name: 'hp')
  int hp;

  @JsonKey(name: 'attack')
  int attack;

  @JsonKey(name: 'speed')
  int speed;

  @JsonKey(name: 'power')
  int power;

  @JsonKey(name: 'qual')
  Qual qual;

  @JsonKey(name: 'aow_exp')
  int aowExp;

  @JsonKey(name: 'aow_id')
  int aowId;

  @JsonKey(name: 'aow_expneed')
  int aowExpneed;

  @JsonKey(name: 'aow_nextexpneed')
  int aowNextexpneed;

  @JsonKey(name: 'aow_next')
  int aowNext;

  Selfmatrix(
    this.id,
    this.level,
    this.pos,
    this.hp,
    this.attack,
    this.speed,
    this.power,
    this.qual,
    this.aowExp,
    this.aowId,
    this.aowExpneed,
    this.aowNextexpneed,
    this.aowNext,
  );

  factory Selfmatrix.fromJson(Map<String, dynamic> srcJson) =>
      _$SelfmatrixFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SelfmatrixToJson(this);
}

@JsonSerializable()
class Qual extends Object {
  @JsonKey(name: 'lv')
  int lv;

  Qual(
    this.lv,
  );

  factory Qual.fromJson(Map<String, dynamic> srcJson) =>
      _$QualFromJson(srcJson);

  Map<String, dynamic> toJson() => _$QualToJson(this);
}

@JsonSerializable()
class Selfrunes extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'left')
  int left;

  Selfrunes(
    this.id,
    this.left,
  );

  factory Selfrunes.fromJson(Map<String, dynamic> srcJson) =>
      _$SelfrunesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SelfrunesToJson(this);
}

@JsonSerializable()
class Enemyinfo extends Object {
  @JsonKey(name: 'teammoral')
  int teammoral;

  @JsonKey(name: 'uin')
  int uin;

  @JsonKey(name: 'rank')
  int rank;

  @JsonKey(name: 'nickname')
  String nickname;

  @JsonKey(name: 'gender')
  int gender;

  Enemyinfo(
    this.teammoral,
    this.uin,
    this.rank,
    this.nickname,
    this.gender,
  );

  factory Enemyinfo.fromJson(Map<String, dynamic> srcJson) =>
      _$EnemyinfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EnemyinfoToJson(this);
}

@JsonSerializable()
class Enemyrunes extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'left')
  int left;

  Enemyrunes(
    this.id,
    this.left,
  );

  factory Enemyrunes.fromJson(Map<String, dynamic> srcJson) =>
      _$EnemyrunesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EnemyrunesToJson(this);
}

@JsonSerializable()
class Enemymatrix extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'level')
  int level;

  @JsonKey(name: 'pos')
  int pos;

  @JsonKey(name: 'hp')
  int hp;

  @JsonKey(name: 'attack')
  int attack;

  @JsonKey(name: 'speed')
  int speed;

  @JsonKey(name: 'power')
  int power;

  @JsonKey(name: 'qual')
  Qual qual;

  @JsonKey(name: 'aow_exp')
  int aowExp;

  @JsonKey(name: 'aow_id')
  int aowId;

  @JsonKey(name: 'aow_next')
  int aowNext;

  @JsonKey(name: 'aow_expneed')
  int aowExpneed;

  @JsonKey(name: 'aow_nexexpneed')
  int aowNexexpneed;

  Enemymatrix(
    this.id,
    this.level,
    this.pos,
    this.hp,
    this.attack,
    this.speed,
    this.power,
    this.qual,
    this.aowExp,
    this.aowId,
    this.aowNext,
    this.aowExpneed,
    this.aowNexexpneed,
  );

  factory Enemymatrix.fromJson(Map<String, dynamic> srcJson) =>
      _$EnemymatrixFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EnemymatrixToJson(this);
}

@JsonSerializable()
class Combat extends Object {
  @JsonKey(name: 'uin')
  int uin;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'ra')
  List<String> ra;

  @JsonKey(name: 'rs')
  List<String> rs;

  @JsonKey(name: 'effect')
  List<String> effect;

  Combat(
    this.uin,
    this.id,
    this.ra,
    this.rs,
    this.effect,
  );

  factory Combat.fromJson(Map<String, dynamic> srcJson) =>
      _$CombatFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CombatToJson(this);
}
