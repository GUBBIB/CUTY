from .base import db, TimestampMixin

class ImageStore(db.Model, TimestampMixin):
    """
    이미지 저장소 - S3에 업로드된 이미지 정보를 저장
    """
    __tablename__ = 'image_store'
    
    id = db.Column(db.Integer, primary_key=True, index=True)
    relative_path = db.Column(db.String(512), nullable=False)  # S3 key
    base_url = db.Column(db.String(512), nullable=False)  # CloudFront URL
    full_url = db.Column(db.String(1024), nullable=False)  # CloudFront URL + key
    content_type = db.Column(db.String(127), nullable=False)
    bucket_name = db.Column(db.String(255), nullable=False)
    original_filename = db.Column(db.String(255), nullable=False)
    region = db.Column(db.String(50), nullable=True)  # AWS 리전 정보
    description = db.Column(db.String(255), nullable=True)  # 이미지 설명(선택)
    
    def __repr__(self):
        return f'<{self.__class__.__name__} {self.id} - {self.original_filename}>' 