class ScheduleItem {
  final String title;
  final String subtitle;
  final String time;

  ScheduleItem({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'time': time,
    };
  }
}
