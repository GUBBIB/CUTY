import 'package:flutter/material.dart';
import 'package:cuty_app/models/post.dart';
import 'package:cuty_app/common/component/card_container.dart';
import 'package:cuty_app/services/post_like_service.dart';

class PostDetailItem extends StatefulWidget {
  final Post post;

  const PostDetailItem({
    super.key,
    required this.post,
  });

  @override
  State<PostDetailItem> createState() => _PostDetailItemState();
}

class _PostDetailItemState extends State<PostDetailItem> {
  final _postLikeService = PostLikeService();
  bool _isLoading = false;
  late Post _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  Future<void> _toggleLike() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedPost = _post.userLikeStatus
          ? await _postLikeService.unlikePost(_post.id)
          : await _postLikeService.likePost(_post.id);

      if (mounted) {
        setState(() {
          _post = updatedPost;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _post.displayTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _post.displayContent,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _post.nickname,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _post.createdAt.toString().substring(0, 16),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.remove_red_eye_outlined,
                size: 16,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(
                _post.viewCount.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: _toggleLike,
                child: Row(
                  children: [
                    _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            _post.userLikeStatus
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                            color: _post.userLikeStatus
                                ? Colors.red
                                : Theme.of(context).textTheme.bodySmall?.color,
                          ),
                    const SizedBox(width: 4),
                    Text(
                      _post.likeCount.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.chat_bubble_outline,
                size: 16,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(
                _post.commentCount.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
