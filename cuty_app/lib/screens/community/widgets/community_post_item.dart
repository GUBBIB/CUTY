import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/user_provider.dart';
import 'package:cuty_app/utils/localization_utils.dart'; // NEW
import '../../../models/community_model.dart';

class CommunityPostItem extends ConsumerWidget {
  final Post post;
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
    bool hasImage = post.imageUrl != null;

    // Privacy Logic
    final user = ref.watch(userProvider);
    final bool isNicknameHidden = user?.isNicknameHidden ?? false;
    final bool isNationalityHidden = user?.isNationalityHidden ?? false;
    final bool isSchoolHidden = user?.isSchoolHidden ?? false;

    // Apply Masking
    final String displayAuthor = isNicknameHidden ? '익명' : post.authorName;
    final String displayFlag = isNationalityHidden ? '🔒' : post.authorNationality;
    final String displayUni = isSchoolHidden ? '비공개' : post.authorSchool;

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
                        if (showBoardName) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: post.boardType.color.withOpacity(0.1), // Unified Logic
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              post.boardType.label,
                              style: GoogleFonts.notoSansKr(
                                fontSize: 10,
                                color: post.boardType.color, // Unified Logic
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],

                        // Question Reward Badge
                        if (post.boardType == BoardType.question && post.rewardPoints > 0) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF176), // Yellow[300]
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('💰 ', style: TextStyle(fontSize: 10)),
                                Text(
                                  '${post.rewardPoints}P',
                                  style: GoogleFonts.notoSansKr(
                                    fontSize: 11,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        
                        // Title
                        Text(
                          post.title,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // Content (or Price for Market)
                        Text(
                          post.boardType == BoardType.market && post.price > 0 
                              ? '${post.price}원' 
                              : post.content,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 14, 
                            color: post.boardType == BoardType.market 
                                ? Colors.black 
                                : Colors.grey[600],
                            fontWeight: post.boardType == BoardType.market 
                                ? FontWeight.bold 
                                : FontWeight.normal,
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
                              '• ${LocalizationUtils.getTimeAgo(context, post.createdAt)}', 
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
                          child: post.imageUrl == 'placeholder' 
                            ? Container( // Grey Box Placeholder
                                width: 64,
                                height: 64,
                                color: const Color(0xFFEEEEEE), // Light Grey
                                child: const Icon(Icons.image, color: Colors.grey, size: 24),
                              )
                            : Image.network(
                                post.imageUrl!,
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
                          '${post.likeCount}',
                          style: GoogleFonts.notoSansKr(fontSize: 11, color: Colors.redAccent, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8), // Gap
                        const Icon(CupertinoIcons.chat_bubble_2_fill, size: 14, color: Colors.blueAccent),
                        const SizedBox(width: 2),
                        Text(
                          '${post.commentCount}',
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
}
