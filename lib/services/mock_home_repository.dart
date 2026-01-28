import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/schedule_item.dart';
import '../models/community_post.dart';
import 'package:dio/dio.dart'; // Import Dio
import '../data/repositories/real_home_repository.dart'; // Import Real Repo
import 'home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  // Use RealHomeRepository with Dio
  // For now, let's create a placeholder Dio. In a real app, you might provide Dio separately.
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.university.ac.kr', // Base URL from API Spec context (implied)
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
  return RealHomeRepository(dio);
});

class MockHomeRepository implements HomeRepository {
  @override
  Future<List<ScheduleItem>> fetchDailySchedule() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      ScheduleItem(
        time: '10:00',
        title: '경제론',
        subtitle: '경적 304',
      ),
    ];
  }

  @override
  Future<List<CommunityPost>> fetchPopularPosts() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      CommunityPost(
        userName: '부산대맛집스',
        title: '부산대 맛집 리스트 공유해요!',
        content: '부산대 맛집 리스트 공유해요! 🔥',
        likes: 21,
        comments: 11,
        timeAgo: '2시간',
      ),
    ];
  }
}
