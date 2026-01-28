import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/home_repository.dart';
import '../../models/schedule_item.dart';
import '../../models/community_post.dart';
import '../models/post_dto.dart';

// Provider for RealHomeRepository
final realHomeRepositoryProvider = Provider<HomeRepository>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.university.ac.kr', // Replace with actual base URL if known, or keep placeholder
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
  return RealHomeRepository(dio);
});

class RealHomeRepository implements HomeRepository {
  final Dio _dio;

  RealHomeRepository(this._dio);

  @override
  Future<List<ScheduleItem>> fetchDailySchedule() {
    // API Endpoint doesn't exist yet, return empty list for safety
    return Future.value([]);
  }

  @override
  Future<List<CommunityPost>> fetchPopularPosts() async {
    try {
      final response = await _dio.get('/api/v1/posts/popular', queryParameters: {
        'limit': 5,
        // Add category if needed, e.g., 'category': 'FREE'
      });

      if (response.statusCode == 200) {
        final postResponse = PostResponse.fromJson(response.data);
        
        // Map DTO to Domain Model
        return postResponse.data.items.map((dto) {
          return CommunityPost(
            userName: 'Anonymous', // API doesn't seem to return user info in simple list often, check if present
            title: dto.title,
            content: dto.content ?? '',
            likes: dto.likesCount ?? 0,
            comments: 0, // Comment count might not be in the list response
            timeAgo: '방금 전', // Date parsing logic needed if created_at is provided
          );
        }).toList();
      }
      return [];
    } catch (e) {
      // In case of error, return empty list or rethrow depending on requirement.
      // User asked to return empty or throw exception. Return empty for UI stability now or log.
      debugPrint('Error fetching posts: $e');
      return [];
    }
  }
}
