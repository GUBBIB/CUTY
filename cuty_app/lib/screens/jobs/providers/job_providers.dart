import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../models/job_post.dart';
import '../../../models/banner_item.dart';
import '../../../services/mock_home_repository.dart'; // Currently holds the main provider
import '../../../services/local_storage_service.dart';
// import '../../../data/repositories/real_home_repository.dart'; // import if needing specific provider

// Use the main repository provider which is currently wired to RealHomeRepository in mock_home_repository.dart
// Ensure this path is correct based on where `homeRepositoryProvider` is defined.
// Checked step 98: homeRepositoryProvider is in lib/services/mock_home_repository.dart

final selectedJobCategoryProvider = StateProvider<int>((ref) => 0); // 0: 알바(Part-Time), 1: 취업(Career)
// Job Filter StateNotifier for persistence
class JobFilterNotifier extends StateNotifier<List<String>> {
  JobFilterNotifier() : super([]) {
    _loadFilter();
  }

  void _loadFilter() {
    state = LocalStorageService().getJobFilter();
  }

  void updateFilter(List<String> newFilter) {
    state = newFilter;
    LocalStorageService().saveJobFilter(state);
  }
  
  void toggleFilter(String filter) {
    if (state.contains(filter)) {
      updateFilter(state.where((f) => f != filter).toList());
    } else {
      updateFilter([...state, filter]);
    }
  }
}

final jobFilterProvider = StateNotifierProvider<JobFilterNotifier, List<String>>((ref) {
  return JobFilterNotifier();
});

final jobListProvider = FutureProvider<List<JobPost>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  final categoryIndex = ref.watch(selectedJobCategoryProvider);
  
  try {
    // Career Tab -> Force Empty State
    if (categoryIndex == 1) {
      return [
        JobPost(
          id: 'career_dummy_1',
          title: '경력직 개발자 채용 (더미)',
          companyName: '미래기술',
          location: '서울 강남구',
          salary: '연봉 5,000만원 이상',
          description: '경력직 개발자를 모십니다. 혁신적인 프로젝트에 참여하세요.',
          tags: ['비자가능', '학교 버스 10분'],
          imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=1000&auto=format&fit=crop',
          isVerified: true,
          isBookmarked: false,
          postedDate: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ]; 
    }
    
    // Part-Time Tab -> Fetch from Repository (Single Dummy)
    return await repository.fetchJobPosts();
  } catch (e) {
    debugPrint('JobFetch Error (Prototype Mode): $e');
    return [];
  }
});

final bannerListProvider = FutureProvider<List<BannerItem>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  final categoryIndex = ref.watch(selectedJobCategoryProvider);
  return await repository.fetchBanners(categoryIndex);
});

class JobTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final LinearGradient bannerGradient;

  const JobTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.bannerGradient,
  });
}

final jobThemeProvider = Provider<JobTheme>((ref) {
  final categoryIndex = ref.watch(selectedJobCategoryProvider);
  if (categoryIndex == 1) {
    // Career (Navy)
    return const JobTheme(
      primaryColor: Color(0xFF1A237E), // Indigo 900
      secondaryColor: Color(0xFF3949AB), // Indigo 600
      bannerGradient: LinearGradient(
        colors: [Color(0xFF5C6BC0), Color(0xFF283593)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
  // Part-Time (Mint)
  return const JobTheme(
    primaryColor: Color(0xFF26A69A), // Teal 400
    secondaryColor: Color(0xFF80CBC4), // Teal 200
    bannerGradient: LinearGradient(
      colors: [Color(0xFFB2DFDB), Color(0xFF4DB6AC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
});
