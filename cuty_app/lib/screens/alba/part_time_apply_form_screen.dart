import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuty_app/providers/user_provider.dart';
import '../../l10n/gen/app_localizations.dart';

class PartTimeApplyFormScreen extends ConsumerWidget {
  const PartTimeApplyFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.permitFormTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.permitFormSubtitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
            ),
            const SizedBox(height: 32),

            // 1. 유저 정보 (자동 입력됨)
            Text(AppLocalizations.of(context)!.lblApplicantInfo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildInfoRow(AppLocalizations.of(context)!.lblName, user.name),
                  const SizedBox(height: 8),
                  _buildInfoRow(AppLocalizations.of(context)!.lblAffiliation, user.university),
                  const SizedBox(height: 8),
                  _buildInfoRow(AppLocalizations.of(context)!.lblVisa, user.visaType),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 2. 사업주/근로계약 정보 (Mock)
            Text(AppLocalizations.of(context)!.lblWorkplaceInfo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            _buildTextField(AppLocalizations.of(context)!.labelTradeNameDetail, "쿠티 편의점 역삼점"),
            const SizedBox(height: 16),
            _buildTextField(AppLocalizations.of(context)!.labelBizRegNo, "123-45-67890"),
            const SizedBox(height: 16),
            _buildTextField(AppLocalizations.of(context)!.labelContact, "010-1234-5678"),
            
            const SizedBox(height: 48),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                   showDialog(
                     context: context,
                     builder: (context) => AlertDialog(
                       title: Text(AppLocalizations.of(context)!.titleApplyComplete),
                       content: Text(AppLocalizations.of(context)!.msgApplyComplete),
                       actions: [
                         TextButton(
                           onPressed: () {
                              Navigator.pop(context); // Close dialog
                              Navigator.pop(context); // Close Form
                              Navigator.pop(context); // Close Check
                              Navigator.pop(context); // Close Consent (Back to Home)
                           },
                           child: Text(AppLocalizations.of(context)!.actionConfirm),
                         )
                       ],
                     )
                   );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A), // Blue-900
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                  child: Text(
                    AppLocalizations.of(context)!.btnFinalApply,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTextField(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        )
      ],
    );
  }
}
