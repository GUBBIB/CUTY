import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_assets.dart';
import '../../models/schedule_item.dart';
import '../../models/community_post.dart';
import '../../services/mock_home_repository.dart'; // Keep for provider access? Or change later
import '../../services/home_repository.dart'; // Import Interface

// State class
class HomeState {
  final bool isLoading;
  final List<ScheduleItem> schedule;
  final List<CommunityPost> posts;
  final String characterImage;
  final String? error;

  HomeState({
    this.isLoading = true,
    this.schedule = const [],
    this.posts = const [],
    required this.characterImage,
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    List<ScheduleItem>? schedule,
    List<CommunityPost>? posts,
    String? characterImage,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      schedule: schedule ?? this.schedule,
      posts: posts ?? this.posts,
      characterImage: characterImage ?? this.characterImage,
      error: error ?? this.error,
    );
  }
}

// ViewModel
class HomeViewModel extends StateNotifier<HomeState> {
  final HomeRepository _repository; // Use interface, not implementation class

  HomeViewModel(this._repository)
      : super(HomeState(characterImage: AppAssets.capyFortuneHold)) {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final schedule = await _repository.fetchDailySchedule();
      final posts = await _repository.fetchPopularPosts();

      state = state.copyWith(
        isLoading: false,
        schedule: schedule,
        posts: posts,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to load data",
        characterImage: AppAssets.capyBow, // Error state image
      );
    }
  }

  void refresh() {
    _updateCharacterImage();
    _loadData();
  }

  void _updateCharacterImage() {
    final random = Random();
    final newImage = AppAssets.randomPoses[random.nextInt(AppAssets.randomPoses.length)];
    state = state.copyWith(characterImage: newImage);
  }
}

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return HomeViewModel(repository);
});
