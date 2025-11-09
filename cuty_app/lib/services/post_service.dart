import 'package:cuty_app/config/app_config.dart';
import 'package:cuty_app/models/college.dart';
import 'package:cuty_app/models/department.dart';
import 'package:cuty_app/models/post.dart';
import 'package:cuty_app/models/school.dart';
import 'package:cuty_app/services/token_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostService {
  final String baseUrl = AppConfig.baseApiUrl;
  final TokenService _tokenService = TokenService();

  Future<Map<String, dynamic>> getPosts({
    int page = 1,
    int perPage = 10,
    String? category,
    String search = '',
    int? schoolId,
    int? collegeId,
    int? departmentId,
  }) async {
    try {
      String url = '$baseUrl/posts?page=$page&per_page=$perPage';
      if (category != null) {
        url += '&category=$category';
      }
      if (search.isNotEmpty) {
        url += '&search=${Uri.encodeComponent(search)}';
      }
      if (schoolId != null) {
        url += '&school_id=$schoolId';
      }
      if (collegeId != null) {
        url += '&college_id=$collegeId';
      }
      if (departmentId != null) {
        url += '&department_id=$departmentId';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<Post> posts = (data['posts'] as List).map((json) {
          try {
            return Post.fromJson(json);
          } catch (e) {
            rethrow;
          }
        }).toList();

        return {
          'posts': posts,
          'total': data['total'],
          'pages': data['pages'],
          'currentPage': data['current_page'],
          'perPage': data['per_page'],
          'currentFilters': {
            'category': data['category'],
            'search': data['search'],
            'school': data['current_filters']['school'] != null
                ? School.fromJson(
                    data['current_filters']['school'] as Map<String, dynamic>)
                : null,
            'college': data['current_filters']['college'] != null
                ? College.fromJson(
                    data['current_filters']['college'] as Map<String, dynamic>)
                : null,
            'department': data['current_filters']['department'] != null
                ? Department.fromJson(data['current_filters']['department']
                    as Map<String, dynamic>)
                : null,
          },
        };
      } else {
        throw Exception('게시글 목록을 불러오는데 실패했습니다');
      }
    } catch (e) {
      print('서버 오류: $e');
      throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
    }
  }

  Future<Post> getPost(int postId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/$postId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Post.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('존재하지 않는 게시글입니다');
      } else {
        throw Exception('게시글을 불러오는데 실패했습니다');
      }
    } catch (e) {
      throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
    }
  }

  Future<Post> createPost({
    required String title,
    required String content,
    required String category,
  }) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/posts'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'title': title,
            'content': content,
            'category': category,
          }),
        );

        if (response.statusCode == 201) {
          final Map<String, dynamic> data = json.decode(response.body);
          return Post.fromJson(data);
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '게시글 작성에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  Future<Post> updatePost({
    required int postId,
    String? title,
    String? content,
    String? category,
  }) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final Map<String, dynamic> body = {};
        if (title != null) body['title'] = title;
        if (content != null) body['content'] = content;
        if (category != null) body['category'] = category;

        final response = await http.put(
          Uri.parse('$baseUrl/posts/$postId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return Post.fromJson(data);
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '게시글 수정에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  Future<void> deletePost(int postId) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.delete(
          Uri.parse('$baseUrl/posts/$postId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode != 204) {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '게시글 삭제에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  Future<Map<String, dynamic>> getMyPosts({
    int page = 1,
    int perPage = 10,
  }) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/users/me/posts?page=$page&per_page=$perPage'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<Post> posts = (data['posts'] as List).map((json) {
            try {
              return Post.fromJson(json);
            } catch (e) {
              rethrow;
            }
          }).toList();

          return {
            'posts': posts,
            'total': data['total'],
            'pages': data['pages'],
            'currentPage': data['current_page'],
            'perPage': data['per_page'],
          };
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '내가 쓴 글을 불러오는데 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }
}
