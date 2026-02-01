import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/schedule_item.dart';
import '../models/community_post.dart';
import '../models/job_post.dart';
import '../models/banner_item.dart';
import 'api_service.dart';
import 'home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiService _apiService;

  HomeRepositoryImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<List<ScheduleItem>> fetchDailySchedule() async {
    // [Backend Readiness]
    // Currently ApiService doesn't have a specific method for schedules.
    // In a real scenario, we would add fetchSchedules() to ApiService.
    // For now, returning empty list to satisfy interface.
    // TODO: Implement actual API call when backend endpoint is ready.
    return []; 
  }

  @override
  Future<List<CommunityPost>> fetchPopularPosts() async {
    try {
      final postModels = await _apiService.fetchPopularPosts();
      
      // Map PostModel to CommunityPost
      return postModels.map((model) {
        return CommunityPost(
          userName: "익명", // PostModel doesn't have user info yet
          title: model.title,
          content: model.content,
          likes: model.likeCount,
          comments: 0, // PostModel doesn't have comment count yet
          timeAgo: "방금 전", // PostModel doesn't have timestamp yet
        );
      }).toList();
    } catch (e) {
      // In production, might want to log this or rethrow specific error
      throw Exception('Failed to fetch popular posts: $e');
    }
  }

  @override
  Future<List<JobPost>> fetchJobPosts() async {
    // Placeholder - ApiService support needed
    return [];
  }

  @override
  Future<List<BannerItem>> fetchBanners(int categoryIndex) async {
    return [];
  }
}

// Provider
final homeRepositoryImplProvider = Provider<HomeRepository>((ref) {
  // Assuming generic ApiService is sufficient or configured elsewhere
  return HomeRepositoryImpl(apiService: ApiService()); 
});
