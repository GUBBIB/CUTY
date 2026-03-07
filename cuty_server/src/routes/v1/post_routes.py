from flask import Blueprint, current_app, request, jsonify
from src.services.post_service import PostService
from src.utils.auth import token_required
import jwt
from src.services.user_service import UserService
from flasgger import swag_from
from src.utils.swagger_helper import get_swagger_config

post_bp = Blueprint('post', __name__)

@post_bp.route('/<int:post_id>', methods=['GET'])
@swag_from(get_swagger_config('docs/v1/post/detail.yml'))
def get_post(board_id, post_id):
    user_id = UserService.get_user_id(request.headers)
    ip_address = request.remote_addr
    
    result = PostService.get_post(board_id, post_id, user_id, ip_address)

    return jsonify({
            "status": "success",
            "data": result
        }), 200

@post_bp.route('', methods=['POST'])
@token_required
@swag_from(get_swagger_config('docs/v1/post/create.yml'))
def create_post(board_id, current_user):
    data = request.get_json() or {}

    result = PostService.create_post(board_id, current_user, data)
    
    return jsonify({
        "status": "success",
        "data": result
    }), 201

@post_bp.route('/<int:post_id>', methods=['PUT'])
@token_required
@swag_from(get_swagger_config('docs/v1/post/update.yml'))
def update_post(board_id, current_user, post_id):
    data = request.get_json() or {}
    
    result = PostService.update_post(board_id, post_id, current_user, data)
    
    return jsonify({
        "status": "success",
        "data": result
    }), 200

@post_bp.route('/<int:post_id>', methods=['DELETE'])
@token_required
@swag_from(get_swagger_config('docs/v1/post/delete.yml'))
def delete_post(board_id, current_user, post_id):
    
    PostService.delete_post(board_id, post_id, current_user)
    
    return jsonify({
        "status": "success",
        "message": "게시글이 성공적으로 삭제되었습니다."
    }), 200

@post_bp.route('/popular', methods=['GET'])
@swag_from(get_swagger_config('docs/v1/post/popular.yml'))
def get_popular_posts():
    
    category = request.args.get('category')
    limit = request.args.get('limit', default=10, type=int)

    posts = PostService.get_popular_posts(category=category, limit=limit)
    
    return jsonify({
            "status": "success",
            "data": posts
        }), 200