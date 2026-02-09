import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../models/post_model.dart';

class ApiService {
  // Singleton Pattern
  static final ApiService instance = ApiService._internal();
  ApiService._internal();

  // Configuration
  static const String baseUrl = ""; // To be filled

  final _storage = const FlutterSecureStorage();

  // 1. Login
  Future<bool> login(String email, String password) async {
    // Prevent parsing error if baseUrl is empty
    if (baseUrl.isEmpty) {
      debugPrint("[API] Base URL is empty. Login simulation.");
      return false; 
    }

    final url = Uri.parse('$baseUrl/api/v1/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['access_token'];
        if (accessToken != null) {
          await _storage.write(key: 'access_token', value: accessToken);
          return true;
        }
      } else {
        debugPrint('Login Failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Login Error: $e');
    }
    return false;
  }

  // 2. Fetch My Info
  Future<User?> fetchMyInfo() async {
    if (baseUrl.isEmpty) return null;
    
    final url = Uri.parse('$baseUrl/api/v1/users/me');
    try {
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) return null;

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Directly expects User JSON
        return User.fromJson(data);
      } else {
        debugPrint('Fetch Info Failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Fetch Info Error: $e');
    }
    return null;
  }

  // 3. Fetch Popular Posts (Community)
  Future<List<PostModel>> fetchPopularPosts() async {
    // Mock Data for now as endpoint is illustrative
    // In production:
    // final url = Uri.parse('$baseUrl/api/v1/posts/popular');
    // final response = await http.get(url, ...);
    
    // Return dummy data immediately
    return [
      PostModel(id: 1, title: '한국 알바 꿀팁 공유합니다', content: '시급 높은 곳 찾는 법...', likeCount: 15, viewCount: 120),
      PostModel(id: 2, title: '편의점 야간 알바 후기', content: '생각보다 할만해요.', likeCount: 8, viewCount: 85),
      PostModel(id: 3, title: '비자 변경 질문드려요', content: 'D-2에서 F-2-7 갈 때...', likeCount: 24, viewCount: 200),
    ];
  }
}
