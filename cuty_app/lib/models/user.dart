import 'package:cuty_app/models/country.dart';
import 'package:json_annotation/json_annotation.dart';
import 'school.dart';
import 'college.dart';
import 'department.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String? email;
  final String? name;

  final Country? country;
  final School? school;
  final College? college;
  final Department? department;

  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  User({
    required this.id,
    this.email,
    this.name,
    this.country,
    this.school,
    this.college,
    this.department,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  bool get isDeleted => deletedAt != null;
  String get displayName => isDeleted ? "삭제된 유저" : (name ?? "알 수 없음");

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
