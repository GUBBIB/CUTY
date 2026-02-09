import 'package:flutter/material.dart';

class ScreenSettingsScreen extends StatefulWidget {
  const ScreenSettingsScreen({super.key});

  @override
  State<ScreenSettingsScreen> createState() => _ScreenSettingsScreenState();
}

class _ScreenSettingsScreenState extends State<ScreenSettingsScreen> {
  bool _isDarkMode = false; // 추후 Provider로 교체 예정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('화면 설정')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('다크 모드'),
            subtitle: const Text('어두운 환경에서 눈을 편안하게 합니다.'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('다크 모드 설정이 저장되었습니다. (UI 예시)')),
              );
            },
          ),
        ],
      ),
    );
  }
}
