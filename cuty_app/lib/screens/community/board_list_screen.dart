import 'package:flutter/material.dart';
import '../../models/community_model.dart'; // Consolidated model
import '../../data/community_data_manager.dart'; // Centralized Manager
import 'widgets/community_post_item.dart';
import 'post_write_screen.dart';
import 'post_detail_screen.dart';

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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
        itemBuilder: (context, index) {
          final post = posts[index];
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
