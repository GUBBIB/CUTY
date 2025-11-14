# Cuty Server

Flask 기반의 RESTful API 서버로, 학교 커뮤니티 플랫폼을 위한 백엔드 서비스입니다.

## 프로젝트 개요

Cuty Server는 학교 커뮤니티 서비스를 위한 백엔드 API를 제공합니다. 사용자 인증, 게시글 관리, 댓글, 좋아요, 서류 업로드 등의 기능을 포함하고 있습니다.

## 기술 스택

- **Python**: 3.12 (Zappa 요구사항)
- **프레임워크**: Flask 3.1.0
- **데이터베이스**: PostgreSQL (SQLAlchemy ORM)
- **인증**: JWT (PyJWT)
- **파일 저장소**: AWS S3 + CloudFront
- **배포**: AWS Lambda (Zappa)
- **마이그레이션**: Flask-Migrate (Alembic)

## 주요 기능

### 1. 인증 시스템
- 사용자 회원가입 및 로그인
- JWT 기반 토큰 인증
- 비밀번호 암호화 (bcrypt)

### 2. 게시글 관리
- 게시글 CRUD 기능
- 조회수 관리
- 좋아요 기능
- 댓글 시스템

### 3. 학교 정보
- 국가별 학교 정보 관리
- 학교 검색 기능

### 4. 서류 관리
- PDF 파일 업로드 (최대 10MB)
- AWS S3 저장
- CloudFront CDN 제공

### 5. 이미지 관리
- 이미지 파일 업로드
- S3 기반 저장소

## 프로젝트 구조

```
cuty_server/
├── app.py                  # 애플리케이션 진입점
├── requirements.txt        # Python 의존성
├── zappa_settings.json    # Zappa 배포 설정
├── migrations/            # 데이터베이스 마이그레이션 파일
└── src/
    ├── config/           # 설정 파일
    │   ├── env.py       # 환경 변수 설정
    │   └── database.py  # 데이터베이스 설정
    ├── models/          # 데이터베이스 모델
    │   ├── user.py
    │   ├── post.py
    │   ├── comment.py
    │   ├── document.py
    │   ├── school.py
    │   └── ...
    ├── routes/          # API 라우트
    │   └── v1/
    │       ├── auth_routes.py
    │       ├── post_routes.py
    │       ├── comment_routes.py
    │       ├── document_routes.py
    │       └── ...
    ├── services/        # 비즈니스 로직
    │   ├── auth_service.py
    │   ├── post_service.py
    │   ├── document_service.py
    │   ├── s3_service.py
    │   └── ...
    └── utils/           # 유틸리티 함수
```

## API 엔드포인트

### 인증 (`/api/v1/auth`)
- 회원가입, 로그인, 토큰 갱신

### 학교 (`/api/v1/countries`)
- 국가별 학교 정보 조회

### 게시글 (`/api/v1/posts`)
- 게시글 CRUD
- 좋아요 기능

### 댓글 (`/api/v1/posts`)
- 댓글 CRUD

### 사용자 (`/api/v1/users`)
- 사용자 정보 조회 및 수정

### 서류 (`/api/v1/documents`)
- PDF 서류 업로드 및 관리

### 이미지 (`/api/v1/images`)
- 이미지 업로드 및 관리

### 신청 (`/api/v1/requests`)
- 시간제 취업 등 검토 신청


## 프로젝트 초기 설정

### 사전 요구사항

프로젝트를 시작하기 전에 다음 소프트웨어가 설치되어 있어야 합니다:

#### 1. Python 3.12 설치

**중요**: 이 프로젝트는 Zappa를 사용하여 AWS Lambda에 배포되므로, **반드시 Python 3.12**를 사용해야 합니다.

**macOS (Homebrew 사용):**
```bash
brew install python@3.12
```

**Ubuntu/Debian:**
```bash
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.12 python3.12-venv python3.12-dev
```

