import 'package:cuty_app/common/component/custom_text_field.dart';
import 'package:cuty_app/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cuty_app/services/auth_service.dart';
import 'package:cuty_app/common/component/custom_button.dart';
import 'package:cuty_app/common/component/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _authService.login(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // 로그인 성공 후 메인 화면으로 이동
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _onGoogleLogin() async {
    print("구글 로그인 클릭!");
  }

  void _onAppleLogin() async {
    print("애플 로그인 클릭!");
  }

  void _onKakaoLogin() async {
    print("카카오 로그인 클릭!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text(
                    "CUTY",
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color:  Color(0xFF1D3561)
                    ),
                  ),
                  Text(
                    "Welcome!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color:  Color(0xFF1D3561)
                    )
                  ),

                  SizedBox(height: 20),

                  Image.asset(
                    'assets/images/Character_Notebook.png',
                    height: 250,
                    fit: BoxFit.contain,
                    width: 250,
                  ),

                  SizedBox(height: 1),

                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해주세요';
                      }
                      return null;
                    },
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // 로직 추가
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    )
                  ),

                  SizedBox(height: 3),

                  CustomButton(
                    text: 'Login',
                    onPressed: _login,
                    isLoading: _isLoading,
                  ),

                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey)),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Or continue with", style: TextStyle(color: Colors.black)),
                      ),

                      Expanded(child: Divider(color: Colors.grey)),
                    ],
                  ),

                  SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialLoginButton(assetPath: 'assets/images/google_login_btn.png', onTap: _onGoogleLogin),
                      const SizedBox(width: 20),
                      SocialLoginButton(assetPath: 'assets/images/apple_login_btn.png', onTap: _onAppleLogin, backgroundColor: Colors.black,),  // 애플
                      const SizedBox(width: 20),
                      SocialLoginButton(assetPath: 'assets/images/kakao_login_btn.png', onTap: _onKakaoLogin,),  // 카카오
                    ],
                  ),


                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sign Up',
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
        ),
      )

    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
