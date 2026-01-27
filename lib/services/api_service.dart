import 'package:dio/dio.dart';
import '../models/auth_response.dart';
import '../models/post_model.dart';
import '../models/attendance_response.dart';

// [API Service]

class ApiService {
  final Dio _dio;

  // Base URL should be configured here or passed in
  static const String baseUrl = 'https://api.example.com'; 

  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 3),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            );

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // 1. Login
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  // 2. Fetch Popular Posts
  Future<List<PostModel>> fetchPopularPosts({int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/api/v1/posts/popular',
        queryParameters: {'limit': limit},
      );
      // Response structure: { "success": true, "data": { "items": [...] } }
      final data = response.data['data'];
      if (data != null && data['items'] != null) {
        return (data['items'] as List)
            .map((item) => PostModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      // Return empty list or throw depending on UI requirements
      print('Fetch Popular Posts Error: $e');
      return [];
    }
  }

  // 3. Fetch Posts by Category (e.g., INFO)
  Future<List<PostModel>> fetchPosts({required String category, int page = 1}) async {
    try {
      final response = await _dio.get(
        '/api/v1/posts',
        queryParameters: {
          'category': category,
          'page': page,
        },
      );
      // Response structure: { "posts": [...], "total": ... }
      final posts = response.data['posts'];
      if (posts != null) {
        return (posts as List).map((item) => PostModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Fetch Posts Error: $e');
      return [];
    }
  }

  // 4. Attendance Check
  Future<AttendanceResponse> checkAttendance() async {
    try {
      final response = await _dio.post('/api/v1/attendances/');
      return AttendanceResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 400) {
         // Already attended today
         throw Exception(e.response?.data['error'] ?? 'Already checked attendance');
      }
      throw Exception('Attendance Check Failed: $e');
    }
  }
}
