class Schedule {
  final int? id;
  final String title;
  final String classroom;
  final String day;
  final int startTime;
  final int duration;

  Schedule({
    this.id,
    required this.title,
    required this.classroom,
    required this.day,
    required this.startTime,
    required this.duration,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'], // nullable
      title: json['title'] ?? '',
      classroom: json['classroom'] ?? '',
      day: json['day'] ?? '',
      startTime: json['start_time'] ?? 9, // Default to 1st period (9:00) if missing
      duration: json['duration'] ?? 1, // Default duration 1 hour
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'classroom': classroom,
      'day': day,
      'start_time': startTime,
      'duration': duration,
    };
  }
}
