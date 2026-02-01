import 'package:json_annotation/json_annotation.dart';

part 'post_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PostResponse {
  final bool success;
  final PostData data;

  PostResponse({required this.success, required this.data});

  factory PostResponse.fromJson(Map<String, dynamic> json) => _$PostResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PostResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PostData {
  final List<PostDto> items;

  PostData({required this.items});

  factory PostData.fromJson(Map<String, dynamic> json) => _$PostDataFromJson(json);
  Map<String, dynamic> toJson() => _$PostDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PostDto {
  final int id;
  final String title;
  final String? content;
  final int? likesCount; // Matching API typical snake_case
  final int? viewCount;
  // Add other fields as necessary based on API response, allowing nulls for safety

  PostDto({
    required this.id,
    required this.title,
    this.content,
    this.likesCount,
    this.viewCount,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) => _$PostDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PostDtoToJson(this);
}
