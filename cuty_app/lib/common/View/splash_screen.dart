import 'dart:math';

import 'package:cuty_app/common/layout/root_tab.dart';
import 'package:flutter/material.dart';
import 'package:cuty_app/screens/login_screen.dart';
import 'package:cuty_app/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  late String _randomCharacterImage;
  final List<String> _characterImages = [
    'assets/images/Character/Character_1.png',
    'assets/images/Character/Character_2.png',
    'assets/images/Character/Character_3.png',
    'assets/images/Character/Character_4.png',
    'assets/images/Character/Character_5.png',
    'assets/images/Character/Character_6.png',
    'assets/images/Character/Character_7.png',
    'assets/images/Character/Character_8.png',
    'assets/images/Character/Character_9.png',
    'assets/images/Character/Character_10.png',
    'assets/images/Character/Character_11.png',
    'assets/images/Character/Character_12.png',
    'assets/images/Character/Character_13.png',
    'assets/images/Character/Character_14.png',
    'assets/images/Character/Character_15.png',
    'assets/images/Character/Character_16.png',
    'assets/images/Character/Character_17.png',
    'assets/images/Character/Character_18.png',
    'assets/images/Character/Character_19.png',
    'assets/images/Character/Character_20.png',
    'assets/images/Character/Character_21.png',
    'assets/images/Character/Character_22.png',
    'assets/images/Character/Character_23.png',
    'assets/images/Character/Character_24.png',
    'assets/images/Character/Character_25.png',
  ];

  @override
  void initState() {
    super.initState();
    _pickRandomImage();
    _checkLogin();
  }

  void _pickRandomImage() {
    final random = Random();
    int index = random.nextInt(_characterImages.length);
    setState(() {
      _randomCharacterImage = _characterImages[index];
    });
  }

  void _checkLogin() async {
    final splashDelay = Future.delayed(Duration(seconds: 2));

    bool isLoggedIn = false;

    try{
      isLoggedIn = await _authService.isLoggedIn();
    } catch (e){
      isLoggedIn = false;
    }

    await splashDelay;

    if(!mounted) return;

    if(isLoggedIn) {
      print('✅ 로그인 했어유~!');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const RootTab()),
      );
    } else {
      print('⛔ 로그인 안 했어유~!');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CUTY',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1D3561),
              ),
            ),

            SizedBox(height: 40),

            // 랜덤 하게 띄우기
            Image.asset(
              _randomCharacterImage,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 40),

            CircularProgressIndicator(
              color: Color(0xFF1D3561),
              strokeWidth: 4.0,
            )
          ],
        )
      ),
    );
  }
}