import 'package:cuty_app/common/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cuty_app/models/post.dart';
import 'package:cuty_app/models/post_comment.dart';
import 'package:cuty_app/services/post_service.dart';
import 'package:cuty_app/services/post_comment_service.dart';
import 'package:cuty_app/services/user_service.dart';
import 'package:cuty_app/common/layout/screen_layout.dart';
import 'package:cuty_app/common/component/post_detail_item.dart';
import 'package:cuty_app/common/component/post_comment_item.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;

  const PostDetailScreen({
    super.key,
    required this.postId,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _postService = PostService();
  final _commentService = PostCommentService();
  final _scrollController = ScrollController();
  final _commentController = TextEditingController();

  Post? _post;
  List<PostComment> _comments = [];
  bool _isLoading = true;
  bool _isLoadingComments = false;
  bool _isSendingComment = false;
  bool _hasMoreComments = true;
  int _currentPage = 1;
  bool _isAuthor = false;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadPost();
    _loadComments();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadPost() async {
    try {
      final post = await _postService.getPost(widget.postId);
      if (mounted) {
        setState(() {
          _post = post;
          _isLoading = false;
        });
        _checkIsAuthor();
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

  Future<void> _loadComments() async {
    if (_isLoadingComments || !_hasMoreComments) return;

    setState(() {
      _isLoadingComments = true;
    });

    try {
      final data = await _commentService.getComments(
        widget.postId,
        page: _currentPage,
      );

      if (mounted) {
        setState(() {
          _comments.addAll(data['comments'] as List<PostComment>);
          _hasMoreComments = _currentPage < (data['pages'] as int);
          _currentPage++;
          _isLoadingComments = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingComments = false;
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
      _loadComments();
    }
  }

  Future<void> _sendComment() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('댓글 내용을 입력하세요')),
      );
      return;
    }

    setState(() {
      _isSendingComment = true;
    });

    try {
      await _commentService.createComment(
        postId: widget.postId,
        content: _commentController.text,
      );

      if (mounted) {
        _commentController.clear();
        FocusScope.of(context).unfocus();

        setState(() {
          _comments = [];
          _currentPage = 1;
          _hasMoreComments = true;
        });

        await Future.wait([
          _loadPost(),
          _loadComments(),
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
          _isSendingComment = false;
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
          _isAuthor = currentUser.id == _post!.user?.id;
          _currentUserId = currentUser.id;
        });
      }
    } catch (e) {
      setState(() {
        _isAuthor = false;
        _currentUserId = null;
      });
    }
  }

  bool _isCommentAuthor(PostComment comment) {
    return _currentUserId != null && _currentUserId == comment.user?.id;
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
        await _commentService.deleteComment(widget.postId, comment.id);
        if (mounted) {
          setState(() {
            _comments = [];
            _currentPage = 1;
            _hasMoreComments = true;
          });
          await Future.wait([
            _loadPost(),
            _loadComments(),
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
          postId: widget.postId,
          commentId: comment.id,
          content: result,
        );
        if (mounted) {
          setState(() {
            _comments = [];
            _currentPage = 1;
            _hasMoreComments = true;
          });
          await Future.wait([
            _loadPost(),
            _loadComments(),
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

  Future<void> _showPostOptions() async {
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
      _deletePost();
    } else if (result == 'edit') {
      _editPost();
    }
  }

  Widget _buildCommentItem(PostComment comment) {
    return PostCommentItem(
      comment: comment,
      isAuthor: _isCommentAuthor(comment),
      onOptionsTap: _showCommentOptions,
      onTap: (comment) {
        Navigator.pushNamed(
          context,
          '/comment',
          arguments: {
            'postId': comment.postId,
            'commentId': comment.id,
          },
        ).then((_) {
          setState(() {
            _comments = [];
            _currentPage = 1;
            _hasMoreComments = true;
          });
          _loadComments();
        });
      },
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
      appBar: CustomAppBar(
        title: '',
        actions: _isAuthor
            ? [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: _showPostOptions,
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: ScreenLayout(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _comments.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PostDetailItem(post: _post!),
                        const SizedBox(height: 16),
                      ],
                    );
                  }

                  if (index == 1) {
                    return SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          const Text(
                            '댓글',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_post!.commentCount}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final commentIndex = index - 2;
                  if (commentIndex == _comments.length) {
                    return _hasMoreComments
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const SizedBox.shrink();
                  }

                  return _buildCommentItem(_comments[commentIndex]);
                },
              ),
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
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: '댓글을 입력하세요',
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
                            _commentController.clear();
                            FocusScope.of(context).unfocus();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('댓글을 작성하려면 로그인이 필요합니다'),
                              ),
                            );
                            Navigator.pushNamed(context, '/login');
                          }
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: _isSendingComment ? null : _sendComment,
                    icon: _isSendingComment
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
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _deletePost() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('게시글 삭제'),
          content: const Text('정말 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      try {
        await _postService.deletePost(widget.postId);
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
            arguments: {'refresh': true},
          );
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

  Future<void> _editPost() async {
    if (mounted) {
      final result = await Navigator.pushNamed(
        context,
        '/write',
        arguments: {
          'post': _post,
          'category': _post!.category,
        },
      );

      if (result == true && mounted) {
        await _loadPost();
      }
    }
  }
}
