import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/gen/app_localizations.dart'; // UPDATED
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/community_post_item.dart' as widgets;
import '../../widgets/ads/main_ad_banner.dart'; // NEW
import '../../models/community_model.dart';
import '../../data/community_data_manager.dart'; 
import 'post_write_screen.dart';
import 'post_detail_screen.dart';

class QuestionBoardScreen extends ConsumerStatefulWidget {
  const QuestionBoardScreen({super.key});

  @override
  ConsumerState<QuestionBoardScreen> createState() => _QuestionBoardScreenState();
}

class _QuestionBoardScreenState extends ConsumerState<QuestionBoardScreen> {
  @override
  Widget build(BuildContext context) {
    // Centralized Data for Question Board
    final List<Post> posts = CommunityDataManager.getPosts(BoardType.question);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.boardQuestion,
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
          const MainAdBanner(boardType: BoardType.question),

          // Post List
          Expanded(
            child: posts.isEmpty 
            ? Center(child: Text(AppLocalizations.of(context)!.msgNoQuestions, style: GoogleFonts.notoSansKr(color: Colors.grey)))
            : ListView.separated(
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
              builder: (context) => const PostWriteScreen(boardType: BoardType.question),
            ),
          );

          if (result == true) {
             setState(() {});
          }
        },
        backgroundColor: Colors.purple[600], // Purple for Question
        shape: const CircleBorder(),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}
