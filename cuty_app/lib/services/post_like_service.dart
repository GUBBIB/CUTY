import 'package:cuty_app/config/app_config.dart';
import 'package:cuty_app/models/post.dart';
import 'package:cuty_app/services/token_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostLikeService {
  final String baseUrl = AppConfig.baseApiUrl;
  final TokenService _tokenService = TokenService();

  Future<Post> likePost(int postId) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/posts/$postId/like'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return Post.fromJson(data);
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '게시글 좋아요에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  Future<Post> unlikePost(int postId) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/posts/$postId/unlike'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return Post.fromJson(data);
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '게시글 좋아요 취소에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  Future<Post> dislikePost(int postId) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/posts/$postId/dislike'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return Post.fromJson(data);
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '게시글 싫어요에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  Future<Post> undislikePost(int postId) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.delete(
          Uri.parse('$baseUrl/posts/$postId/dislike'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return Post.fromJson(data);
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '게시글 싫어요 취소에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }
}
