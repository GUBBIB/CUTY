from src.models import db, Country, School, College, Department
from sqlalchemy import or_
from src.utils.formatters import (
    get_country_data, get_school_data, 
    get_college_data, get_department_data
)

class SchoolService:
    @staticmethod
    def get_schools(page, per_page, search=''):

        schools_query = School.query

        if search:
            schools_query = schools_query.filter(School.name.ilike(f'%{search}%'))
        
        schools_query = schools_query.order_by(School.name.asc())
        pagination = schools_query.paginate(page=page, per_page=per_page, error_out=False)
        
        schools = [get_school_data(school) for school in pagination.items]
        
        return {
            'schools': schools,
            'total': pagination.total,
            'pages': pagination.pages,
            'current_page': page,
            'per_page': per_page,
            'search': search
        }

    @staticmethod
    def get_colleges(school_id, page, per_page, search=''):
        # 학교 존재 여부 확인
        school = School.query.get(school_id)
        if not school:
            raise ValueError('존재하지 않는 학교입니다')

        # 단과대학 쿼리 생성
        colleges_query = College.query.filter_by(school_id=school_id)
        
        if search:
            colleges_query = colleges_query.filter(College.name.ilike(f'%{search}%'))
        
        colleges_query = colleges_query.order_by(College.name.asc())
        pagination = colleges_query.paginate(page=page, per_page=per_page, error_out=False)
        
        colleges = [get_college_data(college) for college in pagination.items]
        
        return {
            'colleges': colleges,
            'total': pagination.total,
            'pages': pagination.pages,
            'current_page': page,
            'per_page': per_page,
            'search': search
        }

    @staticmethod
    def get_departments(school_id, college_id, page, per_page, search=''):
        # 학교 존재 여부 확인
        school = School.query.get(school_id)
        if not school:
            raise ValueError('존재하지 않는 학교입니다')
            
        # 단과대학 존재 여부와 학교 관계 확인
        college = College.query.get(college_id)
        if not college:
            raise ValueError('존재하지 않는 단과대학입니다')
        if college.school_id != school_id:
            raise ValueError('해당 학교의 단과대학이 아닙니다')
        
        # 학과 쿼리 생성
        departments_query = Department.query.filter_by(college_id=college_id)
        
        if search:
            departments_query = departments_query.filter(Department.name.ilike(f'%{search}%'))
        
        departments_query = departments_query.order_by(Department.name.asc())
        pagination = departments_query.paginate(page=page, per_page=per_page, error_out=False)
        
        departments = [get_department_data(department) for department in pagination.items]
        
        return {
            'departments': departments,
            'total': pagination.total,
            'pages': pagination.pages,
            'current_page': page,
            'per_page': per_page,
            'search': search
        }
