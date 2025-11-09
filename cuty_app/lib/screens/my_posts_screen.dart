import 'package:cuty_app/common/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cuty_app/models/post.dart';
import 'package:cuty_app/services/post_service.dart';
import 'package:cuty_app/common/component/post_list_item.dart';
import 'package:cuty_app/common/layout/screen_layout.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  final _scrollController = ScrollController();
  final _postService = PostService();
  final List<Post> _posts = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _postService.getMyPosts(
        page: _currentPage,
      );

      final posts = (data['posts'] as List<Post>);

      setState(() {
        _posts.addAll(posts);
        _hasMore = _currentPage < (data['pages'] as int);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        if (e.toString().contains('토큰이 없습니다')) {
          Navigator.pushNamed(context, '/login');
        }
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            '작성한 글이 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '내가 쓴 글',
      ),
      body: ScreenLayout(
        child: !_isLoading && _posts.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                controller: _scrollController,
                itemCount: _posts.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _posts.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final post = _posts[index];
                  return PostListItem(
                    post: post,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/post',
                        arguments: {'postId': post.id},
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
