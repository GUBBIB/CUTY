import 'package:flutter/material.dart';

class WalletMainScreen extends StatelessWidget {
  const WalletMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('서류지갑'),
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text('데이터 연동 대기 중'),
      ),
    );
  }
}
