import 'package:cuty_app/common/component/custom_app_bar.dart';
import 'package:cuty_app/common/component/post_comment_item.dart';
import 'package:cuty_app/common/layout/screen_layout.dart';
import 'package:flutter/material.dart';
import 'package:cuty_app/models/post_comment.dart';
import 'package:cuty_app/services/post_comment_service.dart';

class MyCommentsScreen extends StatefulWidget {
  const MyCommentsScreen({super.key});

  @override
  State<MyCommentsScreen> createState() => _MyCommentsScreenState();
}

class _MyCommentsScreenState extends State<MyCommentsScreen> {
  final _scrollController = ScrollController();
  final _commentService = PostCommentService();
  final List<PostComment> _comments = [];
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
      final data = await _commentService.getMyComments(
        page: _currentPage,
      );

      if (mounted) {
        setState(() {
          _comments.addAll(data['comments'] as List<PostComment>);
          _hasMore = _currentPage < (data['pages'] as int);
          _currentPage++;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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

  Future<void> _navigateToComment(PostComment comment) async {
    try {
      final parentComment = await _commentService.getComment(
        comment.postId,
        comment.id,
      );

      if (mounted) {
        Navigator.pushNamed(
          context,
          '/comment',
          arguments: {
            'postId': comment.postId,
            'commentId': parentComment.parentId ?? comment.id,
          },
        ).then((_) {
          // 댓글 화면에서 돌아왔을 때 목록 새로고침
          setState(() {
            _comments.clear();
            _currentPage = 1;
            _hasMore = true;
          });
          _loadMore();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _showCommentOptions(PostComment comment) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'edit');
              },
              child: const Text('수정'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'delete');
              },
              child: const Text(
                '삭제',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (result == 'delete') {
      _deleteComment(comment);
    } else if (result == 'edit') {
      _editComment(comment);
    }
  }

  Future<void> _deleteComment(PostComment comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('댓글 삭제'),
          content: const Text('정말 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                '삭제',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      try {
        await _commentService.deleteComment(comment.postId, comment.id);
        if (mounted) {
          setState(() {
            _comments.clear();
            _currentPage = 1;
            _hasMore = true;
          });
          await _loadMore();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('댓글이 삭제되었습니다')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  Future<void> _editComment(PostComment comment) async {
    final controller = TextEditingController(text: comment.content);
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('댓글 수정'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '댓글 내용을 입력하세요',
            ),
            maxLines: null,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('수정'),
            ),
          ],
        );
      },
    );

    if (result != null && result.trim().isNotEmpty && mounted) {
      try {
        await _commentService.updateComment(
          postId: comment.postId,
          commentId: comment.id,
          content: result,
        );
        if (mounted) {
          setState(() {
            _comments.clear();
            _currentPage = 1;
            _hasMore = true;
          });
          await _loadMore();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('댓글이 수정되었습니다')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }
 
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.comment_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            '작성한 댓글이 없습니다',
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
        title: '내가 쓴 댓글',
      ),
      body: ScreenLayout(
        child: !_isLoading && _comments.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                controller: _scrollController,
                itemCount: _comments.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _comments.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final comment = _comments[index];
                  return PostCommentItem(
                    comment: comment,
                    isAuthor: true,
                    onOptionsTap: _showCommentOptions,
                    onTap: _navigateToComment,
                    isReply: comment.parentId != null,
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
