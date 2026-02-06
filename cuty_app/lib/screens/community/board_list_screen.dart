import 'package:flutter/material.dart';
import '../../models/community_model.dart'; // Consolidated model
import '../../data/community_data_manager.dart'; // Centralized Manager
import 'widgets/community_post_item.dart';
import 'post_write_screen.dart';
import 'post_detail_screen.dart';
import '../../widgets/ads/main_ad_banner.dart'; // NEW
import '../../widgets/ads/native_ad_item.dart'; // NEW

class BoardListScreen extends StatefulWidget {
  final String title;
  final BoardType boardType;

  const BoardListScreen({
    super.key, 
    required this.title,
    required this.boardType,
  });

  @override
  State<BoardListScreen> createState() => _BoardListScreenState();
}

class _BoardListScreenState extends State<BoardListScreen> {
  @override
  Widget build(BuildContext context) {
    // Fetch data from centralized store (dynamically to support refresh)
    final List<Post> posts = CommunityDataManager.getPosts(widget.boardType);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search), 
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('검색 (Mock)')));
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. Top Banner (Fixed)
          const MainAdBanner(),

          // 2. Post List with Native Ads
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80), // Bottom padding for FAB
              itemCount: posts.length + (posts.length ~/ 5), // posts + ads count
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                // Determine if this slot is for an Ad
                // Pattern: P P P P P A P P P P P A ... (5 Posts, 1 Ad) -> Period 6
                if ((index + 1) % 6 == 0) {
                  return const NativeAdItem();
                }

                // Map list index to post index
                // Deduct the number of ads that appeared before this index
                final adCount = index ~/ 6;
                final postIndex = index - adCount;

                // Safety check
                if (postIndex >= posts.length) return const SizedBox.shrink();

                final post = posts[postIndex];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
                    );
                  },
                  child: CommunityPostItem(
                    post: post,
                    showBoardName: false,
                    contentMaxLines: 2,
                    showMetadata: true,
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
              builder: (context) => PostWriteScreen(boardType: widget.boardType),
            ),
          );

          if (result == true) {
            setState(() {}); // Refresh list
          }
        },
        backgroundColor: widget.boardType.color,
        shape: const CircleBorder(),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}
