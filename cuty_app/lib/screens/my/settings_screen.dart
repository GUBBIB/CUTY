import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/user_provider.dart';
import '../../providers/fortune_provider.dart';
import '../../main.dart'; // RestartWidget
import 'sub_screens/terms_detail_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isNotificationOn = true; // 알림 토글 상태

  // 초기화 및 재시작 로직
  Future<void> _performReset(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 데이터 전체 삭제
    ref.invalidate(userProvider);
    ref.invalidate(fortuneProvider);
    
    if (context.mounted) {
      RestartWidget.restartApp(context);
    }
  }

  // 섹션 헤더 위젯
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('설정', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('앱 설정'),
          ListTile(
            title: const Text('언어 설정'),
            trailing: SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text('한국어', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
            ),
            onTap: () {}, // 언어 변경 기능 추후 구현
          ),
          ListTile(
            title: const Text('알림 설정'),
            trailing: Switch(
              value: _isNotificationOn,
              activeColor: const Color(0xFF2C2C4E), // 스크린샷의 짙은 남색
              onChanged: (value) {
                setState(() => _isNotificationOn = value);
              },
            ),
          ),
          ListTile(
            title: const Text('화면 설정'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () {}, 
          ),

          const Divider(height: 30, thickness: 8, color: Color(0xFFF5F5F5)), // 섹션 구분선

          _buildSectionHeader('정보'),
          ListTile(
            title: const Text('버전 정보'),
            trailing: const Text('v1.0.0', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
          ),
          ListTile(
            title: const Text('이용약관'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (ctx) => const TermsDetailScreen(title: '이용약관', content: CutyTermsData.termsOfService))),
          ),
          ListTile(
            title: const Text('개인정보 처리방침'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (ctx) => const TermsDetailScreen(title: '개인정보 처리방침', content: CutyTermsData.privacyPolicy))),
          ),

          const Divider(height: 30, thickness: 8, color: Color(0xFFF5F5F5)),

          _buildSectionHeader('계정'),
          ListTile(
            title: const Text('로그아웃', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('로그아웃 하시겠습니까?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('취소')),
                    TextButton(onPressed: () { Navigator.pop(ctx); _performReset(context); }, 
                      child: const Text('확인', style: TextStyle(color: Colors.red))),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: const Text('회원 탈퇴', style: TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('회원 탈퇴'),
                  content: const Text('정말로 탈퇴하시겠습니까?\n모든 데이터가 삭제됩니다.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('취소')),
                    TextButton(onPressed: () { Navigator.pop(ctx); _performReset(context); }, 
                      child: const Text('탈퇴', style: TextStyle(color: Colors.red))),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
