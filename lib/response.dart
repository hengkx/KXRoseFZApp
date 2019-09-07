import './soil.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class BaseResponse {
  final int result;
  final String resultstr;
  final String uin;

  BaseResponse({this.result, this.resultstr, this.uin});

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}

@JsonSerializable()
class FruitGift {
  final int type;
  final int id;
  final int count;
  final String name;

  FruitGift({this.type, this.id, this.count, this.name});

  @override
  String toString() {
    return "$name $count  ";
  }

  factory FruitGift.fromJson(Map<String, dynamic> json) =>
      _$FruitGiftFromJson(json);

  Map<String, dynamic> toJson() => _$FruitGiftToJson(this);
}

@JsonSerializable()
class Gift {
  final int miliandanadd;
  final String tips;

  Gift({this.miliandanadd, this.tips});

  factory Gift.fromJson(Map<String, dynamic> json) => _$GiftFromJson(json);

  Map<String, dynamic> toJson() => _$GiftToJson(this);
}

@JsonSerializable()
class GetInitFirstResponse extends BaseResponse {
  // 时效普通化肥数量
  @JsonKey(name: 'prop506', defaultValue: 0)
  int timeCommonFerti;
  // 时效急速化肥数量
  @JsonKey(name: 'prop507', defaultValue: 0)
  int timeQuickFerti;
  // 时效普通化肥数量
  @JsonKey(name: 'prop508', defaultValue: 0)
  int timeMoreFerti;
  // 增产化肥数量
  int moreferti;
  // 超级急速化肥（分钟）
  @JsonKey(name: 'prop31004', defaultValue: 0)
  int superQuickFerti;
  // 普通化肥数量
  int commonferti;
  // 急速化肥数量
  int quickferti;

  GetInitFirstResponse(
      {result,
      resultstr,
      uin,
      this.timeCommonFerti,
      this.timeQuickFerti,
      this.timeMoreFerti,
      this.moreferti,
      this.superQuickFerti,
      this.commonferti,
      this.quickferti})
      : super(result: result, resultstr: resultstr, uin: uin);

  factory GetInitFirstResponse.fromJson(Map<String, dynamic> json) =>
      _$GetInitFirstResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetInitFirstResponseToJson(this);
}

@JsonSerializable()
class PlantResponse extends BaseResponse {
  final int soilno;
  final int soilsate;
  final int rosestate;
  final int addexperice;
  final String rosebegintime;
  final List<FruitGift> fruitgift;
  final List<Gift> gift;

  PlantResponse({
    result,
    resultstr,
    uin,
    this.soilno,
    this.soilsate,
    this.rosestate,
    this.addexperice,
    this.rosebegintime,
    this.fruitgift,
    this.gift,
  }) : super(result: result, resultstr: resultstr, uin: uin);

  @override
  String toString() {
    String roseName = Soil.getFlowerInfoById(soilsate).getAttribute("name");
    String fruitgiftStr = "";
    String giftStr = "";
    if (fruitgift != null) {
      for (int i = 0; i < fruitgift.length; i++) {
        fruitgiftStr += fruitgift.toString();
      }
    }
    if (gift != null) {
      for (int i = 0; i < gift.length; i++) {
        giftStr += gift[i].tips + "  ";
      }
    }
    return "[种植]： 自己 $soilno 号 $roseName 成功！经验+$addexperice 恭喜您 获得 $fruitgiftStr $giftStr";
  }

  factory PlantResponse.fromJson(Map<String, dynamic> json) =>
      _$PlantResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlantResponseToJson(this);
}

@JsonSerializable()
class GainResponse extends BaseResponse {
  final int soilno;
  // 花的id
  final int igainrosetype;
  // 收获数量
  final int igainrosecount;
  final int addcharm;
  final int addexperice;
  final List<FruitGift> fruitgift;
  final List<Gift> gift;

  GainResponse({
    result,
    resultstr,
    uin,
    this.soilno,
    this.igainrosetype,
    this.igainrosecount,
    this.addcharm,
    this.addexperice,
    this.fruitgift,
    this.gift,
  }) : super(result: result, resultstr: resultstr, uin: uin);

