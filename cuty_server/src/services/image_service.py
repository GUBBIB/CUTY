from datetime import datetime, timedelta
from typing import List, Tuple, Optional
import boto3
import uuid
import logging
from src.models.base import db

from src.config.env import (
    AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY,
    AWS_S3_BUCKET, CLOUDFRONT_URL, MAX_FILE_SIZE
)
from src.models.image_store import ImageStore
from src.utils.formatters import get_presigned_url_data
from src.services.s3_service import generate_presigned_post

# 환경 변수 검증
required_env_vars = {
    'AWS_REGION': AWS_REGION,
    'AWS_ACCESS_KEY_ID': AWS_ACCESS_KEY_ID,
    'AWS_SECRET_ACCESS_KEY': AWS_SECRET_ACCESS_KEY,
    'AWS_S3_BUCKET': AWS_S3_BUCKET,
    'CLOUDFRONT_URL': CLOUDFRONT_URL
}

for var_name, var_value in required_env_vars.items():
    if var_value is None:
        print(f"Missing required environment variable: {var_name}")

# 로거 설정
logger = logging.getLogger(__name__)

# S3 클라이언트 설정
s3_client = boto3.client(
    's3',
    region_name=AWS_REGION,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY
)

class ImageService:
    @staticmethod
    def get_presigned_url(content_type: str, original_filename: str, file_size: int) -> Tuple[Optional[dict], Optional[str]]:
        """프리사인드 URL 생성 서비스 및 이미지 데이터 저장"""
        
        logger.info(f"=== 이미지 Presigned URL 요청 시작 ===")
        logger.info(f"Content-Type: {content_type}")
        logger.info(f"Original Filename: {original_filename}")
        logger.info(f"File Size: {file_size} bytes")

        try:
            # 필수 환경 변수 검증
            missing_vars = [name for name, value in required_env_vars.items() if value is None]
            if missing_vars:
                error_msg = f"Missing required environment variables: {', '.join(missing_vars)}"
                logger.error(error_msg)
                print(error_msg)
                return None, error_msg

            # 파일 크기 검증
            if file_size > MAX_FILE_SIZE:
                error_msg = f"File size {file_size} exceeds maximum limit {MAX_FILE_SIZE}"
                logger.error(error_msg)
                return None, "File size exceeds maximum limit"

            # UUID + 원본 파일명으로 새 파일명 생성
            unique_id = str(uuid.uuid4())
            safe_filename = ''.join(c for c in original_filename if c.isalnum() or c in '._-')
            file_name = f"{unique_id}_{safe_filename}" if safe_filename else f"{unique_id}"
            
            key = f"images/{file_name}"
            bucket_name = AWS_S3_BUCKET
            
            logger.info(f"생성된 파일 키: {key}")
            logger.info(f"사용할 버킷: {bucket_name}")
            
            # S3 presigned URL 생성 시 조건 추가
            conditions = [
                {"Content-Type": content_type},
                ["content-length-range", 0, MAX_FILE_SIZE]
            ]
            
            presigned_post = generate_presigned_post(
                key=key,
                content_type=content_type,
                max_file_size=MAX_FILE_SIZE,
                expires_in=600,
                bucket_name=bucket_name
            )
            
            cloudfront_url = f"{CLOUDFRONT_URL}/{key}"
            
            # ImageStore에 이미지 정보 저장
            image = ImageStore(
                relative_path=key,
                base_url=CLOUDFRONT_URL,
                full_url=cloudfront_url,
                content_type=content_type,
                bucket_name=bucket_name,
                original_filename=original_filename,
                region=AWS_REGION
            )
            
            
            db.session.add(image)
            db.session.commit()
            
            # formatters를 사용하여 통일된 응답 형식 생성
            formatted_response = get_presigned_url_data(image, presigned_post)
            return formatted_response, None
            
        except Exception as e:
            print(f"Error in get_presigned_url service: {str(e)}")
            return None, "Failed to generate presigned URL"

