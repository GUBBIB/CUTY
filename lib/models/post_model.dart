class PostModel {
  final int id;
  final String title;
  final String content;
  final int likeCount;
  final int viewCount;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.likeCount,
    required this.viewCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      likeCount: json['like_count'] ?? 0,
      viewCount: json['view_count'] ?? 0,
    );
  }
}
