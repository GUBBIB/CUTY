import 'package:json_annotation/json_annotation.dart';
import 'package:cuty_app/models/user.dart';
import 'package:cuty_app/models/school.dart';
import 'package:cuty_app/models/college.dart';
import 'package:cuty_app/models/department.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  final int id;
  final String title;
  final String content;
  final String category;
  final String nickname;

  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  final User? user;
  final School? school;
  final College? college;
  final Department? department;

  @JsonKey(name: 'view_count')
  final int viewCount;

  @JsonKey(name: 'comment_count')
  final int commentCount;

  @JsonKey(name: 'like_count')
  final int likeCount;

  @JsonKey(name: 'dislike_count')
  final int dislikeCount;

  @JsonKey(name: 'user_like_status')
  final bool userLikeStatus;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.nickname,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.school,
    this.college,
    this.department,
    this.viewCount = 0,
    this.commentCount = 0,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.userLikeStatus = false,
  });

  bool get isDeleted => deletedAt != null;
  String get displayTitle => isDeleted ? "삭제된 게시글" : title;
  String get displayContent => isDeleted ? "삭제된 게시글" : content;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
