class JobPost {
  final String? id;
  final String title;
  final String? companyName;
  final String? location;
  final int? hourlyWage;
  final String? salary;
  final List<String> tags;
  final String imageUrl;
  final bool isVerified;
  final bool isBookmarked;
  final String? description;
  final DateTime? postedDate;
  final String? workingHours;
  final String? requirements;
  final String? deadline;

  JobPost({
    this.id,
    required this.title,
    this.companyName,
    this.location,
    this.hourlyWage,
    this.salary,
    required this.tags,
    required this.imageUrl,
    this.isVerified = false,
    this.isBookmarked = false,
    this.description,
    this.postedDate,
    this.workingHours,
    this.requirements,
    this.deadline,
  });
}
