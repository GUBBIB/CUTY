import 'package:flutter/material.dart';

class PartTimeApplyConsentScreen extends StatelessWidget {
  const PartTimeApplyConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("약관 동의")),
      body: const Center(
        child: Text("약관 동의 화면입니다."),
      ),
    );
  }
}
