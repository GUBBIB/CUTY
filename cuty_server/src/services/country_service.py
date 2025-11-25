from src.models import db, Country, School, College, Department
from sqlalchemy import or_
from src.utils.formatters import (
    get_country_data, get_school_data, 
    get_college_data, get_department_data
)

class CountryService:
    @staticmethod
    def get_countries(page, per_page, search=''):
        # 국가 쿼리 생성
        countries_query = Country.query
        
        # 검색어가 있는 경우 필터 적용
        if search:
            countries_query = countries_query.filter(
                or_(
                    Country.name.ilike(f'%{search}%'),
                    Country.code.ilike(f'%{search}%')
                )
            )
        
        # 정렬 적용
        countries_query = countries_query.order_by(Country.name.asc())
        
        # 페이지네이션 적용
        pagination = countries_query.paginate(page=page, per_page=per_page, error_out=False)
        
        # 결과 포맷팅
        countries = [get_country_data(country) for country in pagination.items]
        
        return {
            'countries': countries,
            'total': pagination.total,
            'pages': pagination.pages,
            'current_page': page,
            'per_page': per_page,
            'search': search
        }
