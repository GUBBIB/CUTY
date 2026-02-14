import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/user_provider.dart';
import '../../providers/fortune_provider.dart';
import '../../main.dart'; // RestartWidget
import 'sub_screens/terms_detail_screen.dart';
import '../../l10n/gen/app_localizations.dart'; // [Added]
import '../settings/display_settings_screen.dart'; // [Added] Display Settings Import

import '../../providers/locale_provider.dart'; // [Added]

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isNotificationOn = true;

  // 초기화 및 재시작 로직
  Future<void> _performReset(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 데이터 전체 삭제
    ref.invalidate(userProvider);
    ref.invalidate(fortuneProvider);
    
    if (context.mounted) {
      RestartWidget.restartApp(context);
    }
  }

  // 섹션 헤더 위젯
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
    );
  }

  void _showLanguagePicker(BuildContext context) {
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
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final String languageText = (currentLocale?.languageCode == 'en') ? 'English' : '한국어';
    final l10n = AppLocalizations.of(context)!; // [Added]

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.settingsTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), // [Updated]
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(l10n.appSettingsSection), // [Updated]
          ListTile(
            title: Text(l10n.languageSetting), // [Updated]
            trailing: SizedBox(
              width: 100, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(languageText, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
            ),
            onTap: () => _showLanguagePicker(context),
          ),
          ListTile(
            title: Text(l10n.notificationSetting), // [Updated]
            trailing: Switch(
              value: _isNotificationOn,
              activeColor: const Color(0xFF2C2C4E), 
              onChanged: (value) {
                setState(() => _isNotificationOn = value);
              },
            ),
          ),
          ListTile(
            title: Text(l10n.screenSetting), // [Updated]
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DisplaySettingsScreen()),
              );
            }, 
          ),

          const Divider(height: 30, thickness: 8, color: Color(0xFFF5F5F5)), 

          _buildSectionHeader(l10n.infoSection), // [Updated]
          ListTile(
            title: Text(l10n.versionInfo), // [Updated]
            trailing: const Text('v1.0.0', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
          ),
          ListTile(
            title: Text(l10n.termsOfService), // [Updated]
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (ctx) => TermsDetailScreen(
                title: l10n.termsOfService, // [Updated]
                content: CutyTermsData.termsOfService
              ))), // [Updated]
          ),
          ListTile(
            title: Text(l10n.privacyPolicy), // [Updated]
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (ctx) => TermsDetailScreen(
                title: l10n.privacyPolicy, // [Updated]
                content: CutyTermsData.privacyPolicy
              ))), // [Updated]
          ),

          const Divider(height: 30, thickness: 8, color: Color(0xFFF5F5F5)),

          _buildSectionHeader(l10n.accountSection), // [Updated]
          ListTile(
            title: Text(l10n.logout, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)), // [Updated]
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.logoutDialogTitle), // [Updated]
                  content: Text(l10n.logoutDialogContent), // [Updated]
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)), // [Updated]
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _performReset(context); 
                      },
                      child: Text(l10n.confirm, style: const TextStyle(color: Colors.red)), // [Updated]
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: Text(l10n.deleteAccount, style: const TextStyle(color: Colors.grey)), // [Updated]
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.deleteAccountDialogTitle), // [Updated]
                  content: Text(l10n.deleteAccountDialogContent), // [Updated]
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)), // [Updated]
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _performReset(context); 
                      },
                      child: Text(l10n.delete, style: const TextStyle(color: Colors.red)), // [Updated]
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
