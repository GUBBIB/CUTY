import 'package:cuty_app/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_comment.g.dart';

@JsonSerializable()
class PostComment {
  final int id;
  final String? content;
  final String? nickname;

  final User? user;

  @JsonKey(name: 'post_id')
  final int postId;

  @JsonKey(name: 'parent_id')
  final int? parentId;

  @JsonKey(name: 'reply_count')
  final int replyCount;

  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  PostComment({
    required this.id,
    this.content,
    this.nickname,
    required this.postId,
    this.user,
    this.parentId,
    this.replyCount = 0,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isDeleted => deletedAt != null;
  String get displayContent => isDeleted ? "삭제된 댓글입니다" : content ?? "";
  String get displayNickname => isDeleted ? "알 수 없음" : nickname ?? "";

  factory PostComment.fromJson(Map<String, dynamic> json) =>
      _$PostCommentFromJson(json);
  Map<String, dynamic> toJson() => _$PostCommentToJson(this);
}
