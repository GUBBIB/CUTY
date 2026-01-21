from flask import Blueprint, request, jsonify
from src.services.school_service import SchoolService
from flasgger import swag_from
from src.utils.swagger_helper import get_swagger_config

school_bp = Blueprint('school', __name__)

@school_bp.route('/', methods=['GET'])
@swag_from(get_swagger_config('docs/v1/school/list.yml'))
def get_schools():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '')
    
    try:
        result = SchoolService.get_schools(page, per_page, search)
        return jsonify(result), 200
    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@school_bp.route('/<int:school_id>/colleges', methods=['GET'])
@swag_from(get_swagger_config('docs/v1/school/colleges.yml'))
def get_colleges(school_id):
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '')
    
    try:
        result = SchoolService.get_colleges(school_id, page, per_page, search)
        return jsonify(result), 200
    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@school_bp.route('/<int:school_id>/colleges/<int:college_id>/departments', methods=['GET'])
@swag_from(get_swagger_config('docs/v1/school/departments.yml'))
def get_departments(school_id, college_id):
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '')
    
    try:
        result = SchoolService.get_departments(school_id, college_id, page, per_page, search)
        return jsonify(result), 200
    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500