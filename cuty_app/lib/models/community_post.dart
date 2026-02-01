class CommunityPost {
  final String userName;
  final String title;
  final String content;
  final int likes;
  final int comments;
  final String timeAgo;

  CommunityPost({
    required this.userName,
    required this.title,
    required this.content,
    required this.likes,
    required this.comments,
    required this.timeAgo,
  });
}