  @override
  String toString() {
    String roseName =
        Soil.getFlowerInfoById(igainrosetype).getAttribute("name");
    String fruitgiftStr = "";
    String giftStr = "";
    if (fruitgift != null) {
      for (int i = 0; i < fruitgift.length; i++) {
        fruitgiftStr += fruitgift.toString();
      }
    }
    if (gift != null) {
      for (int i = 0; i < gift.length; i++) {
        giftStr += gift[i].tips + "  ";
      }
    }
    return "[摘取]： 自己 $soilno 号 $roseName 成功！数量+$igainrosecount ,经验+$addexperice ,魅力+$addcharm 恭喜您 获得 $fruitgiftStr $giftStr";
  }

  factory GainResponse.fromJson(Map<String, dynamic> json) =>
      _$GainResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GainResponseToJson(this);
}

@JsonSerializable()
class HoeResponse extends BaseResponse {
  final int soilno;
  final List<FruitGift> fruitgift;
  final List<Gift> gift;

  HoeResponse({
    result,
    resultstr,
    uin,
    this.soilno,
    this.fruitgift,
    this.gift,
  }) : super(result: result, resultstr: resultstr, uin: uin);

  @override
  String toString() {
    String fruitgiftStr = "";
    String giftStr = "";
    if (fruitgift != null) {
      for (int i = 0; i < fruitgift.length; i++) {
        fruitgiftStr += fruitgift[i].toString();
      }
    }
    if (gift != null) {
      for (int i = 0; i < gift.length; i++) {
        giftStr += gift[i].tips + "  ";
      }
    }
    return "[松土]： 自己 $soilno 号 成功！,经验+2 恭喜您 获得 $fruitgiftStr $giftStr";
  }

  factory HoeResponse.fromJson(Map<String, dynamic> json) =>
      _$HoeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HoeResponseToJson(this);
}

@JsonSerializable()
class GetUserInfoResponse extends BaseResponse {
  final String usernic;
  final int userGender;
  final int hasphoto;
  final int is_gamevip;
  final int gameviplevel;
  final int annualvip;
  final int supervip;

  GetUserInfoResponse(
      {result,
      resultstr,
      uin,
      this.usernic,
      this.userGender,
      this.hasphoto,
      this.is_gamevip,
      this.gameviplevel,
      this.annualvip,
      this.supervip})
      : super(result: result, resultstr: resultstr, uin: uin);

  factory GetUserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserInfoResponseToJson(this);
}

@JsonSerializable()
class UseFertilizerResponse extends BaseResponse {
  final String rosebegintime;
  final int ferticount;
  final int gaincount;
  final int leftcount;
  final int rosestate;
  final int soilno;
  final int stealcount;
  final int usetype;
  final int isDouble;

  UseFertilizerResponse({
    result,
    resultstr,
    uin,
    this.rosebegintime,
    this.ferticount,
    this.gaincount,
    this.leftcount,
    this.rosestate,
    this.soilno,
    this.stealcount,
    this.usetype,
    this.isDouble,
  }) : super(result: result, resultstr: resultstr, uin: uin);

  factory UseFertilizerResponse.fromJson(Map<String, dynamic> json) =>
      _$UseFertilizerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UseFertilizerResponseToJson(this);
}

@JsonSerializable()
class UserTask {
  final int continueNum;
  final int data1;
  final int data2;
  final int data3;
  final int data4;
  final int data5;
  final int endTime;
  final int finishNum;
  final int finishTime;

  /// 1 任务已完成
  final int state;
  final int taskID;

  UserTask(
      {this.continueNum,
      this.data1,
      this.data2,
      this.data3,
      this.data4,
      this.data5,
      this.endTime,
      this.finishNum,
      this.finishTime,
      this.state,
      this.taskID});

  factory UserTask.fromJson(Map<String, dynamic> json) =>
      _$UserTaskFromJson(json);

  Map<String, dynamic> toJson() => _$UserTaskToJson(this);
}

@JsonSerializable()
class TaskResponse extends BaseResponse {
  @JsonKey(name: 'user_task', defaultValue: 0)
  final List<UserTask> userTasks;

  TaskResponse({
    result,
    resultstr,
    uin,
    this.userTasks,
  }) : super(result: result, resultstr: resultstr, uin: uin);

  factory TaskResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TaskResponseToJson(this);
}
