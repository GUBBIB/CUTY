// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostComment _$PostCommentFromJson(Map<String, dynamic> json) => PostComment(
      id: (json['id'] as num).toInt(),
      content: json['content'] as String?,
      nickname: json['nickname'] as String?,
      postId: (json['post_id'] as num).toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      parentId: (json['parent_id'] as num?)?.toInt(),
      replyCount: (json['reply_count'] as num?)?.toInt() ?? 0,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PostCommentToJson(PostComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'nickname': instance.nickname,
      'user': instance.user,
      'post_id': instance.postId,
      'parent_id': instance.parentId,
      'reply_count': instance.replyCount,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
