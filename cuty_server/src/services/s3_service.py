import boto3
# import logging
from src.config.env import (
    AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY,
    AWS_S3_BUCKET, MAX_FILE_SIZE
)

# 로거 설정
# logger = logging.getLogger(__name__)

# S3 클라이언트 반환 함수
def get_s3_client():
    return boto3.client(
        's3',
        region_name=AWS_REGION,
        aws_access_key_id=AWS_ACCESS_KEY_ID,
        aws_secret_access_key=AWS_SECRET_ACCESS_KEY
    )

# presigned post 발급 함수
def generate_presigned_post(key, content_type, max_file_size=MAX_FILE_SIZE, expires_in=600, bucket_name=AWS_S3_BUCKET):
    print(f"=== S3 Presigned Post 생성 시작 ===")
    print(f"Key: {key}")
    print(f"Content-Type: {content_type}")
    print(f"Bucket: {bucket_name}")
    print(f"Region: {AWS_REGION}")
    
    s3_client = get_s3_client()
    conditions = [
        {"Content-Type": content_type},
        ["content-length-range", 0, max_file_size]
    ]
    
    print(f"S3 클라이언트로 presigned post 생성 중...")
    presigned_post = s3_client.generate_presigned_post(
        Bucket=bucket_name,
        Key=key,
        Fields={
            'Content-Type': content_type,
        },
        Conditions=conditions,
        ExpiresIn=expires_in
    )
    
    print(f"원본 presigned post URL: {presigned_post.get('url', 'URL 없음')}")
    
    # 지역별 엔드포인트로 URL 수정
    if 'url' in presigned_post:
        # 기존 URL: https://bucket-name.s3.amazonaws.com/
        # 새 URL: https://bucket-name.s3.region.amazonaws.com/
        original_url = presigned_post['url']
        if '.s3.amazonaws.com' in original_url and AWS_REGION != 'us-east-1':
            new_url = original_url.replace(
                '.s3.amazonaws.com',
                f'.s3.{AWS_REGION}.amazonaws.com'
            )
            presigned_post['url'] = new_url
            print(f"URL을 지역별 엔드포인트로 변경: {original_url} -> {new_url}")
        else:
            print(f"URL 변경 불필요 (이미 지역별 엔드포인트이거나 us-east-1)")
    
    print(f"최종 presigned post URL: {presigned_post.get('url', 'URL 없음')}")
    print(f"=== S3 Presigned Post 생성 완료 ===")
    
    return presigned_post 

def generate_presigned_get(key, expires_in=600, bucket_name=AWS_S3_BUCKET):
    print(f"=== S3 Presigned GET 생성 시작 ===")
    print(f"Key: {key}")
    print(f"Bucket: {bucket_name}")
    print(f"Region: {AWS_REGION}")
    
    s3_client = get_s3_client()
    try:
        presigned_url = s3_client.generate_presigned_url(
            ClientMethod="get_object",
            Params={
                'Bucket': bucket_name,
                'Key': key
            },
            ExpiresIn=expires_in
        )
        print(f"Presigned GET URL 생성 성공: {presigned_url}")
        return presigned_url

    except Exception as e:
        print(f"Presigned GET URL 생성 실패: {str(e)}")
        return None