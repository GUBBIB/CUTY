import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/user_provider.dart';

class CommunityPostItem extends ConsumerWidget {
  final Map<String, dynamic> post;
  final int? rankingIndex; // Optional: 1, 2, 3...
  final bool showBoardName; // Optional: Show '자유게시판' etc.
  final int contentMaxLines; // Default 2, use 1 for compact cards
  final bool showMetadata; // Default true, set false for minimal Home cards
  
  const CommunityPostItem({
    super.key, 
    required this.post,
    this.rankingIndex,
    this.showBoardName = false,
    this.contentMaxLines = 2,
    this.showMetadata = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool hasImage = post['imageUrl'] != null;

    // Privacy Logic
    final user = ref.watch(userProvider);
    final bool isNicknameHidden = user?.isNicknameHidden ?? false;
    final bool isNationalityHidden = user?.isNationalityHidden ?? false;
    final bool isSchoolHidden = user?.isSchoolHidden ?? false;

    // Apply Masking
    final String displayAuthor = isNicknameHidden ? '익명' : post['author'];
    final String displayFlag = isNationalityHidden ? '🔒' : post['flag'] ?? '';
    final String displayUni = isSchoolHidden ? '비공개' : post['uni'] ?? '';

    // Layout Mode: If compact (Home Card), use Max/SpaceBetween to pin footer.
    final bool isCompact = contentMaxLines == 1;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Standard padding
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 80), // Minimum height for cleaner layout
        child: IntrinsicHeight( // Key: Forces both columns to same height
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Key: Stretch children vertical
            children: [
              // 0. Ranking Badge
              if (rankingIndex != null) ...[
                Center( // Center vertically since Row is stretched
                  child: SizedBox(
                    width: 24,
                    child: Text(
                      '$rankingIndex',
                      style: GoogleFonts.notoSansKr(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: rankingIndex! <= 3 ? const Color(0xFFFFA000) : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],

              // 1. Left Feature: Text & Author Info (Expanded)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Board Badge
                        if (showBoardName && post['board'] != null) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getBoardColor(post['board']), // Dynamic Color
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              post['board'],
                              style: GoogleFonts.notoSansKr(
                                fontSize: 10,
                                color: _getBoardTextColor(post['board']), // Dynamic Text Color
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],

                        // Title
                        Text(
                          post['title'],
                          style: GoogleFonts.notoSansKr(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // Content
                        Text(
                          post['content'],
                          style: GoogleFonts.notoSansKr(
                            fontSize: 14, // Increased to 14sp
                            color: Colors.grey[600],
                          ),
                          maxLines: contentMaxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // Footer: Author/Badges/Time (Bottom of Left Column)
                    if (showMetadata)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                displayAuthor,
                                style: GoogleFonts.notoSansKr(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (displayFlag.isNotEmpty) ...[
                              _buildBadge(displayFlag),
                              const SizedBox(width: 4),
                            ],
                            if (displayUni.isNotEmpty) ...[
                              _buildBadge(displayUni),
                              const SizedBox(width: 6),
                            ],
                            // TimeAgo
                            Text(
                              '• 10분 전', // Mock Time
                              style: GoogleFonts.notoSansKr(
                                fontSize: 11,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 12), // Gap between Left & Right

              // 2. Right Feature: Image & Stats (Fixed)
              Column(
                // mainAxisAlignment: spaceBetween is redundant inside IntrinsicHeight if we use Expanded
                crossAxisAlignment: CrossAxisAlignment.end, // Align right
                children: [
                  // Thumbnail (Centered in available space)
                   if (hasImage) ...[
                    Expanded(
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: post['imageUrl'] == 'placeholder' 
                            ? Container( // Grey Box Placeholder
                                width: 64,
                                height: 64,
                                color: const Color(0xFFEEEEEE), // Light Grey
                                child: const Icon(Icons.image, color: Colors.grey, size: 24),
                              )
                            : Image.network(
                                post['imageUrl'],
                                width: 64, // 64x64 Thumbnail
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 64,
                                  height: 64,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 20),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ] else ... [
                     const Spacer(), // Pushes stats to bottom if no image
                  ],

                  // Stats Row (Likes/Comments) - Pushed to bottom
                  if (showMetadata)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.heart_fill, size: 14, color: Colors.redAccent),
                        const SizedBox(width: 2),
                        Text(
                          '${post['likes']}',
                          style: GoogleFonts.notoSansKr(fontSize: 11, color: Colors.redAccent, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8), // Gap
                        const Icon(CupertinoIcons.chat_bubble_2_fill, size: 14, color: Colors.blueAccent),
                        const SizedBox(width: 2),
                        Text(
                          '${post['comments']}',
                          style: GoogleFonts.notoSansKr(fontSize: 11, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // 3. Compact Padding
      decoration: BoxDecoration(
        color: Colors.grey[100], // Grey 100
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.notoSansKr(
          fontSize: 11, // 10-11sp
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getBoardColor(String boardName) {
    switch (boardName) {
      case '자유게시판':
        return const Color(0xFFE3F0FF); // Pastel Blue
      case '정보게시판':
        return const Color(0xFFFFF8D6); // Cream Yellow
      case '중고장터':
        return const Color(0xFFE6F5EA); // Mint Green
      default:
        return const Color(0xFFF5F5F5); // Default Grey
    }
  }

  Color _getBoardTextColor(String boardName) {
     switch (boardName) {
      case '자유게시판':
        return const Color(0xFF0056B3); // Deep Blue
      case '정보게시판':
        return const Color(0xFFE65100); // Deep Orange
      case '중고장터':
        return const Color(0xFF1B5E20); // Deep Green
      default:
        return Colors.grey[700]!; // Default Grey Text
    }
  }
}
