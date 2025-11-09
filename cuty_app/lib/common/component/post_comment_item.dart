import 'package:flutter/material.dart';
import 'package:cuty_app/models/post_comment.dart';
import 'package:cuty_app/common/component/card_container.dart';

class PostCommentItem extends StatelessWidget {
  final PostComment comment;
  final bool isAuthor;
  final Function(PostComment) onOptionsTap;
  final Function(PostComment) onTap;
  final bool isReply;
  final bool showReplyCount;

  const PostCommentItem({
    super.key,
    required this.comment,
    required this.isAuthor,
    required this.onOptionsTap,
    required this.onTap,
    this.isReply = false,
    this.showReplyCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: () => onTap(comment),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.displayContent,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                comment.displayNickname,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                comment.createdAt.toString().substring(0, 16),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              if (!isReply && showReplyCount) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        comment.replyCount.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (isAuthor)
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => onOptionsTap(comment),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
