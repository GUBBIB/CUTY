import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cuty_app/config/app_config.dart';
import 'package:cuty_app/models/user.dart';
import 'package:cuty_app/services/token_service.dart';

class UserService {
  final String baseUrl = AppConfig.baseApiUrl;
  final TokenService _tokenService = TokenService();

  Future<User> getCurrentUser() async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/users/me'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return User.fromJson(data);
        } else {
          final error = json.decode(response.body);
          print('사용자 정보를 불러오는데 실패했습니다');
          throw Exception(error['error'] ?? '사용자 정보를 불러오는데 실패했습니다');
        }
      } catch (e) {
        print('서버 연결에 실패했습니다. api');
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.put(
          Uri.parse('$baseUrl/users/me/password'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'current_password': currentPassword,
            'new_password': newPassword,
          }),
        );

        if (response.statusCode != 204) {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '비밀번호 변경에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  Future<void> deleteAccount() async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.delete(
          Uri.parse('$baseUrl/users/me'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode != 204) {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '회원 탈퇴에 실패했습니다');
        }

        await _tokenService.removeToken();
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }
}
