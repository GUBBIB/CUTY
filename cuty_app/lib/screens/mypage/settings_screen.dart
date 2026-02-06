import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: Text(
          '설정',
          style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _buildSectionHeader('앱 설정'),
          _buildSwitchTile('알림 설정', true, (val) {}),
          _buildListTile('화면 설정', () {}),
          
          const SizedBox(height: 24),
          _buildSectionHeader('정보'),
          _buildInfoTile('앱 버전', 'v1.0.0'),
          _buildListTile('이용약관', () {}),
          _buildListTile('개인정보 처리방침', () {}),
          
          const SizedBox(height: 24),
          _buildSectionHeader('계정'),
          _buildListTile(
            '로그아웃', 
            () {
              // Mock Logout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('로그아웃 되었습니다.')),
              );
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            color: Colors.red,
          ),
           _buildListTile(
            '회원 탈퇴', 
            () {},
            color: Colors.grey,
            isSmall: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.notoSansKr(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      color: Colors.white,
      child: SwitchListTile(
        title: Text(
          title, 
          style: GoogleFonts.notoSansKr(fontSize: 16),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF1A1A2E), // Navy
      ),
    );
  }

  Widget _buildListTile(String title, VoidCallback onTap, {Color? color, bool isSmall = false}) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.notoSansKr(
            fontSize: isSmall ? 14 : 16,
            color: color ?? Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoTile(String title, String info) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.notoSansKr(fontSize: 16),
        ),
        trailing: Text(
          info,
          style: GoogleFonts.notoSansKr(
            fontSize: 14,
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
