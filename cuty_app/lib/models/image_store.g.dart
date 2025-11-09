// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageStore _$ImageStoreFromJson(Map<String, dynamic> json) => ImageStore(
      id: (json['id'] as num).toInt(),
      fullUrl: json['url'] as String,
      contentType: json['content_type'] as String,
      originalFilename: json['original_filename'] as String,
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$ImageStoreToJson(ImageStore instance) =>
    <String, dynamic>{
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'id': instance.id,
      'url': instance.fullUrl,
      'content_type': instance.contentType,
      'original_filename': instance.originalFilename,
      'description': instance.description,
    };

PresignedUrlResponse _$PresignedUrlResponseFromJson(
        Map<String, dynamic> json) =>
    PresignedUrlResponse(
      image: ImageStore.fromJson(json['image'] as Map<String, dynamic>),
      upload: UploadInfo.fromJson(json['upload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PresignedUrlResponseToJson(
        PresignedUrlResponse instance) =>
    <String, dynamic>{
      'image': instance.image.toJson(),
      'upload': instance.upload.toJson(),
    };

UploadInfo _$UploadInfoFromJson(Map<String, dynamic> json) => UploadInfo(
      url: json['url'] as String,
      fields: json['fields'] as Map<String, dynamic>,
      key: json['key'] as String,
      bucketName: json['bucket_name'] as String,
    );

Map<String, dynamic> _$UploadInfoToJson(UploadInfo instance) =>
    <String, dynamic>{
      'url': instance.url,
      'fields': instance.fields,
      'key': instance.key,
      'bucket_name': instance.bucketName,
    };
