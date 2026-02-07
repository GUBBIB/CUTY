import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../community/community_main_screen.dart';
import '../../community/widgets/community_post_item.dart';
import '../../community/post_detail_screen.dart';
import '../../../models/community_model.dart'; // Centralized model
import '../../../data/community_data_manager.dart'; // Centralized data

class PopularPostsPreview extends StatelessWidget {
  const PopularPostsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    // Top 5 Popular Posts from Manager
    final List<Post> popularPosts = CommunityDataManager.getPopularPosts();

    if (popularPosts.isEmpty) return const SizedBox.shrink(); // Hide if emptyh: double.infinity, // Key: Full Width
    return Container(
      width: double.infinity, // Key: Full Width
      margin: EdgeInsets.zero, // Key: No Margins
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 5), // Reduced bottom padding
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // Key: Top Radius Only
      ),
      child: SafeArea(
        top: false, 
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.lblCommunityPreview,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 15, // Reduced from 16
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CommunityMainScreen()),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.btnMore, 
                      style: GoogleFonts.notoSansKr(
                        fontSize: 11, // Reduced from 12
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8), // Standard gap
            // Horizontal List
            // Top 3 Popular Posts (Horizontal Card List)
            Builder(
              builder: (context) {
                // Centralized Data retrieval
                final List<Post> popularPosts = CommunityDataManager.getPopularPosts().take(3).toList(); // Show top 3 in preview

                return SizedBox(
                  height: 135, // Reduced height for tighter layout
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), // Vertical padding for shadow
                    itemCount: popularPosts.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final post = popularPosts[index];
                      return GestureDetector(
                        onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
                          );
                        },
                        child: Container(
                          width: 300, // Fixed width card
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: const Color(0xFFF5F5F5)),
                          ),
                          // Clip behavior for clean corners
                          clipBehavior: Clip.hardEdge,
                          child: CommunityPostItem(
                            post: post,
                            rankingIndex: index + 1,
                            showBoardName: true,
                            contentMaxLines: 2, // Increased textual content space
                            showMetadata: false, // Minimal design (Preview Only: Title/Content/Image)
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
