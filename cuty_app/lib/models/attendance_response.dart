class AttendanceResponse {
  final int gainedPoint;
  final String message;
  final int totalPoints;

  AttendanceResponse({
    required this.gainedPoint,
    required this.message,
    required this.totalPoints,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      gainedPoint: json['gained_point'] ?? 0,
      message: json['message'] ?? '',
      totalPoints: json['total_points'] ?? 0,
    );
  }
}
