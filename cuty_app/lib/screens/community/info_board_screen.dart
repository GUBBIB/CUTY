import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/community_post_item.dart'; // Import shared widget
import 'info_board_detail_screen.dart';
import '../../models/community_model.dart';
import '../../data/community_data_manager.dart'; // Import Manager
import 'post_write_screen.dart';
import 'post_detail_screen.dart';

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
        title: const Text('정보 공유', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
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
                   _buildFilterChip("전체", isSelected: true),
                   _buildFilterChip("비자"),
                   _buildFilterChip("생활"),
                   _buildFilterChip("맛집"),
                   _buildFilterChip("꿀팁"),
                ],
              ),
             ),
          ),

          // List
          Expanded(
            child: ListView.separated(
              itemCount: infoPosts.length,
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 1, color: Colors.grey[100]),
              itemBuilder: (context, index) {
                 final post = infoPosts[index];
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
