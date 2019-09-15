import 'package:json_annotation/json_annotation.dart';

part 'award.g.dart';

@JsonSerializable()
class Award {
  int id;

  int type;

  int count;

  String name;

  Award(
    this.id,
    this.type,
    this.count,
    this.name,
  );

  factory Award.fromJson(Map<String, dynamic> srcJson) =>
      _$AwardFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AwardToJson(this);
}
