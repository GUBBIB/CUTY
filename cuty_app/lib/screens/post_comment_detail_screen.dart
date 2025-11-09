import 'package:cuty_app/common/component/post_comment_item.dart';
import 'package:flutter/material.dart';
import 'package:cuty_app/models/post_comment.dart';
import 'package:cuty_app/services/post_comment_service.dart';
import 'package:cuty_app/services/user_service.dart';

class PostCommentDetailScreen extends StatefulWidget {
  final int postId;
  final int commentId;

  const PostCommentDetailScreen({
    super.key,
    required this.postId,
    required this.commentId,
  });

  @override
  State<PostCommentDetailScreen> createState() =>
      _PostCommentDetailScreenState();
}

class _PostCommentDetailScreenState extends State<PostCommentDetailScreen> {
  final _commentService = PostCommentService();
  final _scrollController = ScrollController();
  final _replyController = TextEditingController();

  PostComment? _comment;
  List<PostComment> _replies = [];
  bool _isLoading = true;
  bool _isLoadingReplies = false;
  bool _isSendingReply = false;
  bool _hasMoreReplies = true;
  int _currentPage = 1;
  int _totalReplies = 0;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadComment();
    _loadReplies();
    _scrollController.addListener(_onScroll);
    _checkIsAuthor();
  }

  Future<void> _loadComment() async {
    try {
      final comment = await _commentService.getComment(
        widget.postId,
        widget.commentId,
      );

      if (mounted) {
        setState(() {
          _comment = comment;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _loadReplies() async {
    if (_isLoadingReplies || !_hasMoreReplies) return;

    setState(() {
      _isLoadingReplies = true;
    });

    try {
      final data = await _commentService.getReplies(
        widget.postId,
        widget.commentId,
        page: _currentPage,
      );

      if (mounted) {
        setState(() {
          _replies.addAll(data['replies'] as List<PostComment>);
          _hasMoreReplies = _currentPage < (data['pages'] as int);
          _currentPage++;
          _isLoadingReplies = false;
          _totalReplies = data['total'] as int;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingReplies = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadReplies();
    }
  }

  Future<void> _sendReply() async {
    if (_replyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('답글 내용을 입력하세요')),
      );
      return;
    }

    setState(() {
      _isSendingReply = true;
    });

    try {
      await _commentService.createComment(
        postId: widget.postId,
        content: _replyController.text,
        parentId: widget.commentId,
      );

      if (mounted) {
        _replyController.clear();
        FocusScope.of(context).unfocus();

        setState(() {
          _replies = [];
          _currentPage = 1;
          _hasMoreReplies = true;
        });

        await Future.wait([
          _loadComment(),
          _loadReplies(),
        ]);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        if (e.toString().contains('토큰이 없습니다')) {
          Navigator.pushNamed(context, '/login');
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSendingReply = false;
        });
      }
    }
  }

  Future<void> _checkIsAuthor() async {
    try {
      final userService = UserService();
      final currentUser = await userService.getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUserId = currentUser.id;
        });
      }
    } catch (e) {
      setState(() {
        _currentUserId = null;
      });
    }
  }

  bool _isReplyAuthor(PostComment reply) {
    return _currentUserId != null && _currentUserId == reply.user?.id;
  }

  Future<void> _showReplyOptions(PostComment reply) async {
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
      _deleteReply(reply);
    } else if (result == 'edit') {
      _editReply(reply);
    }
  }

  Future<void> _deleteReply(PostComment reply) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('답글 삭제'),
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
        await _commentService.deleteComment(widget.postId, reply.id);
        if (mounted) {
          setState(() {
            _replies = [];
            _currentPage = 1;
            _hasMoreReplies = true;
          });
          await Future.wait([
            _loadComment(),
            _loadReplies(),
          ]);
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

  Future<void> _editReply(PostComment reply) async {
    final controller = TextEditingController(text: reply.content);
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('답글 수정'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '답글 내용을 입력하세요',
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
          postId: widget.postId,
          commentId: reply.id,
          content: result,
        );
        if (mounted) {
          setState(() {
            _replies = [];
            _currentPage = 1;
            _hasMoreReplies = true;
          });
          await Future.wait([
            _loadComment(),
            _loadReplies(),
          ]);
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

  Widget _buildReplyItem(PostComment reply) {
    return PostCommentItem(
      comment: reply,
      isAuthor: _isReplyAuthor(reply),
      onOptionsTap: _showReplyOptions,
      onTap: (_) {}, // 답글은 탭 동작이 필요 없음
      isReply: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('댓글'),
      ),
      body: Column(
        children: [
          PostCommentItem(
            comment: _comment!,
            isAuthor: false,
            onOptionsTap: (_) {},
            onTap: (_) {},
            isReply: false,
            showReplyCount: false,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  '답글',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$_totalReplies',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _replies.length + (_hasMoreReplies ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _replies.length) {
                  return _hasMoreReplies
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox.shrink();
                }

                return _buildReplyItem(_replies[index]);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 8.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      decoration: const InputDecoration(
                        hintText: '답글을 입력하세요',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      onTap: () async {
                        try {
                          final userService = UserService();
                          await userService.getCurrentUser();
                        } catch (e) {
                          if (mounted) {
                            _replyController.clear();
                            FocusScope.of(context).unfocus();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('답글을 작성하려면 로그인이 필요합니다'),
                              ),
                            );
                            Navigator.pushNamed(context, '/login');
                          }
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: _isSendingReply ? null : _sendReply,
                    icon: _isSendingReply
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _replyController.dispose();
    super.dispose();
  }
}
