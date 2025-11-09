import 'package:json_annotation/json_annotation.dart';

part 'post_like.g.dart';

@JsonSerializable()
class PostLike {
  final int id;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'post_id')
  final int postId;

  final String type;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  PostLike({
    required this.id,
    required this.userId,
    required this.postId,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostLike.fromJson(Map<String, dynamic> json) =>
      _$PostLikeFromJson(json);
  Map<String, dynamic> toJson() => _$PostLikeToJson(this);
}
