import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/community_data_manager.dart';
import '../../providers/user_provider.dart';
import '../community/widgets/community_post_item.dart';
import '../community/post_detail_screen.dart';

class MyCommunityActivityScreen extends ConsumerStatefulWidget {
  const MyCommunityActivityScreen({super.key});

  @override
  ConsumerState<MyCommunityActivityScreen> createState() => _MyCommunityActivityScreenState();
}

class _MyCommunityActivityScreenState extends ConsumerState<MyCommunityActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light Grey BG
      appBar: AppBar(
        title: Text('커뮤니티 활동', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: '내가 쓴 글'),
            Tab(text: '활동 설정'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: My Posts
          _buildMyPostsTab(),
          // Tab 2: Activity Settings
          _buildActivitySettingsTab(ref),
        ],
      ),
    );
  }

  Widget _buildMyPostsTab() {
    final myPosts = CommunityDataManager.getMyPosts();

    if (myPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              '작성한 글이 없습니다.',
              style: GoogleFonts.notoSansKr(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: myPosts.length,
      itemBuilder: (context, index) {
        final post = myPosts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.white,
            child: CommunityPostItem(post: post),
          ),
        );
      },
    );
  }

  Widget _buildActivitySettingsTab(WidgetRef ref) {
    final user = ref.watch(userProvider);
    if (user == null) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Header Info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                '커뮤니티 활동 시 보여질 정보를 선택하세요.',
                style: GoogleFonts.notoSansKr(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '개인정보를 보호하고 싶다면 비공개로 설정할 수 있습니다.',
                style: GoogleFonts.notoSansKr(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Settings
        _buildSwitchTile(
          context: context,
          title: '닉네임 공개',
          subtitle: '비공개 시 \'익명\'으로 표시됩니다.',
          value: !user.isNicknameHidden,
          onChanged: (val) => ref.read(userProvider.notifier).togglePrivacy('nickname'),
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          context: context,
          title: '국적 아이콘 표시',
          subtitle: '게시글 옆에 국적 국기를 표시합니다.',
          value: !user.isNationalityHidden,
          onChanged: (val) => ref.read(userProvider.notifier).togglePrivacy('nationality'),
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          context: context,
          title: '성별 공개',
          subtitle: '프로필에 성별 정보를 표시합니다.',
          value: !user.isGenderHidden,
          onChanged: (val) => ref.read(userProvider.notifier).togglePrivacy('gender'),
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          context: context,
          title: '학교명 공개',
          subtitle: '프로필에 학교 이름을 표시합니다.',
          value: !user.isSchoolHidden,
          onChanged: (val) => ref.read(userProvider.notifier).togglePrivacy('school'),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: GoogleFonts.notoSansKr(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A2E), // Navy
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.notoSansKr(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue[600], // Primary Blue
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
