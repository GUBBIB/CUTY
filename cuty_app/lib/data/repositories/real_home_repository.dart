import 'package:dio/dio.dart';
import 'package:flutter/material.dart'; // Import Material for Icons and Colors
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/home_repository.dart';
import '../../models/schedule_item.dart';
import '../../models/community_post.dart';
import '../../models/job_post.dart';
import '../../models/banner_item.dart';
import '../../config/app_assets.dart'; // Ensure AppAssets is accessible for the Capybara image

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
      // API Endpoint doesn't exist yet, return empty list for safety to prevent connection errors
      /* 
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
      */
      return [];
    } catch (e) {
      // In case of error, return empty list or rethrow depending on requirement.
      // User asked to return empty or throw exception. Return empty for UI stability now or log.
      debugPrint('Error fetching posts: $e');
      return [];
    }
  }

  @override
  Future<List<JobPost>> fetchJobPosts() async {
    // Forced Dummy Data for Demo Mode
    return Future.value([
      JobPost(
        id: 'job_1',
        title: '부산 서면 카페 서빙',
        companyName: '카페 쿠티',
        location: '부산진구 중앙대로',
        hourlyWage: 10000,
        tags: ['비자가능', '학교 버스 10분'],
        imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=1000&auto=format&fit=crop',
        isVerified: true,
        workingHours: '주말 09:00 - 14:00',
        deadline: 'D-33',
        description: '밝은 미소로 손님을 맞이해 주세요.',
        requirements: '초보 가능, 한국어 3급 이상',
      ),
    ]);
  }
  @override
  Future<List<BannerItem>> fetchBanners(int categoryIndex) async {
    // 0: Part-Time (Alba), 1: Career (Job)
    if (categoryIndex == 0) {
      // Original Capybara Banner
      return [
        const BannerItem(
          title: '시간제 취업 허가',
          subtitle: '쿠티와 함께 쉽고 정확하게!',
          gradientColors: [Color(0xFF80E0D4), Color(0xFFB39DDB)], // Mint to Purple
          imagePath: AppAssets.capyBusiness,
        ),
        const BannerItem(
          title: '첫 알바, 무엇부터?',
          subtitle: '알바초보를 위한 기초 가이드',
          gradientColors: [Color(0xFFFFCC80), Color(0xFFFFAB91)], // Light Orange
          icon: Icons.help_outline_rounded,
        ),
        const BannerItem(
          title: '안전한 근로계약서',
          subtitle: '꼭 확인해야 할 필수 체크리스트',
          gradientColors: [Color(0xFF80CBC4), Color(0xFF4DB6AC)], // Mint
          icon: Icons.assignment_turned_in_rounded,
        ),
      ];
    } else {
      // Career Banners (Dummy)
      return [
        const BannerItem(
          title: 'Spec Diagnosis', // Title used as ID for custom UI
          subtitle: '',
          gradientColors: [Color(0xFF283593), Color(0xFF3F51B5)], // Lighter Navy to Blue
          imagePath: 'assets/images/capy_corp_semicut.png',
        ),
        const BannerItem(
          title: 'IT/스타트업 인턴십',
          subtitle: '한국 스타트업에서 커리어를 시작하세요.',
          gradientColors: [Color(0xFF0288D1), Color(0xFF4FC3F7)], // Light Blue
          icon: Icons.rocket_launch_outlined,
        ),
        const BannerItem(
          title: '이력서/자소서 첨삭',
          subtitle: '현직자가 알려주는 합격하는 작성법',
          gradientColors: [Color(0xFFE65100), Color(0xFFFF9800)], // Orange
          icon: Icons.edit_note_rounded,
        ),
      ];
    }
  }
}
