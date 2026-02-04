import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/api_service.dart';
import '../../../../services/home_repository.dart';
import '../../../../services/home_repository_impl.dart';
import '../../../../services/mock_home_repository.dart';
import '../../../../models/schedule_item.dart';
import '../../../../models/community_post.dart';

// [Configuration]
// Set to false to use real API
const bool useMock = true;

// [Repository Provider]
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  if (useMock) {
    return MockHomeRepository();
  } else {
    // In a real app, you might want to provide ApiService via a provider too
    // final apiService = ref.watch(apiServiceProvider);
    return HomeRepositoryImpl(apiService: ApiService.instance);
  }
});

// [Data Providers]

// 1. Schedule Requests
final scheduleListProvider = FutureProvider<List<ScheduleItem>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.fetchDailySchedule();
});

// 2. Community Posts Requests
final communityPostsProvider = FutureProvider<List<CommunityPost>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.fetchPopularPosts();
});
