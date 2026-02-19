import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../services/local_storage_service.dart';
import 'onboarding_tutorial_screen.dart';
import 'sign_up_screen.dart';
import '../main_screen.dart';
import '../../providers/locale_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text('언어 선택 / Choose Language', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Text('🇰🇷', style: TextStyle(fontSize: 24)),
                title: const Text('한국어'),
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(const Locale('ko'));
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
                title: const Text('English'),
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    const brandColor = Color(0xFF1E2B4D);
    const double characterSize = 220.0; // ✨ 여기서 캐릭터 크기 조절 (기본: 150.0)

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 상단 로고 및 언어 설정
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CUTY',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: brandColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showLanguagePicker(context, ref),
                    icon: const Icon(Icons.language, color: Colors.grey),
                  ),
                ],
              ),

              const Spacer(),

              // 2. 하단 콘텐츠 블록
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✨ 캐릭터 이미지 (고정 크기 적용)
                    Center(child: Image.asset('assets/images/capy_joy.png', height: characterSize)),
                    
                    const SizedBox(height: 24),
                    Text(
                      l10n.loginTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSansKr(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
                    ),
                    const SizedBox(height: 32),

                    // Inputs
                    TextField(
                      decoration: InputDecoration(
                        hintText: l10n.loginIdHint,
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: l10n.loginPwHint,
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        final isFirstLogin = LocalStorageService().getBool('is_first_login');
                        if (isFirstLogin) {
                          LocalStorageService().saveBool('is_first_login', false);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingTutorialScreen()));
                        } else {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                      backgroundColor: brandColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(l10n.btnLogin, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(height: 16),

                    // Sub Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
                          child: Text(l10n.btnSignUp, style: const TextStyle(color: Colors.grey)),
                        ),
                        const Text("|", style: TextStyle(color: Colors.grey)),
                        TextButton(
                          onPressed: () {},
                          child: Text(l10n.btnFindPw, style: const TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Social Logins
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(l10n.loginSocialLabel, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialCircle(
                          color: const Color(0xFFFEE500),
                          border: Colors.transparent,
                          child: const Icon(Icons.chat_bubble_rounded, color: Color(0xFF371D1E), size: 24),
                        ),
                        const SizedBox(width: 16),
                        _buildSocialCircle(
                          color: Colors.white,
                          border: Colors.grey[200]!,
                          child: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                            width: 22,
                            height: 22,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, color: Colors.blue, size: 32),
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildSocialCircle(
                          color: Colors.white,
                          border: Colors.grey[200]!,
                          child: const Icon(Icons.apple, color: Colors.black, size: 28),
                        ),
                        const SizedBox(width: 16),
                        _buildSocialCircle(
                          color: Colors.white,
                          border: Colors.grey[200]!,
                          child: const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 28),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialCircle({required Color color, required Color border, required Widget child}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}
