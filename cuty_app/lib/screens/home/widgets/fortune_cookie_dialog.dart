import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuty_app/l10n/gen/app_localizations.dart';
import '../../../../providers/point_provider.dart';
import '../../../../providers/fortune_provider.dart';

class FortuneCookieDialog extends ConsumerStatefulWidget {
  const FortuneCookieDialog({super.key});

  @override
  ConsumerState<FortuneCookieDialog> createState() => _FortuneCookieDialogState();
}

class _FortuneCookieDialogState extends ConsumerState<FortuneCookieDialog> {
  bool _isRevealed = false;
  String? _fortuneMessage;
  int? _points;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/item_fortune_cookie.png', width: 100, height: 100),
            const SizedBox(height: 20),
            
            if (!_isRevealed) ...[
              // Step 1: Open Prompt
              Text(
                AppLocalizations.of(context)!.titleFortuneCookie,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.descFortuneCookie,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Trigger Open Logic
                  final result = await ref.read(fortuneProvider.notifier).openCookie();
                  
                  // Earn Points
                  ref.read(pointProvider.notifier).earnPoints(result.points, "포춘쿠키 운세 확인! 🥠");

                  setState(() {
                    _isRevealed = true;
                    _fortuneMessage = result.message;
                    _points = result.points;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(AppLocalizations.of(context)!.btnCheckFortune, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ] else ...[
              // Step 2: Result Reveal
              Text(
                "${AppLocalizations.of(context)!.msgPointsEarned} (+${_points ?? 0})",

                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6)),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _fortuneMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600, height: 1.4),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5E7EB),
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(AppLocalizations.of(context)!.btnConfirm, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
