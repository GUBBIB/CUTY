import 'package:json_annotation/json_annotation.dart';

abstract class BaseModel {
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  BaseModel({
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  bool get isDeleted => deletedAt != null;
  DateTime? get createdTime => createdAt;
  DateTime? get updatedTime => updatedAt;
} 