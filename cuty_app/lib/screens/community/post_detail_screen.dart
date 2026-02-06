import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/community_model.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          post.boardType.label,
          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: User Info
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        radius: 20,
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.authorName, // Updated
                            style: GoogleFonts.notoSansKr(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            post.timeAgo, // Updated
                            style: GoogleFonts.notoSansKr(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    post.title, // Updated
                    style: GoogleFonts.notoSansKr(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),

                   // [Market] Price Display
                  if (post.boardType == BoardType.market && post.price > 0) ...[
                    Text(
                      '${_formatPrice(post.price)}원',
                      style: GoogleFonts.notoSansKr(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Content
                  Text(
                    post.content, // Updated
                    style: GoogleFonts.notoSansKr(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Images (if any)
                  if (post.imageUrl != null && post.imageUrl != 'placeholder')
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        post.imageUrl!, // Updated
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Like Button Area
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(CupertinoIcons.heart, color: Colors.redAccent, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            '${post.likeCount}', // Updated
                            style: GoogleFonts.notoSansKr(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(thickness: 1, color: Color(0xFFF5F5F5)),

                  // Comments Section (Mock)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3, // Mock comments
                    separatorBuilder: (context, index) => const Divider(color: Color(0xFFF5F5F5)),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             CircleAvatar(
                                backgroundColor: Colors.grey[100],
                                radius: 14,
                                child: const Icon(Icons.person, color: Colors.grey, size: 16),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '익명 ${index + 1}',
                                          style: GoogleFonts.notoSansKr(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '방금 전',
                                          style: GoogleFonts.notoSansKr(
                                            fontSize: 11,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '좋은 정보 감사합니다!',
                                      style: GoogleFonts.notoSansKr(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Comment Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '댓글을 입력하세요...',
                        style: GoogleFonts.notoSansKr(color: Colors.grey[500], fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(CupertinoIcons.paperplane_fill, color: Color(0xFFFF6F61)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (Match m) => '${m[1]},'
    );
  }
}
