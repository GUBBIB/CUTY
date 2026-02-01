import 'package:flutter/material.dart';

class VisaMainScreen extends StatelessWidget {
  const VisaMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비자'),
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text('데이터 연동 대기 중'),
      ),
    );
  }
}
