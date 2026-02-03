import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'community_feed_screen.dart';
import 'community_board_screen.dart';
import 'popular_posts_screen.dart';

class CommunityMainScreen extends StatelessWidget {
  const CommunityMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          _BigMenuCard(
            title: '🔥 인기게시글',
            subtitle: '지금 가장 핫한 이야기 모음',
            icon: Icons.whatshot_rounded,
            color: const Color(0xFFFFF3E0), // Orange[50]
            iconColor: const Color(0xFFF57C00), // Orange[700]
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PopularPostsScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _BigMenuCard(
            title: '🗣️ 자유게시판',
            subtitle: '유학생들의 솔직한 수다 공간',
            icon: Icons.forum_rounded,
            color: const Color(0xFFE3F2FD), // Blue[50]
            iconColor: const Color(0xFF1976D2), // Blue[700]
             onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CommunityFeedScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _BigMenuCard(
            title: '🎓 정보게시판',
            subtitle: '학교 생활 꿀팁 & 강의 정보',
            icon: Icons.school_rounded,
            color: const Color(0xFFFFF9C4), // Yellow[100]
            iconColor: const Color(0xFFFBC02D), // Yellow[700]
            onTap: () => _navigateToBoard(context, '정보게시판'),
          ),
          const SizedBox(height: 12),
          _BigMenuCard(
            title: '🔒 비밀게시판',
            subtitle: '익명 보장! 속마음 털어놓기',
            icon: Icons.lock_outline_rounded,
            color: const Color(0xFFF5F5F5), // Grey[100]
            iconColor: const Color(0xFF616161), // Grey[700]
            onTap: () => _navigateToBoard(context, '비밀게시판'),
          ),
          const SizedBox(height: 12),
          _BigMenuCard(
            title: '🛒 장터',
            subtitle: '전공책, 자취용품 사고 팔기',
            icon: Icons.shopping_cart_outlined,
            color: const Color(0xFFE8F5E9), // Green[50]
            iconColor: const Color(0xFF388E3C), // Green[700]
            onTap: () => _navigateToBoard(context, '장터'),
          ),
          const SizedBox(height: 12),
          _BigMenuCard(
            title: '🏫 학교생활',
            subtitle: '동아리, 행사, 학생회 소식',
            icon: Icons.apartment_rounded,
            color: const Color(0xFFF3E5F5), // Purple[50]
            iconColor: const Color(0xFF7B1FA2), // Purple[700]
            onTap: () => _navigateToBoard(context, '학교생활'),
          ),
          const SizedBox(height: 24), // Extra spacing for the action button
          _BigMenuCard(
            title: '게시판 개설 신청',
            subtitle: '원하는 주제가 없나요? 직접 만들어보세요!',
            icon: Icons.add_circle_outline_rounded,
            color: Colors.white,
            iconColor: Colors.grey[600]!,
            border: Border.all(color: Colors.grey[300]!, width: 1.5), // Grey Outline
            onTap: () => _showCreateBoardDialog(context),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _navigateToBoard(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommunityBoardScreen(title: title)),
    );
  }

  void _showCreateBoardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('게시판 개설 신청', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('어떤 게시판을 만들고 싶으신가요?\n\n(추후 신청 폼이 구현될 예정입니다)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('신청이 접수되었습니다! (Mock)')),
              );
            },
            child: const Text('신청하기', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _BigMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  final BoxBorder? border;

  const _BigMenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 125, // Increased from 110
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: border,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Icon(icon, size: 40, color: iconColor), // Increased from 32
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 28),
          ],
        ),
      ),
    );
  }
}