**Windows:**
- [Python 공식 웹사이트](https://www.python.org/downloads/)에서 Python 3.12 다운로드 및 설치

**설치 확인:**
```bash
python3.12 --version
# 출력: Python 3.12.x
```

#### 2. PostgreSQL 설치

**macOS:**
```bash
brew install postgresql@15
brew services start postgresql@15
```

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

**Windows:**
- [PostgreSQL 공식 웹사이트](https://www.postgresql.org/download/windows/)에서 다운로드 및 설치

#### 3. AWS CLI 설치 (배포용)

**macOS:**
```bash
brew install awscli
```

**Linux:**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

**Windows:**
- [AWS CLI 설치 가이드](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) 참고

**설치 확인:**
```bash
aws --version
```

### 프로젝트 설치

#### 1. 저장소 클론

```bash
git clone <repository-url>
cd cuty_server
```

#### 2. Python 3.12로 가상환경 생성

**중요**: 반드시 Python 3.12로 가상환경을 생성해야 합니다.

```bash
# Python 3.12로 가상환경 생성
python3.12 -m venv .venv

# 가상환경 활성화
source .venv/bin/activate  # macOS/Linux
# Windows: .venv\Scripts\activate
```

**가상환경 활성화 확인:**
```bash
python --version
# 출력: Python 3.12.x
```

#### 3. pip 업그레이드 및 의존성 설치

```bash
# pip 업그레이드
pip install --upgrade pip

# 의존성 설치
pip install -r requirements.txt
```

설치되는 주요 패키지:
- Flask 3.1.0 (웹 프레임워크)
- SQLAlchemy 2.0.37 (ORM)
- psycopg2-binary 2.9.10 (PostgreSQL 드라이버)
- Flask-Migrate 4.1.0 (DB 마이그레이션)
- boto3 (AWS SDK)
- zappa 0.59.0 (서버리스 배포)
- PyJWT (JWT 인증)
- bcrypt (비밀번호 암호화)

#### 4. PostgreSQL 데이터베이스 생성

PostgreSQL에 접속하여 데이터베이스를 생성합니다:

```bash
# PostgreSQL 접속 (macOS/Linux)
psql -U postgres

# 또는 사용자명으로 접속
psql -U your_username
```

PostgreSQL 콘솔에서:
```sql
-- 데이터베이스 생성
CREATE DATABASE cuty_db;

-- 사용자 생성 (필요시)
CREATE USER cuty_user WITH PASSWORD 'your_password';

-- 권한 부여
GRANT ALL PRIVILEGES ON DATABASE cuty_db TO cuty_user;

-- 종료
\q
```

#### 5. 환경 변수 설정

프로젝트 루트 디렉토리에 환경별 설정 파일을 생성합니다.

**로컬 개발 환경 (`.env.local`):**
```env
# 환경 설정
ENV=local
DEBUG=True
PORT=5000
SECRET_KEY=dev-secret-key-change-in-production

# 데이터베이스 설정
DB_USERNAME=cuty_user
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=cuty_db

# AWS S3 설정 (로컬 개발시 선택사항)
AWS_S3_REGION=ap-northeast-2
AWS_S3_ACCESS_KEY_ID=your_access_key_id
AWS_S3_SECRET_ACCESS_KEY=your_secret_access_key
AWS_S3_BUCKET=cuty-local-bucket
CLOUDFRONT_URL=https://your-cloudfront-domain.cloudfront.net
```

**프로덕션 환경 (`.env.prod`):**
```env
# 환경 설정
ENV=prod
DEBUG=False
PORT=5000
SECRET_KEY=production-secret-key-must-be-strong

# 데이터베이스 설정 (RDS 또는 프로덕션 DB)
DB_USERNAME=cuty_prod_user
DB_PASSWORD=strong_production_password
DB_HOST=your-rds-endpoint.ap-northeast-2.rds.amazonaws.com
DB_PORT=5432
DB_NAME=cuty_prod_db

# AWS S3 설정
AWS_S3_REGION=ap-northeast-2
AWS_S3_ACCESS_KEY_ID=prod_access_key
AWS_S3_SECRET_ACCESS_KEY=prod_secret_key
AWS_S3_BUCKET=cuty-prod
CLOUDFRONT_URL=https://your-cloudfront-domain.cloudfront.net
```

**보안 주의사항:**
- `.env.*` 파일은 `.gitignore`에 포함되어 있어 Git에 커밋되지 않습니다
- `SECRET_KEY`는 강력한 랜덤 문자열로 설정해야 합니다
- 프로덕션 환경에서는 절대 DEBUG=True를 사용하지 마세요

**SECRET_KEY 생성 방법:**
```python
# Python으로 안전한 SECRET_KEY 생성
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

#### 6. 데이터베이스 마이그레이션

데이터베이스 스키마를 초기화합니다:

```bash
# 로컬 환경 (ENV=local이 기본값)
flask db upgrade

# 프로덕션 환경
ENV=prod flask db upgrade
```

마이그레이션이 성공하면 데이터베이스에 모든 테이블이 생성됩니다.

**마이그레이션 확인:**
```bash
# PostgreSQL에서 테이블 확인
psql -U cuty_user -d cuty_db -c "\dt"
```

#### 7. AWS 설정 (배포용)

**AWS 자격 증명 설정:**
```bash
aws configure --profile cuty
```

입력 항목:
- AWS Access Key ID: `your_access_key`
- AWS Secret Access Key: `your_secret_key`
- Default region name: `ap-northeast-2`
- Default output format: `json`

**S3 버킷 생성 (필요시):**
```bash
# Zappa 배포용 S3 버킷 생성
aws s3 mb s3://cuty-prod --region ap-northeast-2 --profile cuty

# 파일 저장용 S3 버킷 생성
aws s3 mb s3://cuty-files --region ap-northeast-2 --profile cuty
```

#### 8. 로컬 서버 실행

모든 설정이 완료되면 로컬 서버를 실행합니다:

```bash
# 가상환경 활성화 확인
source .venv/bin/activate

# 환경 변수를 local로 설정 (기본값)
python app.py

# 또는 Flask CLI 사용
flask run
```

서버가 성공적으로 시작되면:
```
Running on port 5000
 * Serving Flask app 'app'
 * Debug mode: on
 * Running on http://0.0.0.0:5000
```

**서버 테스트:**
```bash
# 다른 터미널에서
curl http://localhost:5000/api/v1/auth/health
```

### 초기 설정 체크리스트

설정이 제대로 되었는지 확인하세요:

- [ ] Python 3.12 설치 확인 (`python --version`)
- [ ] PostgreSQL 설치 및 실행 확인
- [ ] 데이터베이스 생성 완료
- [ ] 가상환경 생성 및 활성화
- [ ] requirements.txt 의존성 설치 완료
- [ ] `.env.local` 파일 생성 및 환경 변수 설정
- [ ] 데이터베이스 마이그레이션 완료
- [ ] 로컬 서버 정상 실행 확인
- [ ] AWS CLI 설치 (배포시)
- [ ] AWS 자격 증명 설정 (배포시)

## 배포

### AWS Lambda (Zappa)를 통한 배포

이 프로젝트는 Zappa를 사용하여 AWS Lambda와 API Gateway에 서버리스로 배포됩니다.

**Zappa란?**
- Python WSGI 애플리케이션을 AWS Lambda + API Gateway에 자동 배포하는 도구
- 서버리스 아키텍처로 비용 절감 및 자동 스케일링
- Python 3.12 런타임 사용 (AWS Lambda 지원)

### 배포 전 준비사항

#### 1. AWS 계정 및 IAM 사용자 생성

AWS 콘솔에서 IAM 사용자를 생성하고 다음 권한을 부여합니다:

**필요한 IAM 권한:**
- AWSLambdaFullAccess
- IAMFullAccess
- AmazonAPIGatewayAdministrator
- AmazonS3FullAccess
- CloudWatchLogsFullAccess
- AmazonVPCFullAccess (VPC 사용시)

또는 다음 정책을 포함하는 커스텀 정책:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lambda:*",
        "apigateway:*",
        "s3:*",
        "iam:*",
        "logs:*",
        "cloudformation:*",
        "events:*"
      ],
      "Resource": "*"
    }
  ]
}
```

#### 2. AWS 자격 증명 설정

AWS CLI를 사용하여 프로필을 설정합니다:

```bash
aws configure --profile cuty
```

다음 정보를 입력합니다:
- AWS Access Key ID: (IAM 사용자의 Access Key)
- AWS Secret Access Key: (IAM 사용자의 Secret Key)
- Default region name: `ap-northeast-2`
- Default output format: `json`

**설정 확인:**
```bash
aws sts get-caller-identity --profile cuty
```

#### 3. Zappa 설정 파일 이해

`zappa_settings.json` 파일에 배포 설정이 정의되어 있습니다:

```json
{
  "prod": {
    "aws_region": "ap-northeast-2",
    "profile_name": "cuty",
    "project_name": "cuty-server",
    "runtime": "python3.12",
    "s3_bucket": "cuty-prod",
    "app_function": "app.app",
    "environment_variables": {
      "ENV": "prod",
      "DEBUG": "False"
    },
    "keep_warm": true,
    "slim_handler": true
  }
}
```

**주요 설정 항목 설명:**
- `aws_region`: AWS 리전 (ap-northeast-2 = 서울)
- `profile_name`: AWS CLI 프로필 이름
- `project_name`: Lambda 함수 이름
- `runtime`: Python 버전 (**반드시 python3.12**)
- `s3_bucket`: Zappa 배포 파일을 저장할 S3 버킷
- `app_function`: Flask 애플리케이션 객체 경로 (app.py의 app)
- `environment_variables`: Lambda 환경 변수
- `keep_warm`: 콜드 스타트 방지 (주기적으로 Lambda 호출)
- `slim_handler`: 배포 패키지 크기 최적화

#### 4. 배포용 S3 버킷 생성

Zappa는 배포 파일을 S3에 업로드하므로 버킷이 필요합니다:

```bash
# S3 버킷 생성
aws s3 mb s3://cuty-prod --region ap-northeast-2 --profile cuty

# 버킷 확인
aws s3 ls --profile cuty
```

### 첫 배포 (Initial Deploy)

#### 1. 가상환경 활성화 및 Python 버전 확인

```bash
# 가상환경 활성화
source .venv/bin/activate

# Python 3.12인지 확인 (매우 중요!)
python --version
# 출력: Python 3.12.x
```

#### 2. 프로덕션 환경 변수 설정

`.env.prod` 파일이 올바르게 설정되어 있는지 확인합니다.

**중요**: 민감한 정보(DB 비밀번호, SECRET_KEY 등)는 Lambda 환경 변수로 직접 설정하는 것이 더 안전합니다.

`zappa_settings.json`에 환경 변수를 추가할 수 있습니다:
```json
{
  "prod": {
    ...
    "environment_variables": {
      "ENV": "prod",
      "DEBUG": "False",
      "DB_HOST": "your-rds-endpoint.rds.amazonaws.com",
      "DB_NAME": "cuty_prod_db",
      "DB_USERNAME": "cuty_user",
      "DB_PASSWORD": "your_secure_password",
      "SECRET_KEY": "your-secret-key",
      "AWS_S3_BUCKET": "cuty-files",
      "CLOUDFRONT_URL": "https://xxxxx.cloudfront.net"
    }
  }
}
```

#### 3. 첫 배포 실행

```bash
# 프로덕션 환경으로 첫 배포
zappa deploy prod
```

배포 과정:
1. 프로젝트 패키징 (dependencies + source code)
2. S3에 배포 패키지 업로드
3. Lambda 함수 생성
4. API Gateway 설정
5. IAM Role 생성
6. CloudWatch Logs 설정

성공 시 출력 예시:
```
Deploying API Gateway...
Deployment complete!
https://xxxxxxxx.execute-api.ap-northeast-2.amazonaws.com/prod
```

#### 4. 배포 확인

```bash
# 배포 상태 확인
zappa status prod

# API 테스트
curl https://xxxxxxxx.execute-api.ap-northeast-2.amazonaws.com/prod/api/v1/auth/health
```

### 업데이트 배포 (Update)

코드 변경 후 재배포:

```bash
# 코드 변경 사항 배포
zappa update prod
```

업데이트는 deploy보다 빠르게 실행됩니다 (Lambda 함수 코드만 업데이트).

### Zappa 주요 명령어

```bash
# 배포 상태 확인
zappa status prod

# 실시간 로그 확인 (tail)
zappa tail prod

# 최근 로그 확인
zappa tail prod --since 1h  # 최근 1시간
zappa tail prod --since 30m # 최근 30분

# 특정 함수 호출 (테스트)
zappa invoke prod 'app.lambda_handler' --raw

# 환경 변수 목록 확인
aws lambda get-function-configuration \
  --function-name cuty-server-prod \
  --profile cuty \
  --query 'Environment'

# Lambda 함수 정보 확인
aws lambda get-function \
  --function-name cuty-server-prod \
  --profile cuty

# 배포 롤백 (이전 버전으로)
zappa rollback prod -n 1  # 1단계 이전으로

# 배포 완전 제거 (주의!)
zappa undeploy prod
```

### 데이터베이스 마이그레이션 (프로덕션)

배포 후 프로덕션 데이터베이스 마이그레이션:

```bash
# 방법 1: Zappa manage 명령 사용
zappa manage prod "flask db upgrade"

# 방법 2: 로컬에서 프로덕션 DB에 직접 연결
ENV=prod flask db upgrade
```

**주의사항:**
- 프로덕션 DB는 보안그룹에서 접근 허용 필요
- RDS 사용 시 퍼블릭 액세스 또는 VPN 설정 필요

### 환경 변수 업데이트

환경 변수 변경 후:

```bash
# zappa_settings.json 수정 후
zappa update prod

# 또는 AWS CLI로 직접 업데이트
aws lambda update-function-configuration \
  --function-name cuty-server-prod \
  --environment "Variables={ENV=prod,DEBUG=False,SECRET_KEY=new-key}" \
  --profile cuty
```

### 배포 후 확인사항

#### 1. API Gateway URL 확인

```bash
zappa status prod
# 또는
aws apigateway get-rest-apis --profile cuty
```

#### 2. CloudWatch 로그 확인

```bash
# 실시간 로그
zappa tail prod

# AWS 콘솔에서 확인
# https://console.aws.amazon.com/cloudwatch/
```

#### 3. 데이터베이스 연결 테스트

```bash
# API 호출 테스트
curl https://your-api-gateway-url.amazonaws.com/prod/api/v1/auth/health
```

#### 4. S3 업로드 권한 확인

Lambda 실행 역할(IAM Role)에 S3 권한이 있는지 확인:

```bash
# Lambda 역할 확인
aws lambda get-function-configuration \
  --function-name cuty-server-prod \
  --profile cuty \
  --query 'Role'
```

필요시 S3 권한 추가:
- AWS Console > IAM > Roles > cuty-server-prod-ZappaLambdaExecutionRole
- AmazonS3FullAccess 정책 추가

#### 5. CORS 설정 확인

API Gateway에서 CORS 설정:

```bash
# Flask-CORS가 설정되어 있으면 자동으로 처리됨
# 필요시 API Gateway 콘솔에서 CORS 활성화
```

### 커스텀 도메인 설정 (선택사항)

API Gateway의 기본 URL 대신 커스텀 도메인 사용:

#### 1. Route 53에 도메인 등록

#### 2. ACM 인증서 생성
```bash
# us-east-1 리전에서 인증서 요청 (API Gateway는 us-east-1 인증서 필요)
aws acm request-certificate \
  --domain-name api.yourdomain.com \
  --validation-method DNS \
  --region us-east-1 \
  --profile cuty
```

#### 3. Zappa 설정에 도메인 추가
```json
{
  "prod": {
    ...
    "domain": "api.yourdomain.com",
    "certificate_arn": "arn:aws:acm:us-east-1:xxxxx:certificate/xxxxx"
  }
}
```

#### 4. 도메인 인증
```bash
zappa certify prod
```

### 배포 트러블슈팅

#### Python 버전 오류
```
Error: Python 3.12 is required
```
해결: 가상환경을 Python 3.12로 재생성

#### S3 버킷 권한 오류
```
Error: Access Denied to S3 bucket
```
해결: IAM 사용자에 S3 권한 추가

#### Lambda 함수 크기 초과
```
Error: Unzipped size must be smaller than 262144000 bytes
```
해결: `zappa_settings.json`에 `slim_handler: true` 추가 (이미 설정됨)

#### VPC 연결 문제
RDS가 VPC 내부에 있는 경우:
```json
{
  "prod": {
    ...
    "vpc_config": {
      "SubnetIds": ["subnet-xxxxx", "subnet-yyyyy"],
      "SecurityGroupIds": ["sg-xxxxx"]
    }
  }
}
```

## 개발 가이드

### 새로운 API 엔드포인트 추가

1. `src/models/` 에 모델 정의
2. `src/services/` 에 비즈니스 로직 작성
3. `src/routes/v1/` 에 라우트 정의
4. `src/routes/__init__.py` 에 라우트 등록

### 데이터베이스 마이그레이션

**마이그레이션 파일 생성:**
```bash
flask db migrate -m "마이그레이션 설명"
```

**마이그레이션 적용:**
```bash
flask db upgrade
```

**마이그레이션 롤백:**
```bash
flask db downgrade
```

## 트러블슈팅

### 데이터베이스 연결 오류
- 환경 변수 설정 확인
- PostgreSQL 서버 실행 상태 확인
- 방화벽 설정 확인

### S3 업로드 오류
- AWS 자격 증명 확인
- S3 버킷 권한 확인
- CORS 설정 확인

### Zappa 배포 오류
- AWS 프로필 설정 확인
- S3 버킷 존재 여부 확인
- IAM 권한 확인

## Android 디버깅 설정

로컬에서 Android 앱과 연결하여 테스트할 경우:

```bash
adb reverse tcp:8000 tcp:8000
```

## 라이선스

이 프로젝트는 비공개 프로젝트입니다.

## 문의

프로젝트 관련 문의사항은 담당자에게 연락해주세요.


## 가상환경 
### 가상환경 준비

### 가상환경 활성화
```bash
# PowerShell 기준
.venv\Scripts\activate
```

- powershell 안될 때
```bash
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```