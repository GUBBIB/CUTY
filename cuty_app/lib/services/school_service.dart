import 'package:cuty_app/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/school.dart';
import '../models/college.dart';
import '../models/department.dart';

class SchoolService {
  final String baseUrl = AppConfig.baseApiUrl;

  Future<Map<String, dynamic>> getSchools(
    int countryId, {
    int page = 1,
    int perPage = 10,
    String search = '',
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/countries/$countryId/schools?page=$page&per_page=$perPage&search=$search'),
      );

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> data = json.decode(response.body);
        final List<School> schools = (data['schools'] as List)
            .map((json) => School.fromJson(json))
            .toList();

        return {
          'schools': schools,
          'total': data['total'],
          'pages': data['pages'],
          'currentPage': data['current_page'],
          'perPage': data['per_page'],
          'search': data['search'],
        };
      } else if (response.statusCode == 404) {
        throw Exception('존재하지 않는 국가입니다');
      } else {
        throw Exception('학교 목록을 불러오는데 실패했습니다');
      }
    } catch (e) {
      throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getColleges(
    int countryId,
    int schoolId, {
    int page = 1,
    int perPage = 10,
    String search = '',
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/countries/$countryId/schools/$schoolId/colleges?page=$page&per_page=$perPage&search=$search'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<College> colleges = (data['colleges'] as List)
            .map((json) => College.fromJson(json))
            .toList();

        return {
          'colleges': colleges,
          'total': data['total'],
          'pages': data['pages'],
          'currentPage': data['current_page'],
          'perPage': data['per_page'],
          'search': data['search'],
        };
      } else if (response.statusCode == 404) {
        throw Exception('존재하지 않는 국가 또는 학교입니다');
      } else if (response.statusCode == 400) {
        throw Exception('해당 국가의 학교가 아닙니다');
      } else {
        throw Exception('단과대학 목록을 불러오는데 실패했습니다');
      }
    } catch (e) {
      print(e);
      throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getDepartments(
    int countryId,
    int schoolId,
    int collegeId, {
    int page = 1,
    int perPage = 10,
    String search = '',
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/countries/$countryId/schools/$schoolId/colleges/$collegeId/departments?page=$page&per_page=$perPage&search=$search'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Department> departments = (data['departments'] as List)
            .map((json) => Department.fromJson(json))
            .toList();

        return {
          'departments': departments,
          'total': data['total'],
          'pages': data['pages'],
          'currentPage': data['current_page'],
          'perPage': data['per_page'],
          'search': data['search'],
        };
      } else if (response.statusCode == 404) {
        throw Exception('존재하지 않는 국가, 학교 또는 단과대학입니다');
      } else if (response.statusCode == 400) {
        throw Exception('해당 국가의 학교가 아니거나 해당 학교의 단과대학이 아닙니다');
      } else {
        throw Exception('학과 목록을 불러오는데 실패했습니다');
      }
    } catch (e) {
      throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
    }
  }
}
