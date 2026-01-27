class AuthResponse {
  final String accessToken;
  final String tokenType;
  final String? userType;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    this.userType,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      userType: json['user_type'],
    );
  }
}
