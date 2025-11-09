// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      documentType: $enumDecode(_$DocumentTypeEnumMap, json['document_type']),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      imageStore: json['image_store'] == null
          ? null
          : ImageStore.fromJson(json['image_store'] as Map<String, dynamic>),
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

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'id': instance.id,
      'name': instance.name,
      'document_type': _$DocumentTypeEnumMap[instance.documentType]!,
      'user': instance.user?.toJson(),
      'image_store': instance.imageStore?.toJson(),
    };

const _$DocumentTypeEnumMap = {
  DocumentType.studentId: 'STUDENT_ID',
  DocumentType.passportCopy: 'PASSPORT_COPY',
  DocumentType.enrollmentCertificate: 'ENROLLMENT_CERTIFICATE',
  DocumentType.transcript: 'TRANSCRIPT',
  DocumentType.topikCertificate: 'TOPIK_CERTIFICATE',
  DocumentType.socialIntegrationCertificate: 'SOCIAL_INTEGRATION_CERTIFICATE',
  DocumentType.residenceCertificate: 'RESIDENCE_CERTIFICATE',
  DocumentType.rentalContract: 'RENTAL_CONTRACT',
  DocumentType.dormitoryCertificate: 'DORMITORY_CERTIFICATE',
  DocumentType.residenceConfirmation: 'RESIDENCE_CONFIRMATION',
  DocumentType.volunteerCertificate: 'VOLUNTEER_CERTIFICATE',
  DocumentType.languageCertificate: 'LANGUAGE_CERTIFICATE',
  DocumentType.careerCertificate: 'CAREER_CERTIFICATE',
  DocumentType.award: 'AWARD',
  DocumentType.completionCertificate: 'COMPLETION_CERTIFICATE',
  DocumentType.license: 'LICENSE',
  DocumentType.qualification: 'QUALIFICATION',
  DocumentType.other: 'OTHER',
};
