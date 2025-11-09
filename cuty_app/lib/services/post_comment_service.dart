import 'package:cuty_app/config/app_config.dart';
import 'package:cuty_app/models/post_comment.dart';
import 'package:cuty_app/services/token_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostCommentService {
  final String baseUrl = AppConfig.baseApiUrl;
  final TokenService _tokenService = TokenService();

  Future<Map<String, dynamic>> getComments(
    int postId, {
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/posts/$postId/comments?page=$page&per_page=$perPage'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<PostComment> comments = (data['comments'] as List)
            .map((json) => PostComment.fromJson(json))
            .toList();

        return {
          'comments': comments,
          'total': data['total'],
          'pages': data['pages'],
          'currentPage': data['current_page'],
          'perPage': data['per_page'],
        };
      } else if (response.statusCode == 404) {
        throw Exception('존재하지 않는 게시글입니다');
      } else {
        throw Exception('댓글 목록을 불러오는데 실패했습니다');
      }
    } catch (e) {
      throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getReplies(
    int postId,
    int commentId, {
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/posts/$postId/comments/$commentId/replies?page=$page&per_page=$perPage'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<PostComment> replies = (data['replies'] as List)
            .map((json) => PostComment.fromJson(json))
            .toList();

        return {
          'replies': replies,
          'total': data['total'],
          'pages': data['pages'],
          'currentPage': data['current_page'],
          'perPage': data['per_page'],
        };
      } else if (response.statusCode == 404) {
        throw Exception('존재하지 않는 게시글 또는 댓글입니다');
      } else {
        throw Exception('대댓글 목록을 불러오는데 실패했습니다');
      }
    } catch (e) {
      throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
    }
  }

  Future<PostComment> createComment({
    required int postId,
    required String content,
    int? parentId,
  }) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/posts/$postId/comments'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'content': content,
            if (parentId != null) 'parent_id': parentId,
          }),
        );

        if (response.statusCode == 201) {
          final Map<String, dynamic> data = json.decode(response.body);
          return PostComment.fromJson(data);
        } else if (response.statusCode == 404) {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '존재하지 않는 게시글입니다');
        } else if (response.statusCode == 400) {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '잘못된 요청입니다');
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '댓글 작성에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  Future<PostComment> updateComment({
    required int postId,
    required int commentId,
    required String content,
  }) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.put(
          Uri.parse('$baseUrl/posts/$postId/comments/$commentId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'content': content,
          }),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return PostComment.fromJson(data);
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '댓글 수정에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  Future<void> deleteComment(int postId, int commentId) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.delete(
          Uri.parse('$baseUrl/posts/$postId/comments/$commentId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode != 204) {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '댓글 삭제에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  Future<PostComment> getComment(int postId, int commentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/$postId/comments/$commentId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return PostComment.fromJson(data);
      } else if (response.statusCode == 404) {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? '존재하지 않는 게시글 또는 댓글입니다');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? '댓글을 불러오는데 실패했습니다');
      }
    } catch (e) {
      throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getMyComments({
    int page = 1,
    int perPage = 10,
  }) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/users/me/comments?page=$page&per_page=$perPage'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<PostComment> comments =
              (data['comments'] as List).map((json) {
            try {
              return PostComment.fromJson(json);
            } catch (e) {
              rethrow;
            }
          }).toList();

          return {
            'comments': comments,
            'total': data['total'],
            'pages': data['pages'],
            'currentPage': data['current_page'],
            'perPage': data['per_page'],
          };
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '내가 쓴 댓글을 불러오는데 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }
}
