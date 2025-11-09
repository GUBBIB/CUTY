from .base import db, TimestampMixin
from .enums import DocumentType

class Document(db.Model, TimestampMixin):
    """
    서류 모델 - 사용자가 업로드한 서류 정보를 저장
    """
    __tablename__ = 'documents'
    
    id = db.Column(db.Integer, primary_key=True, index=True)
    name = db.Column(db.String(255), nullable=True)  # 서류 이름
    document_type = db.Column(db.Enum(DocumentType), nullable=False)  # 서류 타입 (상수 값)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    image_store_id = db.Column(db.Integer, db.ForeignKey('image_store.id'), nullable=False)
    
    # 관계 설정
    user = db.relationship('User', backref='documents', lazy=True)
    image_store = db.relationship('ImageStore', backref='documents', lazy=True)
    
    def __repr__(self):
        return f'<Document {self.id} - {self.document_type.value} (User: {self.user_id})>'
