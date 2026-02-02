import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

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
      print("[API] Base URL is empty. Login simulation.");
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
        print('Login Failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Login Error: $e');
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
        print('Fetch Info Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Fetch Info Error: $e');
    }
    return null;
  }
}
