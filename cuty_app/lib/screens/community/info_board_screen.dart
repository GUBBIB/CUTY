import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/gen/app_localizations.dart'; // UPDATED
import 'widgets/community_post_item.dart'; // Import shared widget
import '../../models/community_model.dart';
import '../../data/community_data_manager.dart'; // Import Manager
import 'post_write_screen.dart';
import 'post_detail_screen.dart';
import '../../widgets/ads/main_ad_banner.dart'; // NEW
import '../../widgets/ads/native_ad_item.dart'; // NEW

class InfoBoardScreen extends StatefulWidget {
  const InfoBoardScreen({super.key});

  @override
  State<InfoBoardScreen> createState() => _InfoBoardScreenState();
}

class _InfoBoardScreenState extends State<InfoBoardScreen> {
  @override
  Widget build(BuildContext context) {
    // Centralized Data from Manager
    final List<Post> infoPosts = CommunityDataManager.getPosts(BoardType.info);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.boardInfo, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Main Banner
          const MainAdBanner(boardType: BoardType.info),

          // Filter Section
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
             decoration: const BoxDecoration(
               border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
             ),
             child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                   _buildFilterChip(AppLocalizations.of(context)!.filterAll, isSelected: true),
                   _buildFilterChip(AppLocalizations.of(context)!.filterVisa),
                   _buildFilterChip(AppLocalizations.of(context)!.filterLife),
                   _buildFilterChip(AppLocalizations.of(context)!.filterFood),
                   _buildFilterChip(AppLocalizations.of(context)!.filterTips),
                ],
              ),
             ),
          ),

          // List (with Native Ads)
          Expanded(
            child: ListView.separated(
              itemCount: infoPosts.length + (infoPosts.length ~/ 5), // posts + ads
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 1, color: Colors.grey[100]),
              itemBuilder: (context, index) {
                 // Ad Logic
                 if ((index + 1) % 6 == 0) {
                   return const NativeAdItem(boardType: BoardType.info);
                 }

                 final adCount = index ~/ 6;
                 final postIndex = index - adCount;

                 if (postIndex >= infoPosts.length) return const SizedBox.shrink();

                 final post = infoPosts[postIndex];
                 return InkWell(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
                      );
                    },
                    child: CommunityPostItem(
                      post: post,
                      showBoardName: true,
                      contentMaxLines: 2,
                    ),
                 );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostWriteScreen(boardType: BoardType.info),
            ),
          );

          if (result == true) {
            setState(() {});
          }
        },
        backgroundColor: Colors.amber[600],
        shape: const CircleBorder(),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

    // --- Helper Widgets ---

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.notoSansKr(
          fontSize: 13,
          color: isSelected ? Colors.white : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
