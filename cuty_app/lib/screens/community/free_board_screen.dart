import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import 'widgets/community_post_item.dart' as widgets;
import '../../models/community_model.dart';
import '../../data/community_data_manager.dart'; // import Manager
import 'post_write_screen.dart';
import 'post_detail_screen.dart';

class FreeBoardScreen extends ConsumerStatefulWidget {
  const FreeBoardScreen({super.key});

  @override
  ConsumerState<FreeBoardScreen> createState() => _FreeBoardScreenState();
}

class _FreeBoardScreenState extends ConsumerState<FreeBoardScreen> {
  // Filter state
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['전체', '잡담', '질문', '정보', '후기'];

  @override
  Widget build(BuildContext context) {
    // Centralized Data
    final List<Post> posts = CommunityDataManager.getPosts(BoardType.free);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '자유게시판',
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
          // Post List
          Expanded(
            child: ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 1, color: Colors.grey[100]),
              itemBuilder: (context, index) {
                final post = posts[index];
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
