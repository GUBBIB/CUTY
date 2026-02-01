import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../wallet/my_point_screen.dart';
import '../spec/spec_wallet_screen.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserModel.dummy();

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // 1. Profile Header
                _ProfileHeader(user: user),
                const SizedBox(height: 24),

                // 2. Visa & Work Permit Dashboard
                _VisaDashboard(user: user),
                const SizedBox(height: 24),

                // 3. Weekly Schedule
                const _WeeklySchedule(),
                const SizedBox(height: 24),

                // 4. Menu List
                const _MenuList(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserModel user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    // Number formatter removed since points are hardcoded to '- P'
    // final pointsFormatted = user.points.toString().replaceAllMapped(
    //     RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    return Row(
      children: [
          // Avatar
        Container(
          width: 60,
          height: 60,
          // Removed padding to make the image fill the circle better as per "fit: BoxFit.cover" request
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200], // Light grey background
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipOval( // ClipOval ensures the square image is clipped to the circle
            child: Image.asset(
              'assets/images/unknown_user.png',
              fit: BoxFit.cover, // Cover to fill the circle
            ),
          ),
        ),
        const SizedBox(width: 16),
        // User Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.university,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Points & Shop
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyPointScreen()),
                );
              },
              child: const Text(
                '- P', // explicitly set to "- P" as requested
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E), // Navy
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Shop Action
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F51B5), // Indigo/Blue
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3F51B5).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'Shop',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VisaDashboard extends StatelessWidget {
  final UserModel user;
  const _VisaDashboard({required this.user});

  @override
  Widget build(BuildContext context) {
    // Logic for Badge: If visa is "비자 정보 없음", show Grey "미연동" badge
    final isVisaEmpty = user.visaType == '비자 정보 없음';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF009688), // Teal
            Color(0xFF3F51B5), // Blue
            Color(0xFF9C27B0), // Purple
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3F51B5).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '비자 & 취업 허가 대시보드',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Card 1: Visa Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '비자 상태',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user.visaType} | 만료: ${user.visaExpiry}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isVisaEmpty ? Colors.grey[200] : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isVisaEmpty ? '미연동' : 'SAFE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isVisaEmpty ? Colors.grey[600] : const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Card 2: Work Permit
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '아르바이트 허가',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isVisaEmpty ? '- ~ -' : '${user.workPermitDate} | ${user.isWorkPermitApproved ? '승인 완료' : '미승인'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isVisaEmpty ? Colors.grey : Colors.black87,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    isVisaEmpty ? Icons.access_time_rounded : Icons.check, // Empty state -> Clock icon
                    size: 16,
                    color: isVisaEmpty ? Colors.grey : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklySchedule extends StatelessWidget {
  const _WeeklySchedule();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '주간 시간표',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          // Table Layout
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              // Header Row
              const TableRow(
                children: [
                  Center(child: Text('Mon', style: TextStyle(fontWeight: FontWeight.bold))),
                  Center(child: Text('Tue', style: TextStyle(fontWeight: FontWeight.bold))),
                  Center(child: Text('Wed', style: TextStyle(fontWeight: FontWeight.bold))),
                  Center(child: Text('Thu', style: TextStyle(fontWeight: FontWeight.bold))),
                  Center(child: Text('Fri', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              const TableRow(children: [SizedBox(height: 12), SizedBox(height: 12), SizedBox(height: 12), SizedBox(height: 12), SizedBox(height: 12)]),
              // Row 1: Classes
              TableRow(
                children: [
                  _buildEventBlock('수업', const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
                  _buildEventBlock('수업', const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
                  _buildEventBlock('수업', const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
                  _buildEventBlock('수업', const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
                  const SizedBox(), // Empty
                ],
              ),
               const TableRow(children: [SizedBox(height: 8), SizedBox(height: 8), SizedBox(height: 8), SizedBox(height: 8), SizedBox(height: 8)]),
              // Row 2: Part-time
              TableRow(
                children: [
                   const SizedBox(), // Empty
                   _buildEventBlock('알바', const Color(0xFFFFF3E0), const Color(0xFFEF6C00)),
                   const SizedBox(), // Empty
                   const SizedBox(), // Empty
                   _buildEventBlock('알바', const Color(0xFFFFF3E0), const Color(0xFFEF6C00)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventBlock(String text, Color bgColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  const _MenuList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.folder_outlined, '서류 지갑'),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildMenuItem(Icons.chat_bubble_outline_rounded, '커뮤니티 활동'),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildMenuItem(Icons.person_outline_rounded, '개인 정보 관리'),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildMenuItem(Icons.settings_outlined, '설정'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      onTap: () {
        if (title == '서류 지갑') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SpecWalletScreen()),
          );
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
