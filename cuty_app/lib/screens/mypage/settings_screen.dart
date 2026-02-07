import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/gen/app_localizations.dart'; // UPDATED
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/locale_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.menuSettings,
          style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _buildSectionHeader(AppLocalizations.of(context)!.sectionAppSettings),
          _buildLanguageTile(context, ref), // NEW
          _buildSwitchTile(AppLocalizations.of(context)!.settingNotification, true, (val) {}),
          _buildListTile(AppLocalizations.of(context)!.settingDisplay, () {}),
          
          const SizedBox(height: 24),
          _buildSectionHeader(AppLocalizations.of(context)!.sectionInfo),
          _buildInfoTile(AppLocalizations.of(context)!.menuVersion, 'v1.0.0'),
          _buildListTile(AppLocalizations.of(context)!.menuTerms, () {}),
          _buildListTile(AppLocalizations.of(context)!.menuPrivacy, () {}),
          
          const SizedBox(height: 24),
          _buildSectionHeader(AppLocalizations.of(context)!.sectionAccount),
          _buildListTile(
            AppLocalizations.of(context)!.menuLogout, 
            () {
              // Mock Logout
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.msgLogout)),
              );
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            color: Colors.red,
          ),
           _buildListTile(
            AppLocalizations.of(context)!.settingDeleteAccount, 
            () {},
            color: Colors.grey,
            isSmall: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.notoSansKr(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      color: Colors.white,
      child: SwitchListTile(
        title: Text(
          title, 
          style: GoogleFonts.notoSansKr(fontSize: 16),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF1A1A2E), // Navy
      ),
    );
  }

  Widget _buildListTile(String title, VoidCallback onTap, {Color? color, bool isSmall = false}) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.notoSansKr(
            fontSize: isSmall ? 14 : 16,
            color: color ?? Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoTile(String title, String info) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.notoSansKr(fontSize: 16),
        ),
        trailing: Text(
          info,
          style: GoogleFonts.notoSansKr(
            fontSize: 14,
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    String languageName = '한국어';
    if (currentLocale?.languageCode == 'en') {
      languageName = 'English';
    }

    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.menuLanguage,
          style: GoogleFonts.notoSansKr(fontSize: 16),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languageName,
              style: GoogleFonts.notoSansKr(
                fontSize: 14,
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('한국어'),
                      trailing: currentLocale?.languageCode == 'ko' || currentLocale == null
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        ref.read(localeProvider.notifier).setLocale(const Locale('ko', 'KR'));
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('English'),
                      trailing: currentLocale?.languageCode == 'en'
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        ref.read(localeProvider.notifier).setLocale(const Locale('en', 'US'));
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
