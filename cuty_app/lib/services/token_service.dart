import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'auth_token';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<T> tokenRequired<T>(Future<T> Function(String token) request) async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('토큰이 없습니다.');
    }

    print("토큰 : " + token);

    try {
      return await request(token);
    } on http.ClientException catch (e) {
      if (e.message.contains('401')) {
        await removeToken();
        throw Exception('만료된 토큰입니다. 다시 로그인해 주세요.');
      } else if (e.message.contains('404')) {
        throw Exception('사용자를 찾을 수 없습니다.');
      } else {
        throw Exception('유효하지 않은 토큰입니다.');
      }
    }
  }
}
