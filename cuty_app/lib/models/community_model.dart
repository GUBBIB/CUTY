import 'package:flutter/material.dart';

enum BoardType {
  free,
  info,
  question, // New Board Type
  market,
  secret;

  String get label {
    switch (this) {
      case BoardType.free:
        return '자유게시판';
      case BoardType.info:
        return '정보게시판';
      case BoardType.question:
        return '질문게시판';
      case BoardType.market:
        return '중고장터';
      case BoardType.secret:
        return '비밀게시판';
    }
  }

  Color get color {
    switch (this) {
      case BoardType.free:
        return Colors.blue[600]!;
      case BoardType.info:
        return Colors.amber[600]!;
      case BoardType.question:
        return Colors.purple[600]!;
      case BoardType.market:
        return Colors.green[600]!;
      case BoardType.secret:
        return Colors.red[600]!;
    }
  }
}

class Post {
  final String id;
  final BoardType boardType;
  final String title;
  final String content;
  final String authorName;
  final String authorSchool;
  final String authorNationality;
  final String? imageUrl;
  final int likeCount;
  final int commentCount;
  final int price; // For Market
  final String? status; // For Market (selling, reserved, etc.)
  final int rewardPoints; // For Question (Point Betting)
  final DateTime createdAt; // New field for sorting

  Post({
    required this.id,
    required this.boardType,
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorSchool,
    required this.authorNationality,
    // timeAgo is calculated dynamically
    this.imageUrl,
    required this.likeCount,
    required this.commentCount,
    this.price = 0,
    this.status,
    this.rewardPoints = 0,
    required this.createdAt,
  });

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else {
      return '${difference.inDays}일 전';
    }
  }
}
