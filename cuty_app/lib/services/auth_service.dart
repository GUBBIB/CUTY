import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cuty_app/config/app_config.dart';
import 'package:cuty_app/services/token_service.dart';

class AuthService {
  final TokenService _tokenService = TokenService();
  final String _baseUrl = AppConfig.baseApiUrl;

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required int countryId,
    required int schoolId,
    required int collegeId,
    required int departmentId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'country_id': countryId,
          'school_id': schoolId,
          'college_id': collegeId,
          'department_id': departmentId,
        }),
      );

      final data = jsonDecode(response.body);

      switch (response.statusCode) {
        case 201:
          await _tokenService.setToken(data['access_token']);
        case 400:
          throw Exception(data['error'] ?? '입력 정보가 올바르지 않습니다.');
        case 500:
          throw Exception('서버 오류가 발생했습니다.');
        default:
          throw Exception('알 수 없는 오류가 발생했습니다: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _tokenService.setToken(data['access_token']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? '로그인에 실패했습니다.');
      }
    } catch (e) {
      throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _tokenService.removeToken();
    } catch (e) {
      throw Exception('로그아웃 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await _tokenService.getToken();
      return token != null;
    } catch (e) {
      throw Exception('로그인 상태 확인 중 오류가 발생했습니다: ${e.toString()}');
    }
  }
}
