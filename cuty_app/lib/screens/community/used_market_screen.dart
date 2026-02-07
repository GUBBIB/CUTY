import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/gen/app_localizations.dart'; // UPDATED
import 'package:cuty_app/utils/localization_utils.dart'; // ADDED
import '../../models/community_model.dart';
import '../../data/community_data_manager.dart'; // Import Manager
import 'post_write_screen.dart';
import 'post_detail_screen.dart';

class UsedMarketScreen extends StatefulWidget {
  const UsedMarketScreen({super.key});

  @override
  State<UsedMarketScreen> createState() => _UsedMarketScreenState();
}

class _UsedMarketScreenState extends State<UsedMarketScreen> {
  // Filter state
  int _selectedFilterIndex = 0;


  @override
  Widget build(BuildContext context) {
    // Localized Filters
    final List<String> filters = [
      AppLocalizations.of(context)!.filterAll,
      AppLocalizations.of(context)!.filterSell,
      AppLocalizations.of(context)!.filterShare,
      AppLocalizations.of(context)!.filterRequest,
    ];

    // Centralized Data from Manager
    final List<Post> posts = CommunityDataManager.getPosts(BoardType.market);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.boardMarket,
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
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
               border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(filters.length, (index) {
                  final isSelected = _selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filters[index],
                        style: GoogleFonts.notoSansKr(
                          fontSize: 13,
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Post List
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: posts.length,
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 1, color: Colors.grey[100]),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                     Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => PostDetailScreen(post: posts[index])),
                    );
                  },
                  child: _buildUnifiedListItem(context, posts[index]),
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
              builder: (context) => const PostWriteScreen(boardType: BoardType.market),
            ),
          );

          if (result == true) {
            setState(() {});
          }
        },
        backgroundColor: Colors.green[600],
        shape: const CircleBorder(),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildUnifiedListItem(BuildContext context, Post post) {
    bool hasImage = post.imageUrl != null;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Thumbnail (Left Side) - Mandatory
              Stack(
                children: [
                   ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: hasImage ? Image.network(
                      post.imageUrl!,
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 84,
                        height: 84,
                        color: Colors.grey[200],
                        child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                      ),
                    ) : Container(
                      width: 84,
                      height: 84,
                      color: Colors.grey[200],
                      child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                    ),
                  ),
                  // Status Overlay (e.g., Sold Out, Reserved)
                  if (post.status != null && post.status != '판매중' && post.status != '구하는중')
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            post.status!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // 2. Text Info (Right Side)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                    // Price (Functionally replaces Content)
                    Text(
                      "${_formatPrice(context, post.price)}원",
                      style: GoogleFonts.notoSansKr(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Metadata
                    Row(
                      children: [
                        Text(
                          post.authorName,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " · ${LocalizationUtils.getTimeAgo(context, post.createdAt)}",
                          style: GoogleFonts.notoSansKr(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 8),
                         Icon(Icons.favorite_border, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 2),
                        Text(
                          '${post.likeCount}',
                          style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.grey[500]),
                        ),
                        const SizedBox(width: 8),
                         Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 2),
                        Text(
                          '${post.commentCount}',
                          style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatPrice(BuildContext context, int price) {
    if (price == 0) return AppLocalizations.of(context)!.priceFree;
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (Match m) => '${m[1]},'
    );
  }
}
