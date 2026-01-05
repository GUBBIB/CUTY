import 'package:flutter/material.dart';
import 'package:cuty_app/config/app_theme.dart';
import 'package:cuty_app/config/app_colors.dart';
import 'package:cuty_app/screens/login_screen.dart';
import 'package:cuty_app/screens/register_screen.dart';
import 'package:cuty_app/screens/post_list_screen.dart';
import 'package:cuty_app/screens/post_write_screen.dart';
import 'package:cuty_app/screens/post_detail_screen.dart';
import 'package:cuty_app/screens/post_comment_detail_screen.dart';
import 'package:cuty_app/screens/home_screen.dart';
import 'package:cuty_app/screens/change_password_screen.dart';
import 'package:cuty_app/screens/my_posts_screen.dart';
import 'package:cuty_app/screens/my_comments_screen.dart';

import 'package:cuty_app/common/layout/root_tab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cuty App',
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        return Container(
          color: AppColors.backgroundColor, 
          child: SafeArea(
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      home: const RootTab(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/postList': (context) => const PostListScreen(),
        '/write': (context) => const PostWriteScreen(),
        '/post': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return PostDetailScreen(postId: args['postId'] as int);
        },
        '/comment': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return PostCommentDetailScreen(
            postId: args['postId'] as int,
            commentId: args['commentId'] as int,
          );
        },
        '/home': (context) => const RootTab(),
        '/changePassword': (context) => const ChangePasswordScreen(),
        '/myPosts': (context) => const MyPostsScreen(),
        '/myComments': (context) => const MyCommentsScreen(),
        // 다른 라우트들도 여기에 추가할 예정
      },
    );
  }
}
