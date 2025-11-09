import 'package:json_annotation/json_annotation.dart';
import 'package:cuty_app/models/base_model.dart';

part 'image_store.g.dart';

@JsonSerializable(explicitToJson: true)
class ImageStore extends BaseModel {
  final int id;

  @JsonKey(name: 'url')
  final String fullUrl;

  @JsonKey(name: 'content_type')
  final String contentType;

  @JsonKey(name: 'original_filename')
  final String originalFilename;

  @JsonKey(name: 'description')
  final String? description;

  ImageStore({
    required this.id,
    required this.fullUrl,
    required this.contentType,
    required this.originalFilename,
    this.description,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  // 이미지 URL 직접 접근을 위한 getter
  String get imageUrl => fullUrl;

  factory ImageStore.fromJson(Map<String, dynamic> json) =>
      _$ImageStoreFromJson(json);
  Map<String, dynamic> toJson() => _$ImageStoreToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PresignedUrlResponse {
  final ImageStore image;
  final UploadInfo upload;

  PresignedUrlResponse({required this.image, required this.upload});

  factory PresignedUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$PresignedUrlResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PresignedUrlResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UploadInfo {
  final String url;
  final Map<String, dynamic> fields;
  final String key;
  @JsonKey(name: 'bucket_name')
  final String bucketName;

  UploadInfo({
    required this.url,
    required this.fields,
    required this.key,
    required this.bucketName,
  });

  factory UploadInfo.fromJson(Map<String, dynamic> json) =>
      _$UploadInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UploadInfoToJson(this);
}
