from sqlalchemy.exc import SQLAlchemyError
from src.models import db, products
from src.utils.exception import ValidationError, InternalServiceError 

class StoreService:
    @staticmethod
    def get_products(limit=10, cursor=None, search=''):
        if limit < 1 or limit > 100: 
            raise ValidationError(
                message="요청 가능한 데이터 개수는 1개 이상 100개 이하입니다.", 
                details={"provided_limit": limit}
            )
            
        try:
            products_query = products.query
            
            if search:
                products_query = products_query.filter(products.name.ilike(f'%{search}%'))
            
            if cursor:
                products_query = products_query.filter(products.id < cursor)
            
            queried_products = products_query.order_by(products.id.desc()).limit(limit).all()
            
            products_list = [{
                'id': product.id,
                'name': product.name,
                'description': product.description,
                'price': product.price,
                'image_url': product.image_url
            } for product in queried_products]
            
            next_cursor = queried_products[-1].id if queried_products else None
            has_next = len(queried_products) == limit
            
            return {
                'products': products_list,
                'next_cursor': next_cursor,
                'has_next': has_next,
                'search': search,
                'limit': limit
            }
            
        except SQLAlchemyError as e:
            raise InternalServiceError(
                message="상품 데이터를 불러오는 중 데이터베이스 오류가 발생했습니다.",
                details={"db_error": str(e)}
            )
        except Exception as e:
            raise InternalServiceError(
                message="상품 데이터를 처리하는 중 알 수 없는 오류가 발생했습니다.",
                details={"unknown_error": str(e)}
            )

    @staticmethod
    def create_product(name, description, price, image_url):

        if not name or not description or price is None or not image_url:
            raise ValidationError(
                message="모든 필드(name, description, price, image_url)는 필수입니다.",
                details={
                    "provided_name": name,
                    "provided_description": description,
                    "provided_price": price,
                    "provided_image_url": image_url
                }
            )

        try:
            new_product = products(
                name=name,
                description=description,
                price=price,
                image_url=image_url
            )

            db.session.add(new_product)
            db.session.commit()

            return {
                "id": new_product.id,  # 실제로는 데이터베이스에서 생성된 ID를 반환해야 합니다.
                "name": new_product.name,
                "description": new_product.description,
                "price": new_product.price,
                "image_url": new_product.image_url
            }
        except SQLAlchemyError as e:
            db.session.rollback()  # 트랜잭션 롤백
            raise InternalServiceError(
                message="상품을 생성하는 중 데이터베이스 오류가 발생했습니다.",
                details={"db_error": str(e)}
            )
        except Exception as e:
            raise InternalServiceError(
                message="상품을 생성하는 중 알 수 없는 오류가 발생했습니다.",
                details={"unknown_error": str(e)}
            )

    @staticmethod
    def get_product_detail(product_id):
        try:
            product = products.query.get(product_id)
            if not product:
                raise ValidationError(
                    message="해당 ID의 상품을 찾을 수 없습니다.",
                    details={"provided_product_id": product_id}
                )

            return {
                "id": product.id,
                "name": product.name,
                "description": product.description,
                "price": product.price,
                "image_url": product.image_url
            }
        except SQLAlchemyError as e:
            raise InternalServiceError(
                message="상품 상세 정보를 불러오는 중 데이터베이스 오류가 발생했습니다.",
                details={"db_error": str(e)}
            )
        except Exception as e:
            raise InternalServiceError(
                message="상품 상세 정보를 처리하는 중 알 수 없는 오류가 발생했습니다.",
                details={"unknown_error": str(e)}
            )

    @staticmethod
    def buy_product(current_user, product_id):
        try:
            product = products.query.get(product_id)
            if not product:
                raise ValidationError(
                    message="해당 ID의 상품을 찾을 수 없습니다.",
                    details={"provided_product_id": product_id}
                )

            if product.price > current_user.point:
                raise ValidationError(
                    message="포인트가 부족하여 상품을 구매할 수 없습니다.",
                    details={
                        "product_price": product.price,
                        "user_points": current_user.point
                    }
                )

            current_user.point -= product.price
            new_log = PointLog(
                user_id=user.id,
                amount=product.price,
                description='상품 구매: ' + product.name
            )

            db.session.add(new_log)
            db.session.commit()

            return {
                "message": "상품이 성공적으로 구매되었습니다."
            }
        except SQLAlchemyError as e:
            raise InternalServiceError(
                message="상품 구매 중 데이터베이스 오류가 발생했습니다.",
                details={"db_error": str(e)}
            )
        except Exception as e:
            raise InternalServiceError(
                message="상품 구매 중 알 수 없는 오류가 발생했습니다.",
                details={"unknown_error": str(e)}
            )