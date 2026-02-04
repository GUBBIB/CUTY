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
          // Pattern Card: Popular Posts
          _PatternMenuCard(
            title: '🔥 인기게시글',
            subtitle: '지금 가장 핫한 이야기 모음',
            color: const Color(0xFFFFF3E0), // Orange[50]
            patternColor: Colors.orange.withValues(alpha: 0.15),
            patternIcons: const [
              Icons.local_fire_department,
              Icons.favorite,
              Icons.thumb_up,
              Icons.whatshot,
              Icons.star,
            ],
            characterAsset: 'assets/images/community_hot.png',
            imageHeight: 160,       // Increased size (approx 1.25x)
            imageRightOffset: 30,   // Standardized right margin (15.0)
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PopularPostsScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          // Pattern Card: Free Board
          _PatternMenuCard(
            title: '🗣️ 자유게시판',
            subtitle: '유학생들의 솔직한 수다 공간',
            color: const Color(0xFFE3F2FD), // Blue[50]
            patternColor: Colors.blue.withValues(alpha: 0.15),
            patternIcons: const [
              Icons.chat_bubble,
              Icons.forum,
              Icons.tag_faces,
              Icons.sms,
              Icons.record_voice_over,
            ],
            characterAsset: 'assets/images/community_free.png',
            imageRightOffset: 15, // Standardized right margin (15.0)
            // Default image size/offset is fine, text constraint handled in widget
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CommunityFeedScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          // Simple Card: Info Board
          _PatternMenuCard(
            title: '🎓 정보게시판',
            subtitle: '학교 생활 꿀팁 & 강의 정보',
            color: const Color(0xFFFFF9C4), // Yellow[100]
            patternColor: const Color(0xFFFBC02D).withValues(alpha: 0.1),
            patternIcons: const [
              Icons.school,
              Icons.menu_book,
              Icons.auto_stories,
              Icons.assignment,
              Icons.lightbulb_outline,
            ],
            characterAsset: 'assets/images/community_info.png',
            imageHeight: 130,       // Increased to match top cards (approx 130px)
            imageRightOffset: 45,   // Standardized right margin (15.0)
            imageBottomOffset: -5,  // Slight overflow for grounded look
            // cardHeight: 160,     // Default is 160, so we can omit this or explicitly set it if needed. Removing to use default.
            onTap: () => _navigateToBoard(context, '정보게시판'),
          ),
          const SizedBox(height: 12),
          // Simple Card: Second-hand Market
          _PatternMenuCard(
            title: '📦 중고장터',
            subtitle: '전공책, 자취용품 사고 팔기',
            color: const Color(0xFFE8F5E9), // Green[50]
            patternColor: const Color(0xFF388E3C).withValues(alpha: 0.1),
            patternIcons: const [
              Icons.shopping_bag,
              Icons.inventory_2,
              Icons.local_offer,
              Icons.card_giftcard,
              Icons.store,
            ],
            characterAsset: 'assets/images/community_used.png',
            imageHeight: 115,       // Requested approx 110-120px
            imageRightOffset: 15,   // Requested standard 40px
            imageBottomOffset: 0,
            onTap: () => _navigateToBoard(context, '중고장터'),
          ),
          const SizedBox(height: 24),
          // Create Board Button
          _SimpleMenuCard(
            title: '게시판 개설 신청',
            subtitle: '원하는 주제가 없나요? 직접 만들어보세요!',
            icon: Icons.add_circle_outline_rounded,
            color: Colors.white,
            iconColor: Colors.grey[600]!,
            border: Border.all(color: Colors.grey[300]!, width: 1.5),
            onTap: () => _showCreateBoardDialog(context),
            isCompact: true,
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

class _PatternMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final Color patternColor;
  final List<IconData> patternIcons;
  final String characterAsset;
  final VoidCallback onTap;
  final double imageHeight;
  final double imageRightOffset;
  final double imageBottomOffset;
  final double cardHeight;

  const _PatternMenuCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.patternColor,
    required this.patternIcons,
    required this.characterAsset,
    required this.onTap,
    this.imageHeight = 130,     // Default height
    this.imageRightOffset = 10, // Default right margin
    this.imageBottomOffset = -10,
    this.cardHeight = 160.0,    // Default card height
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cardHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Layer 1: Pattern
                ...List.generate(8, (index) {
                  final icon = patternIcons[index % patternIcons.length];
                  // Fixed positions for scattered look
                  final positions = [
                    const Offset(20, 80),
                    const Offset(100, 20),
                    const Offset(180, 70),
                    const Offset(250, 30),
                    const Offset(300, 100),
                    const Offset(60, 130),
                    const Offset(200, 140),
                    const Offset(320, 10),
                  ];
                  final pos = positions[index % positions.length];
                  
                  return Positioned(
                    left: pos.dx,
                    top: pos.dy,
                    child: Transform.rotate(
                      angle: (index * 0.5),
                      child: Icon(
                        icon,
                        size: 24 + (index % 3) * 10, // Varying sizes
                        color: patternColor,
                      ),
                    ),
                  );
                }),

                // Layer 2: Character Image (Adjusted size & margins)
                Positioned(
                  right: imageRightOffset, 
                  bottom: imageBottomOffset,
                  child: Image.asset(
                    characterAsset,
                    height: imageHeight, 
                    fit: BoxFit.contain,
                  ),
                ),

                // Layer 3: Text Content (Constrained width to 60%)
                Positioned(
                  left: 24,
                  top: 24,
                  width: constraints.maxWidth * 0.6, // Enforce 60% text width safe zone
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E2B4D),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}

class _SimpleMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  final BoxBorder? border;
  final bool isCompact;

  const _SimpleMenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
    this.border,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isCompact ? 100 : 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: border,
           boxShadow: border == null ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16), // Increased from 12 (1.3x area -> approx 1.15x padding dimension)
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: iconColor), // Increased from 28
            ),
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
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }
}
