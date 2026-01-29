import '../models/schedule_item.dart';
import '../models/community_post.dart';
import '../models/job_post.dart';
import '../models/banner_item.dart';

abstract class HomeRepository {
  Future<List<ScheduleItem>> fetchDailySchedule();
  Future<List<CommunityPost>> fetchPopularPosts();
  Future<List<JobPost>> fetchJobPosts();
  Future<List<BannerItem>> fetchBanners(int categoryIndex);
}
