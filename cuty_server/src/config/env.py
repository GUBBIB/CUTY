import os
from dotenv import load_dotenv

ENV = os.getenv('ENV', 'local')
# 환경 변수 파일 경로 설정
FLASK_ENV = ENV
env_path = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), f'.env.{FLASK_ENV}')

# 환경 변수 파일이 존재하는지 확인하고 로드
if os.path.exists(env_path):
    load_dotenv(env_path, override=True)
    print(f"환경 변수 파일 로드: {env_path}")
else:
    print(f"Warning: {env_path} 파일을 찾을 수 없습니다.")

# 환경 변수 로드 후 설정
DB_USERNAME = os.getenv('DB_USERNAME')
DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '5432')
DB_NAME = os.getenv('DB_NAME')
SECRET_KEY = os.getenv('SECRET_KEY', 'your-secret-key')
DEBUG = os.getenv('DEBUG', 'False').lower() == 'true'
PORT = int(os.getenv('PORT', 5000))

AWS_REGION = os.getenv('AWS_S3_REGION', 'ap-northeast-2')
AWS_ACCESS_KEY_ID = os.getenv('AWS_S3_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.getenv('AWS_S3_SECRET_ACCESS_KEY')
AWS_S3_BUCKET = os.getenv('AWS_S3_BUCKET')
CLOUDFRONT_URL = os.getenv('CLOUDFRONT_URL')
MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB
ALLOWED_EXTENSIONS = { 'pdf'}

# 디버깅을 위한 출력
print(f"현재 환경: {FLASK_ENV}")
print("DB_USERNAME", DB_USERNAME)
print("DB_PASSWORD", DB_PASSWORD)
print("DB_HOST", DB_HOST)
print("DB_PORT", DB_PORT)
print("DB_NAME", DB_NAME)
print("SECRET_KEY", SECRET_KEY)
print("DEBUG", DEBUG)
print("PORT", PORT)
print("AWS_REGION", AWS_REGION)
print("AWS_ACCESS_KEY_ID", AWS_ACCESS_KEY_ID)
print("AWS_SECRET_ACCESS_KEY", AWS_SECRET_ACCESS_KEY)
print("AWS_S3_BUCKET", AWS_S3_BUCKET)
print("CLOUDFRONT_URL", CLOUDFRONT_URL)

# 파일 경로와 내용 재확인
print(f"환경 변수 파일 경로: {os.path.abspath(env_path)}")
if os.path.exists(env_path):
    with open(env_path, 'r') as f:
        print(f"환경 변수 파일 내용:\n{f.read()}")