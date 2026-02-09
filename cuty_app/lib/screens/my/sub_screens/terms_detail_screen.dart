import 'package:flutter/material.dart';

class TermsDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  const TermsDetailScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Text(content, style: const TextStyle(height: 1.6, fontSize: 14, color: Colors.black87)),
      ),
    );
  }
}

class CutyTermsData {
  static const String termsOfService = """
[제1조 목적]
본 약관은 'Cuty'가 제공하는 유학생 비자 및 생활 정보 서비스의 이용조건을 규정합니다.

[제2조 서비스 내용]
1. 비자 로드맵 및 진단 서비스
2. 유학생 커뮤니티 및 정보 공유
3. 알바/취업 정보 제공

[제3조 의무]
사용자는 본인의 비자 정보를 정확히 입력해야 하며, 허위 정보로 인한 불이익은 본인이 책임집니다.
"""; // (내용 축약, 실제 적용 시 길게 작성 가능)

  static const String privacyPolicy = """
[1. 수집 항목]
이메일, 닉네임, 비자 타입(D-2, D-10 등), 입학/졸업 시기

[2. 수집 목적]
맞춤형 비자 로드맵 제공 및 커뮤니티 운영

[3. 보유 기간]
회원 탈퇴 시 즉시 파기합니다.
""";
}
