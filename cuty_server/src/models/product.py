from .base import db, TimestampMixin

class Product(db.Model, TimestampMixin):
    __tablename__ = 'products'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)  # 상품명
    description = db.Column(db.Text)                   # 상품 설명
    price = db.Column(db.Integer, nullable=False)     # 가격 (포인트 단위)
    image_url = db.Column(db.String(255))             # 상품 이미지 URL

    def __repr__(self):
        return f'<Product {self.name}>'