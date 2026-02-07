import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';

class PartTimeApplyConsentScreen extends StatelessWidget {
  const PartTimeApplyConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.permitConsentTitle)),
      body: Center(
        child: Text(AppLocalizations.of(context)!.permitConsentPlaceholder),
      ),
    );
  }
}
