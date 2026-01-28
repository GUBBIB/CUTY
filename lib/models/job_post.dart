class JobPost {
  final String title;
  final int hourlyWage;
  final List<String> tags;
  final String imageUrl;
  final bool isVerified;

  JobPost({
    required this.title,
    required this.hourlyWage,
    required this.tags,
    required this.imageUrl,
    this.isVerified = false,
  });
}
