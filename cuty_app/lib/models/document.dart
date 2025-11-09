import 'package:json_annotation/json_annotation.dart';
import 'package:cuty_app/models/base_model.dart';
import 'package:cuty_app/models/user.dart';
import 'package:cuty_app/models/image_store.dart';

part 'document.g.dart';

/// 서류 타입 enum
enum DocumentType {
  @JsonValue('STUDENT_ID')
  studentId('STUDENT_ID', '학생증'),
  
  @JsonValue('PASSPORT_COPY')
  passportCopy('PASSPORT_COPY', '여권사본'),
  
  @JsonValue('ENROLLMENT_CERTIFICATE')
  enrollmentCertificate('ENROLLMENT_CERTIFICATE', '재학증명서'),
  
  @JsonValue('TRANSCRIPT')
  transcript('TRANSCRIPT', '성적증명서'),
  
  @JsonValue('TOPIK_CERTIFICATE')
  topikCertificate('TOPIK_CERTIFICATE', '토픽증명서'),
  
  @JsonValue('SOCIAL_INTEGRATION_CERTIFICATE')
  socialIntegrationCertificate('SOCIAL_INTEGRATION_CERTIFICATE', '사회통합교육증명서'),
  
  @JsonValue('RESIDENCE_CERTIFICATE')
  residenceCertificate('RESIDENCE_CERTIFICATE', '거주지 증명서'),
  
  @JsonValue('RENTAL_CONTRACT')
  rentalContract('RENTAL_CONTRACT', '임대차 계약서'),
  
  @JsonValue('DORMITORY_CERTIFICATE')
  dormitoryCertificate('DORMITORY_CERTIFICATE', '기숙사 거주 인증서'),
  
  @JsonValue('RESIDENCE_CONFIRMATION')
  residenceConfirmation('RESIDENCE_CONFIRMATION', '거주지 제공 확인서'),
  
  @JsonValue('VOLUNTEER_CERTIFICATE')
  volunteerCertificate('VOLUNTEER_CERTIFICATE', '봉사활동 인증서'),
  
  @JsonValue('LANGUAGE_CERTIFICATE')
  languageCertificate('LANGUAGE_CERTIFICATE', '외국어 증명서'),
  
  @JsonValue('CAREER_CERTIFICATE')
  careerCertificate('CAREER_CERTIFICATE', '경력인증서'),
  
  @JsonValue('AWARD')
  award('AWARD', '상장'),
  
  @JsonValue('COMPLETION_CERTIFICATE')
  completionCertificate('COMPLETION_CERTIFICATE', '수료증'),
  
  @JsonValue('LICENSE')
  license('LICENSE', '면허'),
  
  @JsonValue('QUALIFICATION')
  qualification('QUALIFICATION', '자격증'),
  
  @JsonValue('OTHER')
  other('OTHER', '기타');

  const DocumentType(this.value, this.displayName);

  final String value;
  final String displayName;

  static DocumentType? fromString(String value) {
    for (DocumentType type in DocumentType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return null;
  }
}

@JsonSerializable(explicitToJson: true)
class Document extends BaseModel {
  final int id;

  final String? name;  // 서류 이름

  @JsonKey(name: 'document_type')
  final DocumentType documentType;





  final User? user;

  @JsonKey(name: 'image_store')
  final ImageStore? imageStore;

  Document({
    required this.id,
    this.name,
    required this.documentType,
    this.user,
    this.imageStore,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  /// 삭제된 서류인지 확인
  bool get isDocumentDeleted => isDeleted;

  /// 서류 타입 표시명
  String get documentTypeName => documentType.displayName;

  /// 서류 이미지 URL (삭제되지 않은 경우)
  String? get documentImageUrl {
    if (isDeleted || imageStore == null) return null;
    return imageStore!.imageUrl;
  }

  factory Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);
  
  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}
