from flask import Blueprint, request, jsonify
from flasgger import swag_from
from src.utils.swagger_helper import get_swagger_config
from src.utils.exception import ServiceError
from src.services.store_service import StoreService
from src.utils.auth import token_required

store_bp = Blueprint('store', __name__)

@store_bp.route('/products', methods=['GET'])
@swag_from(get_swagger_config('docs/v1/store/products.yml'))
def get_products():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '')
    
    try:
        result = StoreService.get_products(page, per_page, search)
        return jsonify(result), 200
    except ServiceError as e:
        # 에러 코드에 따라 HTTP 상태 코드를 분기 처리
        status_code = 400
        if e.code == "FORBIDDEN":
            status_code = 403
        elif e.code == "INTERNAL":
            status_code = 500
            
        return jsonify(e.to_dict()), status_code
        
    # 예측하지 못한 에러 처리
    except Exception as e:
        return jsonify({
            "code": "UNKNOWN_ERROR",
            "message": "알 수 없는 시스템 오류가 발생했습니다."
        }), 500

@store_bp.route('/products', methods=['POST'])
@swag_from(get_swagger_config('docs/v1/store/create_product.yml'))
def create_product():

    try:
        StoreService.create_product(
            name=request.json.get('name'),
            description=request.json.get('description'),
            price=request.json.get('price'),
            image_url=request.json.get('image_url')
        )
        return jsonify({"message": "상품이 성공적으로 생성되었습니다."}), 201

    except ServiceError as e:
        # 에러 코드에 따라 HTTP 상태 코드를 분기 처리
        status_code = 400
        if e.code == "FORBIDDEN":
            status_code = 403
        elif e.code == "INTERNAL":
            status_code = 500
            
        return jsonify(e.to_dict()), status_code
        
    # 예측하지 못한 에러 처리
    except Exception as e:
        return jsonify({
            "code": "UNKNOWN_ERROR",
            "message": "알 수 없는 시스템 오류가 발생했습니다."
        }), 500

@store_bp.route('/products/<int:product_id>', methods=['GET'])
@swag_from(get_swagger_config('docs/v1/store/product_detail.yml'))
def get_product_detail(product_id):
    try:
        result = StoreService.get_product_detail(product_id)
        return jsonify(result), 200

    except ServiceError as e:
        # 에러 코드에 따라 HTTP 상태 코드를 분기 처리
        status_code = 400
        if e.code == "FORBIDDEN":
            status_code = 403
        elif e.code == "INTERNAL":
            status_code = 500
            
        return jsonify(e.to_dict()), status_code
        
    # 예측하지 못한 에러 처리
    except Exception as e:
        return jsonify({
            "code": "UNKNOWN_ERROR",
            "message": "알 수 없는 시스템 오류가 발생했습니다."
        }), 500

@store_bp.route('/products/<int:product_id>', methods=['POST'])
@swag_from(get_swagger_config('docs/v1/store/buy_product.yml'))
@token_required
def buy_product(current_user, product_id):
    try:
        StoreService.buy_product(current_user, product_id)
        return jsonify({"message": "상품이 성공적으로 구매되었습니다."}), 200

    except ServiceError as e:
        # 에러 코드에 따라 HTTP 상태 코드를 분기 처리
        status_code = 400
        if e.code == "FORBIDDEN":
            status_code = 403
        elif e.code == "INTERNAL":
            status_code = 500
            
        return jsonify(e.to_dict()), status_code
        
    # 예측하지 못한 에러 처리
    except Exception as e:
        return jsonify({
            "code": "UNKNOWN_ERROR",
            "message": "알 수 없는 시스템 오류가 발생했습니다."
        }), 500