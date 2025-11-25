from flask import Blueprint, request, jsonify
from src.services.country_service import CountryService

country_bp = Blueprint('country', __name__)

@country_bp.route('/', methods=['GET'])
def get_countries():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '')
    
    try:
        result = CountryService.get_countries(page, per_page, search)
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500