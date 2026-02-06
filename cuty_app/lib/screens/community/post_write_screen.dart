import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/community_model.dart';
import '../../data/community_data_manager.dart';
import '../../providers/user_provider.dart';
import '../../providers/point_provider.dart'; // Shop Points

class PostWriteScreen extends ConsumerStatefulWidget {
  final BoardType boardType;

  const PostWriteScreen({
    super.key,
    required this.boardType,
  });

  @override
  ConsumerState<PostWriteScreen> createState() => _PostWriteScreenState();
}

class _PostWriteScreenState extends ConsumerState<PostWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _priceController = TextEditingController(); // For Market
  
  // Mock Image List for Preview
  final List<String> _selectedImages = []; 

  // State for Info Board
  bool _isCardNewsMode = false;
  bool _isAnonymous = false;
  int _selectedRewardPoints = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // --- Actions ---
  void _submitPost() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 내용을 입력해주세요.')),
      );
      return; 
    }

    // Create new Post
    final newPost = Post(
      id: DateTime.now().toString(),
      boardType: widget.boardType,
      title: _titleController.text,
      content: _contentController.text,
      authorName: _isAnonymous ? '익명' : '나', // Reflect Anonymous toggle
      authorSchool: '본부', 
      authorNationality: 'KR', 
      likeCount: 0,
      commentCount: 0,
      imageUrl: _selectedImages.isNotEmpty ? _selectedImages.first : null,
      price: _priceController.text.isNotEmpty ? int.tryParse(_priceController.text.replaceAll(',', '')) ?? 0 : 0,
      rewardPoints: _selectedRewardPoints,
      status: widget.boardType == BoardType.market ? '판매중' : null,
      createdAt: DateTime.now(),
    );

    // Deduct Points (If Betting)
    if (_selectedRewardPoints > 0) {
      final success = ref.read(pointProvider.notifier).usePoints(_selectedRewardPoints, '질문 채택 포인트');
      if (!success) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('포인트 사용 중 오류가 발생했습니다.')),
        );
        return;
      }
    }

    // Add to Manager
    CommunityDataManager.addPost(newPost);

    // Return with refresh signal
    Navigator.pop(context, true);
  }

  void _pickImage() {
    // Mock Image Picking
    setState(() {
      if (_selectedImages.length < 10) {
        _selectedImages.add('https://source.unsplash.com/random/200x200/?sig=${DateTime.now().millisecondsSinceEpoch}');
      }
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.boardType.label} 글쓰기',
          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _submitPost,
              child: Text(
                '완료',
                style: GoogleFonts.notoSansKr(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: widget.boardType.color,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Title Input
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: '제목',
              hintStyle: GoogleFonts.notoSansKr(
                color: Colors.grey[400],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            style: GoogleFonts.notoSansKr(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            textInputAction: TextInputAction.next,
          ),
          
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // 2. [Optional] Info Board Mode Toggle
          if (widget.boardType == BoardType.info) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildModeToggleButton(label: '📝 일반 글', isSelected: !_isCardNewsMode, onTap: () => setState(() => _isCardNewsMode = false)),
                  const SizedBox(width: 8),
                  _buildModeToggleButton(label: '🖼️ 카드뉴스', isSelected: _isCardNewsMode, onTap: () => setState(() => _isCardNewsMode = true)),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          ],

          // 2-1. [Card News Mode] Top Image Upload Area
          if (widget.boardType == BoardType.info && _isCardNewsMode) ...[
            Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[50],
              child: _selectedImages.isEmpty 
                  ? Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, color: Colors.grey[600], size: 28),
                              const SizedBox(height: 4),
                              Text("카드뉴스 사진 추가", style: GoogleFonts.notoSansKr(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length + 1,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        if (index == _selectedImages.length) {
                          // Add Button (End of list)
                          return GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 96,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: const Center(child: Icon(Icons.add, color: Colors.grey)),
                            ),
                          );
                        }
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(_selectedImages[index], width: 96, height: 96, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(Icons.close, size: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          ],

          // 3. [Optional] Point Betting (Question Board Only)
          if (widget.boardType == BoardType.question) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '포인트 걸기', 
                        style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      // Real User Points Linking (Shop Points)
                      Text(
                        '보유 포인트: ${(ref.watch(pointProvider).totalBalance).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}P', 
                        style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [0, 50, 100, 500].map((points) {
                      final isSelected = _selectedRewardPoints == points;
                      return ChoiceChip(
                        label: Text(
                          points == 0 ? '없음' : '${points}P',
                          style: GoogleFonts.notoSansKr(
                            fontSize: 13,
                             color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            final currentPoints = ref.read(pointProvider).totalBalance;
                            if (points > currentPoints) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('보유 포인트가 부족합니다.')),
                              );
                              return;
                            }
                            setState(() => _selectedRewardPoints = points);
                          }
                        },
                        selectedColor: Colors.purple[400],
                        backgroundColor: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey[300]!),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          ],

          // 3. [Optional] Price Input (Market Only)
          if (widget.boardType == BoardType.market) ...[
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.attach_money, color: Colors.grey, size: 20),
                hintText: '가격 (선택)',
                hintStyle: GoogleFonts.notoSansKr(color: Colors.grey[400], fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: GoogleFonts.notoSansKr(
                 fontSize: 16, 
                 fontWeight: FontWeight.bold, 
                 color: const Color(0xFFFF6F61)
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          ],

          // 4. Content Input (Expanded)
          Expanded(
            child: TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: _getContentHint(),
                hintStyle: GoogleFonts.notoSansKr(color: Colors.grey[400], fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              style: GoogleFonts.notoSansKr(fontSize: 16, height: 1.5),
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
            ),
          ),

          // 5. Image Preview (Bottom - Normal Mode Only)
          if (!_isCardNewsMode && _selectedImages.isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _selectedImages[index],
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                            Container(width: 64, height: 64, color: Colors.grey[200]),
                        ),
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: const Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

          // 6. Bottom Toolbar
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Camera Button (Hidden in Card News Mode)
                  if (!_isCardNewsMode) ...[
                    IconButton(
                      onPressed: _pickImage,
                      icon: Icon(Icons.camera_alt_outlined, color: widget.boardType.color),
                    ),
                    const SizedBox(width: 8),
                  ],
                  
                  // Anonymous Checkbox
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isAnonymous = !_isAnonymous;
                      });
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _isAnonymous,
                              onChanged: (value) {
                                setState(() {
                                  _isAnonymous = value ?? false;
                                });
                              },
                              activeColor: Colors.grey[800],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '익명',
                            style: GoogleFonts.notoSansKr(
                              color: _isAnonymous ? Colors.black : Colors.grey[500],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggleButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber[100] : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.amber[200]! : Colors.transparent),
        ),
        child: Text(
          label,
          style: GoogleFonts.notoSansKr(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
            color: isSelected ? Colors.brown[800] : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  String _getContentHint() {
    if (widget.boardType == BoardType.info && _isCardNewsMode) {
      return '카드뉴스에 대한 설명을 적어주세요.';
    }
    switch (widget.boardType) {
      case BoardType.market:

        return '판매할 상품의 상세 정보를 입력하세요.\n(물품 상태, 거래 장소 등)';
      case BoardType.info:
        return '함께 나누고 싶은 유용한 정보를 입력하세요.';
      default:
        return '내용을 입력하세요.\n\n욕설, 비방 등 부적절한 내용은 제재될 수 있습니다.';
    }
  }
}
