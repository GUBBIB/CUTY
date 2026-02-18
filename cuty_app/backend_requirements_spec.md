# Cuty 백엔드 요구사항 명세서 (API 및 로직 명세)

**버전**: 1.0  
**작성일**: 2026-02-14  
**타겟**: 백엔드 개발팀  
**범위**: Flutter 프로젝트 `lib/` 폴더 전체 코드베이스 분석 기반.

---

## 🏗️ 일반 표준 (General Standards)

1.  **네이밍 규칙**:
    -   **API 요청/응답 필드**: `snake_case` (예: `user_id`, `is_visa_linked`).
    -   **프론트엔드 코드 참조**: `camelCase` (변수명 그대로 참조).
2.  **Base URL**: `https://api.cuty.app` (예시) -> `ApiService`에서 설정 가능.
3.  **인증 방식**: `Authorization` 헤더에 Bearer Token (JWT) 사용.

---

## 1. 🔐 인증 및 유저 관리 (Auth & User Management)

### 1.1 로그인 및 인증 (Login & Auth)
*   **현재 로직**: `lib/providers/auth_provider.dart`에서 `ApiService.login` 호출.
*   **요구사항**: 이메일/비밀번호 기반 인증.
*   **To-Do**: UI 디자인에는 소셜 로그인(구글/카카오/애플)이 포함되어 있으나, 현재 프론트 로직에는 미구현 상태임. (추후 구현 필요)

| Method | Endpoint | 설명 | 요청 (JSON) | 응답 (JSON) |
| :--- | :--- | :--- | :--- | :--- |
| **POST** | `/api/v1/auth/login` | 이메일 로그인 및 토큰 발급 | `{ "email": "...", "password": "..." }` | `{ "access_token": "...", "refresh_token": "..." }` |
| **POST** | `/api/v1/auth/refresh` | **[필요]** 액세스 토큰 갱신 | `{ "refresh_token": "..." }` | `{ "access_token": "..." }` |

### 1.2 유저 프로필 (User Profile)
*   **모델**: `lib/models/user.dart`.
*   **참고**: 현재 일부 목업 데이터(`User.dummy()`) 사용 중.

| Method | Endpoint | 설명 | 요청 (JSON) | 응답 (JSON) |
| :--- | :--- | :--- | :--- | :--- |
| **GET** | `/api/v1/users/me` | 내 상세 프로필 조회 | (토큰 헤더) | **User 객체** (하단 참조) |
| **PUT** | `/api/v1/users/me` | **[필요]** 프로필 수정 | `{ "nickname": "...", "avatar_url": "..." }` | **User 객체** |

#### **User 객체 구조 (JSON 매핑 예시)**
```json
{
  "id": 123,
  "name": "Kim Cuty",
  "email": "test@university.ac.kr",
  "school": { "id": 1, "name": "Seoul Univ" },
  "college": { "id": 10, "name": "Engineering" },
  "department": { "id": 100, "name": "Computer Science" },
  "country": { "id": 82, "name": "Vietnam" },
  "is_nationality_hidden": false, // 프론트 변수: isNationalityHidden
  "is_gender_hidden": false,
  "is_school_hidden": false,
  "is_nickname_hidden": false
}
```

---

## 2. 🎯 비자 진단 (Visa Diagnosis)

*   **중요**: 현재 `lib/providers/diagnosis_provider.dart`의 `DiagnosisNotifier` 안에 **점수 계산 로직이 클라이언트에 포함**되어 있습니다. 보안 및 유지보수를 위해 이 로직은 반드시 **백엔드로 이관**되어야 합니다.
*   **모델**: `lib/models/diagnosis_model.dart`.

### 2.1 진단 실행 및 결과

| Method | Endpoint | 설명 | 요청 (JSON) | 응답 (JSON) |
| :--- | :--- | :--- | :--- | :--- |
| **POST** | `/api/v1/diagnosis` | 답변 제출 및 결과 분석 요청 | **SurveyAnswer** | **DiagnosisResult** |
| **GET** | `/api/v1/diagnosis/last` | 최근 진단 결과 조회 | - | **DiagnosisResult** |

#### **요청 바디: SurveyAnswer (설문 답변)**
```json
{
  "target_jobs": ["IT 개발", "데이터 분석"], // 프론트: targetJobs
  "preferred_locations": ["서울", "판교"], // 프론트: preferredLocations
  "korean_level": "비즈니스 (토론 가능)", // 프론트: koreanLevel
  "experiences": [ // 프론트: experiences
    {
      "category": "인턴십",
      "detail_type": "사무/행정",
      "custom_input": "Start-up Inc."
    }
  ]
}
```

#### **응답 바디: DiagnosisResult (진단 결과)**
```json
{
  "total_score": 85,
  "total_tier": "Platinum", // Diamond, Platinum, Gold, Silver
  "tier_description": "우수 인재! 조금만 더 다듬으면 완벽합니다.",
  "solution_docs": ["TOPIK II 5급", "정보처리기사"],
  "analysis_results": { // Map<JobCode, JobAnalysisData>
    "2351": {
      "job_code": "2351",
      "job_name": "데이터 전문가",
      "visa_status": "GREEN", // GREEN, YELLOW, RED
      "avg_salary": "4,200만원",
      "my_scores": { "언어": 80, "전문성": 70, ... },
      "avg_scores": { "언어": 90, "전문성": 80, ... }
    }
  }
}
```

---

## 3. 📄 시간제 취업 허가제 & 서류 (Alba Permit)

