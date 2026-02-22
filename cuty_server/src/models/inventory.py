from .base import db, TimestampMixin
from datetime import datetime

class Inventory(db.Model, TimestampMixin):
    __tablename__ = 'inventories'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('products.id'), nullable=False)
    purchased_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False) # 구매일

    is_used = db.Column(db.Boolean, default=False, nullable=False) # 사용 여부
    used_at = db.Column(db.DateTime, nullable=True) # 사용일

    # Relationships
    user = db.relationship('User', backref=db.backref('inventory_items', lazy=True))
    product = db.relationship('Product')

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'product_id': self.product_id,
            'purchased_at': self.purchased_at.isoformat() if self.purchased_at else None,
            'is_used': self.is_used,
            'used_at': self.used_at.isoformat() if self.used_at else None,
            'product_name': self.product.name if self.product else None
        }