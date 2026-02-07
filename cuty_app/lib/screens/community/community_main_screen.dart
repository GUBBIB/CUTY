import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/gen/app_localizations.dart';
import 'free_board_screen.dart';
import 'community_board_screen.dart';
import 'popular_posts_screen.dart';
import 'info_board_screen.dart';
import 'question_board_screen.dart';
import 'used_market_screen.dart';
import 'widgets/privacy_settings_modal.dart' as widgets;


class CommunityMainScreen extends StatelessWidget {
  const CommunityMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.navCommunity, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const widgets.PrivacySettingsModal(),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // Pattern Card: Popular Posts
          _PatternMenuCard(
            title: AppLocalizations.of(context)!.boardPopularTitle,
            subtitle: AppLocalizations.of(context)!.boardPopularSubtitle,
            color: const Color(0xFFFFF3E0), // Orange[50]
            patternColor: Colors.orange.withOpacity(0.15),
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
            title: AppLocalizations.of(context)!.boardFreeTitle,
            subtitle: AppLocalizations.of(context)!.boardFreeSubtitle,
            color: const Color(0xFFE3F2FD), // Blue[50]
            patternColor: Colors.blue.withOpacity(0.15),
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
                MaterialPageRoute(builder: (context) => const FreeBoardScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          // Pattern Card: Question Board (NEW)
          _PatternMenuCard(
            title: AppLocalizations.of(context)!.boardQuestionTitle,
            subtitle: AppLocalizations.of(context)!.boardQuestionSubtitle,
            color: const Color(0xFFF3E5F5), // Purple[50]
            patternColor: Colors.purple.withOpacity(0.15),
            patternIcons: const [
              Icons.help_outline,
              Icons.question_answer,
              Icons.live_help,
              Icons.school,
              Icons.emoji_people,
            ],
            characterAsset: 'assets/images/community_QnA.png',
            imageHeight: 145,
            imageRightOffset: 35,
            imageBottomOffset: 0,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuestionBoardScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          // Simple Card: Info Board
          _PatternMenuCard(
            title: AppLocalizations.of(context)!.boardInfoTitle,
            subtitle: AppLocalizations.of(context)!.boardInfoSubtitle,
            color: const Color(0xFFFFF9C4), // Yellow[100]
            patternColor: const Color(0xFFFBC02D).withOpacity(0.1),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InfoBoardScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          // Simple Card: Second-hand Market
          _PatternMenuCard(
            title: AppLocalizations.of(context)!.boardMarketTitle,
            subtitle: AppLocalizations.of(context)!.boardMarketSubtitle,
            color: const Color(0xFFE8F5E9), // Green[50]
            patternColor: const Color(0xFF388E3C).withOpacity(0.1),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UsedMarketScreen()),
              );
            },
          ),
          const SizedBox(height: 24),
          // Create Board Button
          _SimpleMenuCard(
            title: AppLocalizations.of(context)!.boardCreateTitle,
            subtitle: AppLocalizations.of(context)!.boardCreateSubtitle,
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
        title: Text(AppLocalizations.of(context)!.boardCreateTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(AppLocalizations.of(context)!.msgCreateBoardDialog),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Colors.grey)), 
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.msgApplySuccess)),
              );
            },
            child: Text(AppLocalizations.of(context)!.btnApply, style: const TextStyle(fontWeight: FontWeight.bold)),
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
  final String? characterAsset;
  final Widget? customTrailing; // New: Optional custom widget
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
    this.characterAsset,
    required this.onTap,
    this.customTrailing,
    this.imageHeight = 130,     // Default height
    this.imageRightOffset = 10, // Default right margin
    this.imageBottomOffset = -10,
    this.cardHeight = 160,      // Default card height
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
              color: Colors.black.withOpacity(0.05),
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
                  child: customTrailing ?? Image.asset(
                    characterAsset!,
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
              color: Colors.black.withOpacity(0.03),
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
                color: Colors.white.withOpacity(0.6),
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
