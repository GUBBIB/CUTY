import 'package:json_annotation/json_annotation.dart';

part 'college.g.dart';

@JsonSerializable()
class College {
  final int id;
  final String name;

  College({
    required this.id,
    required this.name,
  });

  factory College.fromJson(Map<String, dynamic> json) =>
      _$CollegeFromJson(json);
  Map<String, dynamic> toJson() => _$CollegeToJson(this);
}
