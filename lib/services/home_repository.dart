import '../models/schedule_item.dart';
import '../models/community_post.dart';

abstract class HomeRepository {
  Future<List<ScheduleItem>> fetchDailySchedule();
  Future<List<CommunityPost>> fetchPopularPosts();
}
