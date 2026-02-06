import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/community_model.dart';
import '../../data/community_data_manager.dart';

class PostWriteScreen extends StatefulWidget {
  final BoardType boardType;

  const PostWriteScreen({
    super.key,
    required this.boardType,
  });

  @override
  State<PostWriteScreen> createState() => _PostWriteScreenState();
}

class _PostWriteScreenState extends State<PostWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _priceController = TextEditingController(); // For Market
  
  // Mock Image List
  final List<String> _selectedImages = []; 

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          '${widget.boardType.label} 글쓰기',
          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () {
                if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
                  return; // Simple validation
                }

                // Create new Post
                final newPost = Post(
                  id: DateTime.now().toString(),
                  boardType: widget.boardType,
                  title: _titleController.text,
                  content: _contentController.text,
                  authorName: '나', // Default user
                  authorSchool: '본부', // Default school
                  authorNationality: 'KR', // Default flag
                  // timeAgo is calculated dynamically
                  likeCount: 0,
                  commentCount: 0,
                  imageUrl: null, // Image uploading not implemented yet
                  price: _priceController.text.isNotEmpty ? int.tryParse(_priceController.text.replaceAll(',', '')) ?? 0 : 0,
                  status: widget.boardType == BoardType.market ? '판매중' : null,
                  createdAt: DateTime.now(), // Set current time
                );

                // Add to Manager
                CommunityDataManager.addPost(newPost);

                // Return with refresh signal
                Navigator.pop(context, true);
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFFF6F61),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                '등록',
                style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // [Type Specific]: Info Board (Image Top)
            if (widget.boardType == BoardType.info) ...[
              _buildImageUploadArea(isLarge: true),
              const SizedBox(height: 24),
            ],

            // 1. Title Input
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: '제목을 입력하세요',
                hintStyle: GoogleFonts.notoSansKr(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: GoogleFonts.notoSansKr(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
            const Divider(),

            // [Type Specific]: Market (Price Input)
            if (widget.boardType == BoardType.market) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '₩ ',
                  prefixStyle: GoogleFonts.notoSansKr(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  hintText: '가격 입력 (선택)',
                  hintStyle: GoogleFonts.notoSansKr(color: Colors.grey[400]),
                  border: InputBorder.none,
                ),
                style: GoogleFonts.notoSansKr(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xFFFF6F61), // Coral Color for Price
                ),
              ),
              const Divider(),
            ],

            // 2. Content Input
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 200),
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: _getContentHint(),
                  hintStyle: GoogleFonts.notoSansKr(color: Colors.grey[400], fontSize: 16),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: GoogleFonts.notoSansKr(fontSize: 16, height: 1.5),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
            
            // [Type Specific]: Image Upload (Standard Position)
            if (widget.boardType != BoardType.info) ...[
              const SizedBox(height: 20),
              _buildImageUploadArea(isLarge: false),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadArea({required bool isLarge}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Camera Button
          GestureDetector(
            onTap: () {
              // TODO: Implement Image Picker
            },
            child: Container(
              width: isLarge ? 100 : 70,
              height: isLarge ? 100 : 70,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: Colors.grey[500]),
                  Text(
                    '0/10',
                    style: GoogleFonts.notoSansKr(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Placeholder for selected images
        ],
      ),
    );
  }

  String _getContentHint() {
    switch (widget.boardType) {
      case BoardType.market:
        return '판매할 상품의 자세한 설명을 적어주세요.\n(거래 금지 품목은 ❌)';
      case BoardType.info:
        return '공유하고 싶은 꿀팁이나 정보를 자세히 적어주세요.';
      default: // Free, Secret
        return '내용을 입력하세요.\n부적절한 게시글은 제재될 수 있습니다.';
    }
  }
}
