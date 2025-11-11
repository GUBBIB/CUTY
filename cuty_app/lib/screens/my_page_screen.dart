import 'package:cuty_app/common/component/custom_app_bar.dart';
import 'package:cuty_app/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cuty_app/services/user_service.dart';
import 'package:cuty_app/services/auth_service.dart';
import 'package:cuty_app/services/request_service.dart';
import 'package:cuty_app/models/user.dart';
import 'package:cuty_app/screens/my_posts_screen.dart';
import 'package:cuty_app/screens/my_comments_screen.dart';
import 'package:cuty_app/screens/my_documents_screen.dart';
import 'package:cuty_app/common/layout/screen_layout.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final _userService = UserService();
  final _authService = AuthService();
  final _requestService = RequestService();
  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _userService.getCurrentUser();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
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

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('회원 탈퇴'),
          content: const Text(
            '정말 탈퇴하시겠습니까?\n탈퇴 후에는 복구가 불가능합니다.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                '탈퇴',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      try {
        await _userService.deleteAccount();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_user == null) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: '마이페이지',
        ),
        body: ScreenLayout(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '로그인이 필요한 서비스입니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '계정이 없으신가요?',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '회원가입',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: '마이페이지',
      ),
      body: ScreenLayout(
        child: ListView(
          children: [
            // 사용자 기본 정보
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _user?.name ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _user?.email ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 학교 정보
                  if (_user?.country != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.public, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          '국가: ${_user!.country!.name}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_user?.school != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.school, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          '학교: ${_user!.school!.name}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_user?.college != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.account_balance, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          '대학: ${_user!.college!.name}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_user?.department != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.business, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          '학과: ${_user!.department!.name}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                '나의 서류',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyDocumentsScreen()),
                );
              },
            ),
            ListTile(
              title: const Text(
                '내가 쓴 글',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyPostsScreen()),
                );
              },
            ),
            ListTile(
              title: const Text(
                '내가 쓴 댓글',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyCommentsScreen()),
                );
              },
            ),
            ListTile(
              title: const Text(
                '비밀번호 변경',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/changePassword');
              },
            ),

            // `/api/v1/requests` [methods='GET'] 테스트 버튼
            ListTile(
              title: const Text(
                '요청 API 테스트 버튼',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                try {
                  await _requestService.createRequest(req_type_str: "PART_TIME");
                  print("요청 API 테스트 버튼 API 성공");
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('신청 성공! 🎉')),
                    );
                  }

                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('에러 발생 dart 1: $e')),
                    );
                  }
                }
              },
            ),

            const Divider(),
            ListTile(
              title: const Text(
                '로그아웃',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              textColor: Colors.red,
              trailing: const Icon(Icons.logout, color: Colors.red),
              onTap: _logout,
            ),
            ListTile(
              title: const Text(
                '회원 탈퇴',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _deleteAccount,
            ),
          ],
        ),
      ),
    );
  }
}
