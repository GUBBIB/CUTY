// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostResponse _$PostResponseFromJson(Map<String, dynamic> json) => PostResponse(
  success: json['success'] as bool,
  data: PostData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PostResponseToJson(PostResponse instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};

PostData _$PostDataFromJson(Map<String, dynamic> json) => PostData(
  items: (json['items'] as List<dynamic>)
      .map((e) => PostDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PostDataToJson(PostData instance) => <String, dynamic>{
  'items': instance.items,
};

PostDto _$PostDtoFromJson(Map<String, dynamic> json) => PostDto(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  content: json['content'] as String?,
  likesCount: (json['likes_count'] as num?)?.toInt(),
  viewCount: (json['view_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$PostDtoToJson(PostDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'likes_count': instance.likesCount,
  'view_count': instance.viewCount,
};
