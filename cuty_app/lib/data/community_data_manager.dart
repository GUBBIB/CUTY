import '../models/community_model.dart';
import 'dummy_community_data.dart'; // Import to initialize data

class CommunityDataManager {
  // Singleton pattern
  static final CommunityDataManager _instance = CommunityDataManager._internal();
  factory CommunityDataManager() => _instance;
  CommunityDataManager._internal() {
    // Initialize with dummy data
    _posts.addAll(allPosts);
  }

  // Internal memory storage
  static final List<Post> _posts = [];

  // 1. Get Posts by Board Type
  static List<Post> getPosts(BoardType type) {
    if (_posts.isEmpty) {
      _posts.addAll(allPosts); // Fallback initialization
    }
    final filteredPosts = _posts.where((post) => post.boardType == type).toList();
    filteredPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by newest
    return filteredPosts;
  }

  // 2. Get Popular Posts
  static List<Post> getPopularPosts() {
    if (_posts.isEmpty) {
      _posts.addAll(allPosts);
    }
    final sortedPosts = List<Post>.from(_posts);
    sortedPosts.sort((a, b) => b.likeCount.compareTo(a.likeCount));
    return sortedPosts.take(5).toList();
  }

  // 3. Add Post (Interactive Writability)
  static void addPost(Post newPost) {
    if (_posts.isEmpty) {
      _posts.addAll(allPosts);
    }
    _posts.insert(0, newPost); // Add to top
  }

  // 4. Get My Posts
  static List<Post> getMyPosts() {
    if (_posts.isEmpty) {
      _posts.addAll(allPosts);
    }
    // Mock Logic: Return posts authored by '나' AND some random ones for demo
    // In real app, check `post.authorId == currentUserId`
    return _posts.where((post) => post.authorName == '나').toList();
  }
}
