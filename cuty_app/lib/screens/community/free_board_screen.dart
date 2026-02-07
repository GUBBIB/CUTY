import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/gen/app_localizations.dart'; // UPDATED
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/community_post_item.dart' as widgets;
import '../../models/community_model.dart';
import '../../data/community_data_manager.dart'; // import Manager
import 'post_write_screen.dart';
import 'post_detail_screen.dart';
import '../../widgets/ads/main_ad_banner.dart'; // NEW
import '../../widgets/ads/native_ad_item.dart'; // NEW

class FreeBoardScreen extends ConsumerStatefulWidget {
  const FreeBoardScreen({super.key});

  @override
  ConsumerState<FreeBoardScreen> createState() => _FreeBoardScreenState();
}

class _FreeBoardScreenState extends ConsumerState<FreeBoardScreen> {
  // Filter state
  final int _selectedFilterIndex = 0;
  @override
  Widget build(BuildContext context) {
    // Localized Filters
    final List<String> filters = [
      AppLocalizations.of(context)!.filterAll,
      AppLocalizations.of(context)!.filterChat,
      AppLocalizations.of(context)!.filterQuestion,
      AppLocalizations.of(context)!.filterInfo,
      AppLocalizations.of(context)!.filterReview,
    ];

    // Centralized Data
    final List<Post> posts = CommunityDataManager.getPosts(BoardType.free);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.boardFree,
          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold),
        ),
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
          const MainAdBanner(boardType: BoardType.free),
          
          // Post List (with Native Ads)
          Expanded(
            child: ListView.separated(
              itemCount: posts.length + (posts.length ~/ 5), // posts + ads
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 1, color: Colors.grey[100]),
              itemBuilder: (context, index) {
                // Ad Logic: Every 6th item (index 5, 11...) is an Ad
                if ((index + 1) % 6 == 0) {
                  return const NativeAdItem(boardType: BoardType.free);
                }

                // Map list index to post index
                final adCount = index ~/ 6;
                final postIndex = index - adCount;

                if (postIndex >= posts.length) return const SizedBox.shrink();

                final post = posts[postIndex];
                return InkWell(
                  onTap: () {
                     Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
                    );
                  },
                  child: widgets.CommunityPostItem(post: post),
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
              builder: (context) => const PostWriteScreen(boardType: BoardType.free),
            ),
          );

          if (result == true) {
             setState(() {});
          }
        },
        backgroundColor: Colors.blue[600],
        shape: const CircleBorder(),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}
