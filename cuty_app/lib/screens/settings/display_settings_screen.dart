import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';

class DisplaySettingsScreen extends StatefulWidget {
  const DisplaySettingsScreen({super.key});

  @override
  _DisplaySettingsScreenState createState() => _DisplaySettingsScreenState();
}

class _DisplaySettingsScreenState extends State<DisplaySettingsScreen> {
  // 상태 변수 (추후 Provider/GetX로 실제 앱 테마와 연동 필요)
  String _themeMode = 'system'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settingDisplay, 
          style: const TextStyle(color: Colors.black)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              AppLocalizations.of(context)!.displayThemeTitle,
              style: const TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold, 
                color: Colors.grey
              )
            ),
          ),
          RadioListTile<String>(
            title: Text(AppLocalizations.of(context)!.displayThemeSystem),
            value: 'system',
            groupValue: _themeMode,
            onChanged: (value) => setState(() => _themeMode = value!),
            activeColor: Colors.blue,
          ),
          RadioListTile<String>(
            title: Text(AppLocalizations.of(context)!.displayThemeLight),
            value: 'light',
            groupValue: _themeMode,
            onChanged: (value) => setState(() => _themeMode = value!),
            activeColor: Colors.blue,
          ),
          RadioListTile<String>(
            title: Text(AppLocalizations.of(context)!.displayThemeDark),
            value: 'dark',
            groupValue: _themeMode,
            onChanged: (value) => setState(() => _themeMode = value!),
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