*   **로직**: `lib/providers/alba_permit_provider.dart`에 구현된 10단계 마법사(Wizard).
*   **요구사항**: 사업자등록증, 근로계약서 등 민감한 파일의 업로드와 신청서 제출 API 필요.

### 3.1 파일 업로드 (File Upload)
| Method | Endpoint | 설명 | 요청 바디 | 응답 |
| :--- | :--- | :--- | :--- | :--- |
| **POST** | `/api/v1/uploads` | 일반 파일 업로드 | `multipart/form-data` (file) | `{ "file_url": "https://..." }` |

### 3.2 시간제 취업 허가 신청 (Alba Permit Application)
| Method | Endpoint | 설명 | 요청 (JSON) | 응답 |
| :--- | :--- | :--- | :--- | :--- |
| **POST** | `/api/v1/alba-permit` | 신청서 제출 | **AlbaApplication** | `{ "application_id": 123, "status": "PENDING" }` |
| **GET** | `/api/v1/alba-permit/status` | 신청 상태 조회 | - | `{ "status": "SCHOOL_APPROVED", "reject_reason": null }` |

#### **요청 바디: AlbaApplication**
`AlbaPermitState` 구조 기반.
```json
{
  "student_info": {
    "name": "...", "reg_no": "...", "major": "...", "semester": "...",
    "phone": "...", "email": "..."
  },
  "employer_info": {
    "company_name": "...", "biz_no": "...", "owner_name": "...",
    "address": "...", "phone": "..."
  },
  "work_condition": {
    "period": "...", "hourly_wage": "...", "days_work": "..."
  },
  "documents": {
    "biz_license_url": "https://...",
    "labor_contract_url": "https://...",
    "id_card_url": "https://...",
    "signature_image_url": "https://..." // 좌표 데이터를 이미지로 변환해서 올리거나, 좌표 자체를 전송
  }
}
```

---

## 4. 👑 프리미엄 컨설팅 및 광고 (Consulting & Ads)

### 4.1 컨설팅 (Consulting)
*   **현재 로직**: `ConsultingDetailScreen`은 현재 플레이스홀더(준비중) 상태임.
*   **요구사항**: 판매 가능한 컨설팅 상품 리스트나 예약 가능한 슬롯 정보를 불러오는 API 필요.

| Method | Endpoint | 설명 | 요청 | 응답 |
| :--- | :--- | :--- | :--- | :--- |
| **GET** | `/api/v1/consulting/products` | **[필요]** 상품 목록 조회 | - | JSON List |

### 4.2 광고 배너 (Advertisements)
*   **현재 로직**: `lib/models/ad_model.dart`에 하드코딩 되어 있음.
*   **요구사항**: 배치 위치(홈, 게시판 타입 등)에 따라 동적으로 광고를 내려주는 API 필요.

| Method | Endpoint | 설명 | 요청 | 응답 |
| :--- | :--- | :--- | :--- | :--- |
| **GET** | `/api/v1/ads` | 광고 목록 조회 | `?placement=HOME` or `?board_type=FREE` | **List<AdItem>** |

#### **AdItem 구조**
```json
{
  "image_url": "...",
  "link_url": "...",
  "title": "TOPIK 50% 할인",
  "sponsor_name": "해커스",
  "target": "ALL" // 타겟팅 옵션 (선택사항)
}
```

---

## 5. ⚙️ 시스템 및 공통 (System & Common)

### 5.1 커뮤니티 게시판 (Community)
*   **모델**: `lib/models/community_model.dart`.
*   **게시판 타입**: `FREE`(자유), `INFO`(정보), `QUESTION`(질문), `MARKET`(장터), `SECRET`(비밀).

| Method | Endpoint | 설명 | 요청 파라미터 |
| :--- | :--- | :--- | :--- |
| **GET** | `/api/v1/posts` | 게시글 목록 조회 | `?board_type=FREE&page=1&limit=20` |
| **GET** | `/api/v1/posts/{id}` | 게시글 상세 조회 | - |
| **POST** | `/api/v1/posts` | 게시글 작성 | `{ "board_type": "FREE", "title": "...", "content": "..." }` |
| **POST** | `/api/v1/posts/{id}/like` | 좋아요 | - |

### 5.2 시스템 설정 (System Config)
*   **요구사항**: 앱 실행 시 강제 업데이트 여부를 판단하기 위한 버전 체크 로직이 `main.dart`에 필요함.

| Method | Endpoint | 설명 | 응답 |
| :--- | :--- | :--- | :--- |
| **GET** | `/api/v1/system/version` | **[필요]** 최소 버전 체크 | `{ "min_version": "1.0.2", "latest_version": "1.1.0", "force_update": true }` |
| **GET** | `/api/v1/system/notices` | **[필요]** 전체 공지사항 | 공지사항 리스트 |

---

## ✅ 백엔드 팀 주요 전달사항 (Summary)

1.  **진단 로직 이관**: `DiagnosisNotifier`에 있는 복잡한 점수 계산 로직을 백엔드 API(`POST /api/v1/diagnosis`)로 구현해 주세요.
2.  **파일 업로드**: 시간제 취업 허가(`AlbaPermit`) 신청 시 사업자등록증, 신분증 등 민감한 서류의 멀티파트 업로드가 필요합니다.
3.  **광고 시스템**: 하드코딩된 `AdItem`을 대체할 수 있는 동적 광고 API가 필요합니다.
4.  **커뮤니티**: 5가지 게시판 타입(`FREE`, `INFO` 등)을 지원하는 표준 CRUD API가 필요합니다.
5.  **유저 프로필**: 닉네임, 아바타 등을 수정할 수 있는 `PUT` 엔드포인트가 필요합니다.
