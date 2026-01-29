import 'package:flutter/material.dart';

class AcademicMainScreen extends StatelessWidget {
  const AcademicMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학사정보'),
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text('데이터 연동 대기 중'),
      ),
    );
  }
}
