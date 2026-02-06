
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/community_post_item.dart'; // Import shared widget
import '../../models/community_model.dart'; // Centralized model
import '../../data/community_data_manager.dart'; // Centralized Manager
import 'post_detail_screen.dart';

class PopularPostsScreen extends StatelessWidget {
  const PopularPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch Data from Centralized Store
    final List<Post> popularPosts = CommunityDataManager.getPopularPosts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔥 실시간 인기글', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: const Color(0xFFFFF3E0), // Light Orange
            child: Row(
              children: [
                const Icon(Icons.emoji_events_rounded, color: Color(0xFFFF6F00), size: 24),
                const SizedBox(width: 12),
                Text(
                  '지금 학교에서 가장 핫한 이야기! 🏆',
                  style: GoogleFonts.notoSansKr(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE65100),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // List
          Expanded(
            child: ListView.separated(
              itemCount: popularPosts.length,
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 1, color: Colors.grey[100]),
              itemBuilder: (context, index) {
                final post = popularPosts[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
                    );
                  },
                  child: CommunityPostItem(
                     post: post,
                     rankingIndex: index + 1,
                     showBoardName: true,
                     contentMaxLines: 2,
                     showMetadata: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

