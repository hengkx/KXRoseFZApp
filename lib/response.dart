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

  UseFertilizerResponse(
      {result,
      resultstr,
      uin,
      this.rosebegintime,
      this.ferticount,
      this.gaincount,
      this.leftcount,
      this.rosestate,
      this.soilno,
      this.stealcount,
      this.usetype})
      : super(result: result, resultstr: resultstr, uin: uin);

  factory UseFertilizerResponse.fromJson(Map<String, dynamic> json) =>
      _$UseFertilizerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UseFertilizerResponseToJson(this);
}
