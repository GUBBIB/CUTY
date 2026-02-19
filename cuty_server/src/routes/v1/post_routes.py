from flask import Blueprint, current_app, request, jsonify
from src.services.post_service import PostService
from src.utils.auth import token_required
import jwt
from src.services.user_service import UserService
from flasgger import swag_from
from src.utils.swagger_helper import get_swagger_config

post_bp = Blueprint('post', __name__)

@post_bp.route('', methods=['GET'])
@swag_from(get_swagger_config('docs/v1/post/list.yml'))
def get_posts():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    filters = {
        'category': request.args.get('category'),
        'search': request.args.get('search', ''),
        'school_id': request.args.get('school_id', type=int),
        'college_id': request.args.get('college_id', type=int),
        'department_id': request.args.get('department_id', type=int)
    }
    
    current_user_school_id = UserService.get_user_school_id(request.headers)
    current_user_id = UserService.get_user_id(request.headers)
    
    try:
        result = PostService.get_posts(page, per_page, current_user_school_id, current_user_id, **filters)
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@post_bp.route('/<int:post_id>', methods=['GET'])
@swag_from(get_swagger_config('docs/v1/post/detail.yml'))
def get_post(post_id):
    user_id = UserService.get_user_id(request.headers)
    ip_address = request.remote_addr
    
    try:
        result = PostService.get_post(post_id, user_id, ip_address)
        return jsonify(result), 200
    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@post_bp.route('', methods=['POST'])
@token_required
@swag_from(get_swagger_config('docs/v1/post/create.yml'))
def create_post(current_user):
    data = request.get_json()
    
    required_fields = ['title', 'content', 'category']
    for field in required_fields:
        if field not in data:
            return jsonify({'error': f'{field}는 필수 항목입니다'}), 400
    
    try:
        result = PostService.create_post(
            current_user,
            data['title'],
            data['content'],
            data['category']
        )
        return jsonify(result), 201
    except ValueError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@post_bp.route('/<int:post_id>', methods=['PUT'])
@token_required
@swag_from(get_swagger_config('docs/v1/post/update.yml'))
def update_post(current_user, post_id):
    data = request.get_json()
    
    try:
        result = PostService.update_post(post_id, current_user, data)
        return jsonify(result), 200
    except ValueError as e:
        return jsonify({'error': str(e)}), 404 if '존재하지 않는' in str(e) else 403
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@post_bp.route('/<int:post_id>', methods=['DELETE'])
@token_required
@swag_from(get_swagger_config('docs/v1/post/delete.yml'))
def delete_post(current_user, post_id):
    try:
        PostService.delete_post(post_id, current_user)
        return '', 204
    except ValueError as e:
        return jsonify({'error': str(e)}), 404 if '존재하지 않는' in str(e) else 403
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@post_bp.route('/popular', methods=['GET'])
@swag_from(get_swagger_config('docs/v1/post/popular.yml'))
def get_popular_posts():
    try:
        category = request.args.get('category')
        limit = request.args.get('limit', default=10, type=int)

        posts = PostService.get_popular_posts(category=category, limit=limit)

        return jsonify({
            'success': True,
            'data': posts
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': str(e)
        }), 500