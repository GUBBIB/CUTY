# Cuty App

대학생 커뮤니티 애플리케이션 - Flutter 기반 크로스 플랫폼 모바일 앱

## 프로젝트 개요

Cuty App은 대학생들을 위한 커뮤니티 플랫폼으로, 게시글 작성/조회, 댓글, 좋아요, 그리고 문서 관리 기능을 제공합니다. Flutter를 사용하여 iOS와 Android 모두에서 동작하는 크로스 플랫폼 애플리케이션입니다.

### 주요 기능

- **사용자 인증**: 회원가입, 로그인, 비밀번호 변경
- **커뮤니티**
  - 게시글 작성, 수정, 삭제
  - 댓글 작성 및 답글
  - 게시글 좋아요
  - 카테고리별 게시글 조회
- **마이페이지**
  - 내가 작성한 게시글 관리
  - 내가 작성한 댓글 관리
  - 내 문서 관리
- **문서 관리**
  - PDF 파일 업로드 및 조회
  - PDF 뷰어 기능
- **학교 정보**: 국가, 학교, 단과대, 학과 정보 관리

## 기술 스택

### 프레임워크 및 언어
- **Flutter**: 3.5.3
- **Dart**: 3.5.3

### 주요 패키지
- `http`: REST API 통신
- `shared_preferences`: 로컬 데이터 저장 (토큰 등)
- `json_annotation` & `json_serializable`: JSON 직렬화
- `file_picker`: 파일 선택
- `syncfusion_flutter_pdfviewer` & `pdfx`: PDF 뷰어
- `path_provider`: 파일 시스템 경로 관리
- `flutter_launcher_icons`: 앱 아이콘 생성

## 프로젝트 구조

```
lib/
├── common/
│   ├── component/          # 재사용 가능한 UI 컴포넌트
│   ├── layout/            # 레이아웃 위젯
│   └── screen/            # 공통 화면
├── config/
│   ├── app_config.dart    # 환경별 API 설정
│   ├── app_colors.dart    # 컬러 테마
│   └── app_theme.dart     # 앱 테마
├── models/                # 데이터 모델
├── screens/               # 화면 위젯
├── services/              # API 서비스
└── main.dart             # 앱 진입점
```

## 환경 설정

### API 엔드포인트

앱은 개발 환경과 프로덕션 환경을 자동으로 구분합니다:

- **개발 환경** (Debug 모드)
  - iOS 시뮬레이터: `http://localhost:5012/api/v1`
  - Android 에뮬레이터: `http://10.0.2.2:5012/api/v1`
  - 실제 기기: `http://192.168.0.50:5012/api/v1` (네트워크에 맞게 IP 수정 필요)

- **프로덕션 환경** (Release 모드)
  - AWS API Gateway: `https://zm3czse9yf.execute-api.ap-northeast-2.amazonaws.com/prod/api/v1`

**실제 기기에서 개발 서버 연결 시:**
[lib/config/app_config.dart](lib/config/app_config.dart)에서 `_forceUseRealDevice`를 `true`로 설정하고, `macRealIP`를 개발 서버의 실제 IP로 변경하세요.

### 필수 요구사항

- Flutter SDK 3.5.3 이상
- Dart 3.5.3 이상
- iOS 개발: Xcode (최신 버전 권장)
- Android 개발: Android Studio (최신 버전 권장)

## 설치 및 실행

### 1. 프로젝트 클론

```bash
git clone <repository-url>
cd cuty_app
```

### 2. 의존성 설치

```bash
flutter pub get
```

### 3. 코드 생성 (JSON 직렬화)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. 앱 아이콘 생성

```bash
flutter pub run flutter_launcher_icons
```

### 5. 실행

#### iOS
```bash
flutter run -d ios
```

#### Android
```bash
flutter run -d android
```

## 빌드 및 배포

### Android APK/AAB 빌드

#### 사전 준비
1. Android 서명 키 생성
   ```bash
   keytool -genkey -v -keystore ~/cuty-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias cuty
   ```

2. [android/key.properties](android/key.properties) 파일 생성
   ```properties
   storePassword=<키스토어 비밀번호>
   keyPassword=<키 비밀번호>
   keyAlias=cuty
   storeFile=<키스토어 파일 경로>
   ```

#### APK 빌드 (테스트용)
```bash
flutter build apk --release
```
생성 위치: `build/app/outputs/flutter-apk/app-release.apk`

#### AAB 빌드 (Google Play 배포용)
```bash
flutter build appbundle --release
```
생성 위치: `build/app/outputs/bundle/release/app-release.aab`

#### Google Play 배포
1. [Google Play Console](https://play.google.com/console)에 로그인
2. 앱 생성 또는 기존 앱 선택
3. "프로덕션" 또는 "테스트" 트랙 선택
4. 새 릴리스 생성 및 AAB 파일 업로드
5. 릴리스 노트 작성 및 검토
6. 출시

### iOS IPA 빌드

#### 사전 준비
1. Apple Developer 계정 필요
2. Xcode에서 서명 설정
   - Xcode에서 `ios/Runner.xcworkspace` 열기
   - Runner > Signing & Capabilities에서 Team 선택
   - Bundle Identifier 확인: `com.univ.cuty`

#### IPA 빌드
```bash
flutter build ios --release
```

#### App Store 배포
1. Xcode에서 `ios/Runner.xcworkspace` 열기
2. Product > Archive 선택
3. Organizer에서 Archive 확인
4. "Distribute App" 선택
5. App Store Connect 업로드
6. [App Store Connect](https://appstoreconnect.apple.com)에서 앱 정보 입력 및 검토 제출

### 버전 관리

버전은 [pubspec.yaml](pubspec.yaml)에서 관리됩니다:
```yaml
version: 1.0.0+3
```
- `1.0.0`: 버전 이름 (사용자에게 표시)
- `3`: 빌드 번호 (배포할 때마다 증가)

버전 변경 후:
```bash
flutter clean
flutter pub get
```

## 개발 가이드

### 새로운 모델 추가 시

1. `lib/models/`에 모델 클래스 생성
2. `json_annotation` 추가
3. 코드 생성 실행:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### API 서비스 추가 시

1. `lib/services/`에 서비스 클래스 생성
2. `AppConfig.baseApiUrl`을 사용하여 엔드포인트 구성
3. `TokenService`를 통해 인증 토큰 관리

## 트러블슈팅

### "Gradle task assembleDebug failed with exit code 1"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### iOS 빌드 실패
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### JSON 직렬화 오류
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

## 라이선스

이 프로젝트는 비공개 프로젝트입니다.
