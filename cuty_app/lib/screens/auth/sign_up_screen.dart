import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../services/local_storage_service.dart';
import '../../providers/signup_provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpProvider(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatelessWidget {
  const _SignUpView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignUpProvider>();
    final l10n = AppLocalizations.of(context)!;
    final step = provider.currentStep;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.signupTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: step == 2 
            ? const SizedBox.shrink() 
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () {
                  if (step == 0) {
                    Navigator.pop(context);
                  } else {
                    context.read<SignUpProvider>().prevStep();
                  }
                },
              ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (step + 1) / 3,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Color(0xFF1E2B4D)),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildBodyContent(context, provider, l10n),
              ),
            ),
            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: _buildBottomButton(context, provider, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, SignUpProvider provider, AppLocalizations l10n) {
    if (provider.currentStep == 0) {
      // Step 0: Terms Agreement
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.signupStepTerms, style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                CheckboxListTile(
                  value: provider.isTermsAllChecked,
                  onChanged: (val) => provider.toggleAllTerms(val),
                  title: Text(l10n.signupAgreeAll, style: const TextStyle(fontWeight: FontWeight.bold)),
                  activeColor: const Color(0xFF1E2B4D),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const Divider(height: 1),
                CheckboxListTile(
                  value: provider.agreeTerms,
                  onChanged: (val) => provider.toggleTerms(val),
                  title: Text(l10n.signupAgreeTerms, style: const TextStyle(fontSize: 14)),
                  subtitle: Text(l10n.signupTermsDesc, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  secondary: TextButton(
                    onPressed: () {
                      // TODO: Show Terms Detail
                    },
                    child: Text(l10n.btnViewDetails, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  activeColor: const Color(0xFF1E2B4D),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  value: provider.agreePrivacy,
                  onChanged: (val) => provider.togglePrivacy(val),
                  title: Text(l10n.signupAgreePrivacy, style: const TextStyle(fontSize: 14)),
                  subtitle: Text(l10n.signupPrivacyDesc, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  secondary: TextButton(
                    onPressed: () {
                      // TODO: Show Privacy Detail
                    },
                    child: Text(l10n.btnViewDetails, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  activeColor: const Color(0xFF1E2B4D),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          )
        ],
      );
    } else if (provider.currentStep == 1) {
      // Step 1: Info Input
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.signupStepInfo, style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          TextField(
            onChanged: provider.updateEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: l10n.signupEmailHint,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: provider.updatePassword,
            obscureText: true,
            decoration: InputDecoration(
              hintText: l10n.signupPwHint,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: provider.updatePasswordConfirm,
            obscureText: true,
            decoration: InputDecoration(
              hintText: l10n.signupPwConfirmHint,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              errorText: provider.isPwMismatch ? l10n.msgPwMismatch : null,
            ),
          ),
        ],
      );
    } else {
      // Step 2: Complete
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 24),
          Text(l10n.msgSignupSuccessTitle, style: GoogleFonts.notoSansKr(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(
            l10n.msgSignupSuccessDesc,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
        ],
      );
    }
  }

  Widget _buildBottomButton(BuildContext context, SignUpProvider provider, AppLocalizations l10n) {
    bool isEnabled = false;
    String btnText = l10n.btnNext;
    VoidCallback? onPressed;

    if (provider.currentStep == 0) {
      isEnabled = provider.isTermsAllChecked;
      onPressed = isEnabled ? () => context.read<SignUpProvider>().nextStep() : null;
    } else if (provider.currentStep == 1) {
      isEnabled = provider.isInfoValid;
      btnText = l10n.signupTitle; // "회원가입"
      onPressed = isEnabled ? () {
        // TODO: API 회원가입 호출 로직 추가 위치
        context.read<SignUpProvider>().nextStep();
      } : null;
    } else {
      isEnabled = true;
      btnText = l10n.btnGoToLogin;
      onPressed = () async {
        await LocalStorageService().saveBool('is_first_login', true); // 첫 로그인 플래그 저장
        if (context.mounted) Navigator.pop(context); // 로그인 화면으로 돌아가기
      };
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E2B4D),
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(btnText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
