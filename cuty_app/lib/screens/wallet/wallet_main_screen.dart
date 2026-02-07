import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart'; // NEW

class WalletMainScreen extends StatelessWidget {
  const WalletMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.walletTitle),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(AppLocalizations.of(context)!.walletPending),
      ),
    );
  }
}
