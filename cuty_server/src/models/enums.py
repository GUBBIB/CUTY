from enum import Enum

class UserType(str, Enum):
    USER = "USER"     # 일반 사용자
    ADMIN = "ADMIN"   # 관리자 
    SCHOOL = "SCHOOL" # 학교 담당자

class DocumentType(str, Enum):
    STUDENT_ID = "STUDENT_ID"                           # 학생증
    PASSPORT_COPY = "PASSPORT_COPY"                     # 여권사본
    ENROLLMENT_CERTIFICATE = "ENROLLMENT_CERTIFICATE"   # 재학증명서
    TRANSCRIPT = "TRANSCRIPT"                           # 성적증명서
    TOPIK_CERTIFICATE = "TOPIK_CERTIFICATE"             # 토픽증명서
    SOCIAL_INTEGRATION_CERTIFICATE = "SOCIAL_INTEGRATION_CERTIFICATE"  # 사회통합교육증명서
    RESIDENCE_CERTIFICATE = "RESIDENCE_CERTIFICATE"     # 거주지 증명서
    RENTAL_CONTRACT = "RENTAL_CONTRACT"                 # 임대차 계약서
    DORMITORY_CERTIFICATE = "DORMITORY_CERTIFICATE"     # 기숙사 거주 인증서
    RESIDENCE_CONFIRMATION = "RESIDENCE_CONFIRMATION"   # 거주지 제공 확인서
    VOLUNTEER_CERTIFICATE = "VOLUNTEER_CERTIFICATE"     # 봉사활동 인증서
    LANGUAGE_CERTIFICATE = "LANGUAGE_CERTIFICATE"       # 외국어 증명서
    CAREER_CERTIFICATE = "CAREER_CERTIFICATE"           # 경력인증서
    AWARD = "AWARD"                                     # 상장
    COMPLETION_CERTIFICATE = "COMPLETION_CERTIFICATE"   # 수료증
    LICENSE = "LICENSE"                                 # 면허
    QUALIFICATION = "QUALIFICATION"                     # 자격증
    OTHER = "OTHER"                                     # 기타 

class ReqType(str, Enum):
    PART_TIME = "PART_TIME"

class ReqState(str, Enum):
    PENDING = "PENDING"
    REJECTED = "REJECTED"
    APPROVED = "APPROVED"
    CANCELED = "CANCELED"

class SexType(str, Enum):
    MALE = "MALE"
    FEMALE = "FEMALE"
    OTHER = "OTHER"