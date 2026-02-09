import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart'; // simulation for now
import '../../providers/alba_permit_provider.dart';
import '../../providers/document_provider.dart';
import '../../l10n/gen/app_localizations.dart';
import '../spec/spec_wallet_screen.dart';

// Main Widget
class PermitApplicationWizard extends ConsumerWidget {
  const PermitApplicationWizard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(albaPermitProvider);
    final notifier = ref.read(albaPermitProvider.notifier);

    // Render based on current step
    switch (state.currentStep) {
      case 0: return _Step0Selection(notifier);
      case 1: return _Step1VisaLink(notifier, state);
      case 2: return _StepCheckDocs(notifier); // [NEW] Document Check
      case 3: return _Step2Guide(notifier, state);
      case 4: return _Step3Camera(notifier, state);
      case 5: return _Step4InfoConfirm(notifier, state);
      case 6: return _Step5Signature(notifier, state);
      case 7: return _Step6SubmitComplete(notifier);
      case 8: return _Step7SchoolApproval(notifier);
      case 9: return _Step8FinalFolder(notifier, state);
      case 10: return _Step9HiKoreaGuide(notifier);
      case 11: return _Step10FinalPermit();
      default: return const Scaffold(body: Center(child: Text("Unknown Step")));
    }
  }
}

// -----------------------------------------------------------------------------
// STEP 0: Selection
// -----------------------------------------------------------------------------
class _Step0Selection extends StatelessWidget {
  final AlbaPermitNotifier notifier;
  const _Step0Selection(this.notifier);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 12, 24, 64),
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF86EFAC), Color(0xFF93C5FD), Color(0xFFDBEAFE)]),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)), onPressed: () => Navigator.pop(context), style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.2), shape: const CircleBorder())),
                    Text('CUTY', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 14, color: const Color(0xFF0F172A))),
                ]),
                const SizedBox(height: 24),
                Text(AppLocalizations.of(context)!.permitLandingTitle, style: GoogleFonts.notoSansKr(fontSize: 22, fontWeight: FontWeight.w900, height: 1.2, color: const Color(0xFF0F172A))),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)!.permitLandingSubtitle, style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, height: 1.5, color: const Color(0xFF1E293B))),
            ]),
          ),
          Expanded(child: Transform.translate(offset: const Offset(0, -24), child: Container(padding: const EdgeInsets.fromLTRB(20, 32, 20, 20), decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28))), child: Column(children: [
             _SelectionCard(title: '쿠티에서 알바 찾기', subtitle: '아직 알바를 구하지 못했다면\n쿠티에서 구해봐요!', badgeText: 'CUTY', icon: Icons.shopping_bag_outlined, bgColor: const Color(0xFFBFDBFE), textColor: const Color(0xFF1E3A8A), onTap: () => Navigator.pop(context)),
             const SizedBox(height: 12),
             _SelectionCard(title: '내가 직접 찾은 알바', subtitle: '표준근로계약서 등 서류를\n직접 올려주세요.', badgeText: 'Upload', icon: Icons.upload_file, bgColor: const Color(0xFF1E3A8A), textColor: Colors.white, isDark: true, onTap: () => notifier.setStep(1)),
          ])))),
        ],
      ),
    );
  }
}
class _SelectionCard extends StatelessWidget {
  final String title, subtitle, badgeText;
  final IconData icon;
  final Color bgColor, textColor;
  final bool isDark;
  final VoidCallback onTap;
  const _SelectionCard({required this.title, required this.subtitle, required this.badgeText, required this.icon, required this.bgColor, required this.textColor, this.isDark = false, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(height: 112, padding: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.1) : Colors.white, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: isDark ? Colors.white : const Color(0xFF3B82F6), size: 24)), const SizedBox(width: 16), Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.2) : const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(10)), child: Text(badgeText, style: GoogleFonts.notoSansKr(fontSize: 9, fontWeight: FontWeight.w700, color: isDark ? const Color(0xFFDBEAFE) : Colors.white))), const SizedBox(height: 4), Text(title, style: GoogleFonts.notoSansKr(fontSize: 17, fontWeight: FontWeight.w800, color: textColor)), Text(subtitle, style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w500, color: textColor.withOpacity(0.8), height: 1.2))]))])));
  }
}

// -----------------------------------------------------------------------------
// STEP 1: Visa Link
// -----------------------------------------------------------------------------
class _Step1VisaLink extends StatefulWidget {
  final AlbaPermitNotifier notifier;
  final AlbaPermitState state;
  const _Step1VisaLink(this.notifier, this.state);

  @override
  State<_Step1VisaLink> createState() => _Step1VisaLinkState();
}

class _Step1VisaLinkState extends State<_Step1VisaLink> {
  bool _isAgreed = false;
  bool _isLoading = false;

  void _handleLink() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      widget.notifier.linkVisa();
      widget.notifier.nextStep(); // Auto-advance
      // setState(() => _isLoading = false); // No need as we leave screen
    }
  }

  @override
  Widget build(BuildContext context) {
    // If already linked, we usually auto-skip in logic, or just show normal view but button acts as next
    // But since user wants to skip the "success" screen, we treat isLinked as "just initialized".
    bool isLinked = widget.state.isVisaLinked;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), 
          onPressed: () => widget.notifier.setStep(0)
        ), 
        backgroundColor: Colors.white, 
        elevation: 0
      ),
      body: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6, 
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.blue.shade50, Colors.white]))
          ),
          Padding(
            padding: const EdgeInsets.all(24), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(AppLocalizations.of(context)!.permitLinkTitle, 
                  style: GoogleFonts.notoSansKr(fontSize: 26, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), height: 1.3)
                ),
                
                Expanded(
                  child: Center(
                    child: Stack(alignment: Alignment.center, children: [
                      Container(width: 250, height: 2, color: Colors.blue.shade100),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          _circleIcon('CUTY', Colors.blue.shade600),
                          _circleIcon('Wallet', Colors.indigo.shade600, icon: Icons.wallet),
                      ]),
                    ])
                  )
                ),

                // Consent Checkbox
                GestureDetector(
                    onTap: () => setState(() => _isAgreed = !_isAgreed),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _isAgreed ? Colors.blue : Colors.grey[300]!)
                      ),
                      child: Row(children: [
                        Icon(_isAgreed ? Icons.check_circle : Icons.radio_button_unchecked, color: _isAgreed ? Colors.blue : Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(child: Text(AppLocalizations.of(context)!.labelAgreeLink, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[800]))),
                      ]),
                    ),
                  ),

                SizedBox(
                  width: double.infinity, 
                  height: 60, 
                  child: ElevatedButton(
                    onPressed: (_isAgreed && !_isLoading) ? _handleLink : null, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B), 
                      disabledBackgroundColor: const Color(0xFFCBD5E1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ), 
                    child: _isLoading 
                      ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)), const SizedBox(width: 12), Text(AppLocalizations.of(context)!.btnLinking, style: const TextStyle(color: Colors.white, fontSize: 18))])
                      : Text(AppLocalizations.of(context)!.btnLinkSafe, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
                  )
                ),
                
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.security, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(AppLocalizations.of(context)!.msgSecurityFooter, style: GoogleFonts.notoSansKr(fontSize: 11, color: Colors.grey)),
                    ]),
                  )
              ]
            )
          )
      ]),
    );
  }

  Widget _circleIcon(String label, Color color, {IconData? icon}) {
    return Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.blue.shade100, blurRadius: 20)], border: Border.all(color: Colors.blue.shade50)), child: Center(child: icon == null ? Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 16, color: color)) : Icon(icon, color: color, size: 32)));
  }
}

// -----------------------------------------------------------------------------
// STEP 2: Guide
// -----------------------------------------------------------------------------
class _Step2Guide extends StatelessWidget {
  final AlbaPermitNotifier notifier;
  final AlbaPermitState state;
  const _Step2Guide(this.notifier, this.state);
  @override
  Widget build(BuildContext context) {
    bool isAllChecked = state.consentChecked && state.purposeChecked;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.permitEmployerGuideTitle), centerTitle: true, elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black, leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => notifier.prevStep())),
      body: Column(children: [
         Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
             Text(AppLocalizations.of(context)!.permitEmployerGuideSubtitle, style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), height: 1.3)),
             const SizedBox(height: 12),
              Text(AppLocalizations.of(context)!.permitEmployerGuideDesc, style: GoogleFonts.notoSansKr(fontSize: 14, color: const Color(0xFF64748B))),
             const SizedBox(height: 32),
             Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                 Text('촬영할 서류 리스트', style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))), const SizedBox(height: 12),
                  _listItem(1, AppLocalizations.of(context)!.docBusinessReg), const SizedBox(height: 8), _listItem(2, AppLocalizations.of(context)!.docLaborContract), const SizedBox(height: 8), _listItem(3, AppLocalizations.of(context)!.docEmployerId)
             ])),
             const SizedBox(height: 32),
              _checkbox(state.consentChecked, AppLocalizations.of(context)!.checkConsentPhoto, () => notifier.toggleConsent()), const SizedBox(height: 16),
              _checkbox(state.purposeChecked, AppLocalizations.of(context)!.checkConsentUsage, () => notifier.togglePurpose())
         ]))),
          Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).padding.bottom + 20), child: SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: isAllChecked ? () => notifier.nextStep() : null, style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: const Color(0xFF1A2B49), disabledBackgroundColor: Colors.grey[300], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.camera_alt, size: 20), const SizedBox(width: 8), Text(AppLocalizations.of(context)!.btnConfirmAndShoot, style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w700))]))))
      ]),
    );
  }
  Widget _listItem(int i, String t) => Row(children: [CircleAvatar(radius: 10, backgroundColor: Colors.black, child: Text('$i', style: const TextStyle(fontSize: 10, color: Colors.white))), const SizedBox(width: 12), Text(t, style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold, color: Colors.grey[800]))]);
  Widget _checkbox(bool c, String t, VoidCallback tap) => GestureDetector(onTap: tap, child: Row(children: [Container(width: 24, height: 24, decoration: BoxDecoration(color: c ? Colors.blue : Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: c ? Colors.blue : Colors.grey[300]!)), child: c ? const Icon(Icons.check, size: 16, color: Colors.white) : null), const SizedBox(width: 12), Expanded(child: Text(t, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight:  FontWeight.w500, color: c ? Colors.black : Colors.grey[500]!)))]));
}

// -----------------------------------------------------------------------------
// STEP 3: Camera
// -----------------------------------------------------------------------------
class _Step3Camera extends StatelessWidget {
  final AlbaPermitNotifier notifier;
  final AlbaPermitState state;
  const _Step3Camera(this.notifier, this.state);
  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': AppLocalizations.of(context)!.cameraHintBizReg, 'desc': AppLocalizations.of(context)!.cameraSubHintBiz},
      {'title': AppLocalizations.of(context)!.cameraHintContract, 'desc': AppLocalizations.of(context)!.cameraSubHintContract},
      {'title': AppLocalizations.of(context)!.cameraHintId, 'desc': AppLocalizations.of(context)!.cameraSubHintId}
    ];
    final current = steps[state.cameraStep];
    return Scaffold(backgroundColor: Colors.black, body: Stack(children: [
        Positioned(
          top: 0, left: 0, right: 0, 
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => notifier.prevStep()), 
                    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)), child: Text('촬영 ${state.cameraStep + 1}/3', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))
                  ]),
                ),
                Column(children: [
                  Text(current['title']!, textAlign: TextAlign.center, style: GoogleFonts.notoSansKr(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)), 
                  const SizedBox(height: 8), 
                  Text(current['desc']!, style: GoogleFonts.notoSansKr(fontSize: 14, color: Colors.white70))
                ])
              ],
            ),
          )
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: Container(width: MediaQuery.of(context).size.width * 0.8, height: MediaQuery.of(context).size.width * 0.8 * 1.4, decoration: BoxDecoration(border: Border.all(color: Colors.cyanAccent, width: 2), borderRadius: BorderRadius.circular(20)))
            ),
          )
        ),
        Positioned(bottom: 30, left: 0, right: 0, child: Center(child: GestureDetector(onTap: () { showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))); Future.delayed(const Duration(seconds: 1), () { Navigator.pop(context); notifier.advanceCameraStep(); }); }, child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)), child: Container(margin: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))))))
    ]));
  }
}

// -----------------------------------------------------------------------------
// STEP 4: Info Confirm
// -----------------------------------------------------------------------------
class _Step4InfoConfirm extends StatelessWidget {
  final AlbaPermitNotifier notifier;
  final AlbaPermitState state;
  const _Step4InfoConfirm(this.notifier, this.state);
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, appBar: AppBar(elevation: 0, backgroundColor: Colors.white, leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => notifier.prevStep())), body: Column(children: [
        Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(AppLocalizations.of(context)!.permitInfoCheckTitle, style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A))), 
          const SizedBox(height: 8), 
          Text(AppLocalizations.of(context)!.permitInfoCheckDesc, style: GoogleFonts.notoSansKr(fontSize: 14, color: const Color(0xFF64748B)))]
        )),
        Expanded(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 24), children: [
          _field(AppLocalizations.of(context)!.labelTradeName, state.companyName, notifier.updateCompanyName), 
          _field(AppLocalizations.of(context)!.labelBizRegNo, state.bizNo, notifier.updateBizNo), 
          _field(AppLocalizations.of(context)!.labelRepName, state.ownerName, notifier.updateOwnerName), 
          _field(AppLocalizations.of(context)!.labelBizAddress, state.address, notifier.updateAddress, maxLines: 2), 
          _field(AppLocalizations.of(context)!.labelHourlyWage, state.hourlyWage, notifier.updateHourlyWage), 
          _field(AppLocalizations.of(context)!.labelWorkTime, state.weekdayWork, notifier.updateWorkingHours), 
          const SizedBox(height: 30), 
        // Changed: Checkbox instead of badge
        _checkbox(state.infoCorrectChecked, AppLocalizations.of(context)!.checkInfoCorrect, () => notifier.toggleInfoCorrect()), const SizedBox(height: 20)])),
        Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).padding.bottom + 20), child: SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: state.infoCorrectChecked ? () => notifier.nextStep() : null, style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: const Color(0xFF1A2B49), disabledBackgroundColor: Colors.grey[300], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.work, size: 20), const SizedBox(width: 8), Text(AppLocalizations.of(context)!.btnInfoCorrectNext, style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.bold))]))))
    ]));
  }
  Widget _field(String l, String v, Function(String) c, {int maxLines = 1}) => Padding(padding: const EdgeInsets.only(bottom: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)), TextFormField(initialValue: v, onChanged: c, maxLines: maxLines, style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.bold), decoration: const InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)), suffixIcon: Icon(Icons.edit, size: 16)))]));
  
  Widget _checkbox(bool c, String t, VoidCallback tap) => GestureDetector(onTap: tap, child: Row(children: [Container(width: 24, height: 24, decoration: BoxDecoration(color: c ? Colors.blue : Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: c ? Colors.blue : Colors.grey[300]!)), child: c ? const Icon(Icons.check, size: 16, color: Colors.white) : null), const SizedBox(width: 12), Expanded(child: Text(t, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight:  FontWeight.w500, color: c ? Colors.black : Colors.grey[500]!)))]));
}

// -----------------------------------------------------------------------------
// STEP 5: Signature
// -----------------------------------------------------------------------------
class _Step5Signature extends StatefulWidget {
  final AlbaPermitNotifier notifier;
  final AlbaPermitState state;
  const _Step5Signature(this.notifier, this.state);
  @override State<_Step5Signature> createState() => _Step5SignatureState();
}
class _Step5SignatureState extends State<_Step5Signature> {
  bool _modal = false;
  @override Widget build(BuildContext context) {
    if (_modal) return _modalView();
    return Scaffold(backgroundColor: Colors.grey[100], appBar: AppBar(title: Text(AppLocalizations.of(context)!.permitSignTitle), centerTitle: true, elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black, leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => widget.notifier.prevStep())), body: Stack(children: [
        SingleChildScrollView(padding: const EdgeInsets.all(20), child: Container(padding: const EdgeInsets.all(24), color: Colors.white, child: Column(children: [
            Text(AppLocalizations.of(context)!.lblConfirmDocTitle, style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w900, decoration: TextDecoration.underline)),
            const SizedBox(height: 20),
            // Complex Table (Compact: Employer only per request)
            Table(border: TableBorder.all(color: Colors.black), columnWidths: const {0: FixedColumnWidth(80)}, children: [
              // 2. Employer Section ONLY
              TableRow(children: [
                 TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Container(height: 280, color: Colors.grey[50], alignment: Alignment.center, child: const Text("취업\n예정\n근무처", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)))), // This label is complex (vertical). I'll keep it hardcoded for now or I need a new key? User didn't provide "Working Place" label. Wait, let me check provided JSON. 
                 // JSON has: "tableCompany", "tableBizNo", etc. No "Working Place". 
                 // However, "취업 예정 근무처" is just a static label. Is it critical? User said "건드리지 말 것: Dynamic Data". This is static UI.
                 // I should check if I missed a key. No key "lblWorkingPlace" or similar.
                 // I will leave "취업\n예정\n근무처" hardcoded if no key corresponds.
                 // Actually, "tableCompany", "tableBizNo" are ROW headers.
                 // The "취업 예정 근무처" is the SECTION header on the left.
                 // Since I don't have a key, I will leave it or see if I can infer it. 
                 // I'll leave it as is to avoid inventing keys. The user provided SPECIFIC keys.
                 TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Column(children: [
                    _tableRow(AppLocalizations.of(context)!.tableCompany, widget.state.companyName),
                    Container(height: 1, color: Colors.black),
                    _tableRow(AppLocalizations.of(context)!.tableBizNo, widget.state.bizNo, labelWidth: 60),
                    Container(height: 1, color: Colors.black),
                    _tableRow(AppLocalizations.of(context)!.tableAddress, widget.state.address),
                    Container(height: 1, color: Colors.black),
                    // Signature Row
                    IntrinsicHeight(child: Row(children: [
                      Container(width: 80, padding: const EdgeInsets.all(8), alignment: Alignment.center, child: Text(AppLocalizations.of(context)!.tableEmployer, style: const TextStyle(fontWeight: FontWeight.bold))),
                      Container(width: 1, color: Colors.black),
                      // Display signature image when saved
                      Expanded(child: Container(height: 60, padding: EdgeInsets.zero, alignment: Alignment.center, child: widget.state.isSignatureSaved 
                        ? ClipRect(
                            child: SizedBox(
                                width: 100, height: 60,
                                child: CustomPaint(painter: _SignaturePainter(widget.state.signaturePoints))
                            )
                        )
                        : Text(AppLocalizations.of(context)!.holderSignOrSeal, style: const TextStyle(color: Colors.grey))
                      ))
                    ])),
                    Container(height: 1, color: Colors.black),
                    _tableRow(AppLocalizations.of(context)!.tablePeriod, widget.state.employmentPeriod),
                    Container(height: 1, color: Colors.black),
                    _tableRow(AppLocalizations.of(context)!.tableWage, widget.state.hourlyWage),
                 ]))
              ]),
            ]),
            // Removed bottom text as requested
            const SizedBox(height: 100)
        ]))),
        Positioned(bottom: 0, left: 0, right: 0, child: Container(padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 20), color: Colors.white, child: ElevatedButton(onPressed: () => widget.state.isSignatureSaved ? widget.notifier.nextStep() : setState(() => _modal = true), style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: const Color(0xFF1A2B49), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(widget.state.isSignatureSaved ? Icons.check : Icons.edit, size: 18), const SizedBox(width: 8), Text(widget.state.isSignatureSaved ? AppLocalizations.of(context)!.btnSignSubmit : AppLocalizations.of(context)!.btnSignEmployer, style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.bold))]))))
    ]));
  }
  Widget _tableRow(String label, String value, {double labelWidth = 80}) => IntrinsicHeight(child: Row(children: [Container(width: labelWidth, padding: const EdgeInsets.all(8), alignment: Alignment.center, child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))), Container(width: 1, color: Colors.black), Expanded(child: Container(padding: const EdgeInsets.all(8), alignment: Alignment.centerLeft, child: Text(value, style: const TextStyle(fontSize: 12))))]));
  Widget _modalView() => Scaffold(backgroundColor: Colors.black54, body: Align(alignment: Alignment.bottomCenter, child: Container(height: 480, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))), padding: const EdgeInsets.all(24), child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(AppLocalizations.of(context)!.lblEmployerSignTitle, style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.bold)), IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _modal = false))]), const SizedBox(height: 16), Expanded(child: Container(decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(12)), child: ClipRect(child: GestureDetector(onPanUpdate: (d) => widget.notifier.addSignaturePoint(d.localPosition), onPanEnd: (_) => widget.notifier.addSignaturePoint(null), child: CustomPaint(painter: _SignaturePainter(widget.state.signaturePoints), size: Size.infinite))))), const SizedBox(height: 16), Row(children: [Expanded(child: TextButton(onPressed: () => widget.notifier.clearSignature(), child: Text(AppLocalizations.of(context)!.actionClear))), const SizedBox(width: 12), Expanded(flex: 2, child: ElevatedButton(onPressed: () { widget.notifier.saveSignature(); setState(() => _modal = false); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), child: Text(AppLocalizations.of(context)!.actionSignComplete)))])]))));
}
class _SignaturePainter extends CustomPainter {
  final List<Offset?> p; _SignaturePainter(this.p);
  @override void paint(Canvas c, Size s) { 
    Paint paint = Paint()..color = Colors.black..strokeCap = StrokeCap.round..strokeWidth = 2.0;
    
    if (s.width < 200 && p.isNotEmpty) {
       double minX = double.infinity, minY = double.infinity, maxX = -double.infinity, maxY = -double.infinity;
       for (var o in p) { if (o != null) { if (o.dx < minX) minX = o.dx; if (o.dx > maxX) maxX = o.dx; if (o.dy < minY) minY = o.dy; if (o.dy > maxY) maxY = o.dy; } }
       if (minX != double.infinity) {
         double w = maxX - minX, h = maxY - minY;
         if (w == 0) w = 1; if (h == 0) h = 1;
         double scale = (s.width / w < s.height / h ? s.width / w : s.height / h) * 0.8;
         c.save();
         c.translate(s.width/2, s.height/2);
         c.scale(scale);
         c.translate(-(minX + w/2), -(minY + h/2));
         paint.strokeWidth = 2.0 / scale;
         for (int i = 0; i < p.length - 1; i++) {
           if (p[i] != null && p[i+1] != null) c.drawLine(p[i]!, p[i+1]!, paint);
         }
         c.restore();
         return;
       }
    }
    for (int i = 0; i < p.length - 1; i++) {
      if (p[i] != null && p[i+1] != null) c.drawLine(p[i]!, p[i+1]!, paint);
    } 
  }
  @override bool shouldRepaint(covariant CustomPainter o) => true;
}

// -----------------------------------------------------------------------------
// STEP 6: Submit Complete -> Wait for school
// -----------------------------------------------------------------------------
class _Step6SubmitComplete extends StatelessWidget {
  final AlbaPermitNotifier notifier;
  const _Step6SubmitComplete(this.notifier);
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () => notifier.nextStep());
    return Scaffold(backgroundColor: Colors.white, body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 80, height: 80, decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle), child: const Icon(Icons.mail, size: 40, color: Color(0xFF16A34A))),
      const SizedBox(height: 24),
      Text.rich(TextSpan(children: [TextSpan(text: AppLocalizations.of(context)!.permitSubmitSuccessTitle, style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A)))]), textAlign: TextAlign.center),
      const SizedBox(height: 12),
      Text(AppLocalizations.of(context)!.permitSubmitSuccessDesc, textAlign: TextAlign.center, style: GoogleFonts.notoSansKr(fontSize: 16, color: const Color(0xFF64748B))),
      const SizedBox(height: 48),
      const CircularProgressIndicator()
    ])));
  }
}

// -----------------------------------------------------------------------------
// STEP 7: School Approval
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// STEP 7: School Approval
// -----------------------------------------------------------------------------
class _Step7SchoolApproval extends StatelessWidget {
  final AlbaPermitNotifier notifier;
  const _Step7SchoolApproval(this.notifier);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white, leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => notifier.prevStep())),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Header
                    Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.yellow[100], shape: BoxShape.circle), child: Icon(Icons.celebration, size: 30, color: Colors.yellow[800])),
                    const SizedBox(height: 20),
                    Text(AppLocalizations.of(context)!.permitSchoolApprovedTitle, textAlign: TextAlign.center, style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900, height: 1.3, color: const Color(0xFF0F172A))),
                    const SizedBox(height: 32),
                    // Document Placeholder
                    Container(
                      width: 200, // Slightly smaller
                      height: 282, // A4 aspect ratio
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))
                        ]
                      ),
                      child: Column(
                        children: [
                           // Mock Document Content
                           Container(height: 40, decoration: BoxDecoration(color: Colors.grey[50], borderRadius: const BorderRadius.vertical(top: Radius.circular(8))), alignment: Alignment.center, child: Text(AppLocalizations.of(context)!.badgeSchoolApproved, style: GoogleFonts.notoSansKr(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[500]))),
                           Expanded(
                             child: Center(
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Icon(Icons.check_circle, size: 40, color: Colors.green[100]),
                                   const SizedBox(height: 8),
                                   Text(AppLocalizations.of(context)!.lblPartTimeConfirmDoc, textAlign: TextAlign.center, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[400])),
                                 ],
                               ),
                             ),
                           ),
                           // Mock Lines
                           Padding(padding: const EdgeInsets.all(16), child: Column(children: [
                             Container(height: 6, width: double.infinity, color: Colors.grey[100]),
                             const SizedBox(height: 4),
                             Container(height: 6, width: 120, color: Colors.grey[100]),
                           ]))
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Bottom Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => notifier.nextStep(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.btnCheckIntegratedDocs, style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STEP 8: Final Folder (PDF Download)
// -----------------------------------------------------------------------------
class _Step8FinalFolder extends StatelessWidget {
  final AlbaPermitNotifier notifier;
  final AlbaPermitState state;
  const _Step8FinalFolder(this.notifier, this.state);
  @override
  Widget build(BuildContext context) {
    if (state.isPdfDownloaded) Future.delayed(const Duration(seconds: 1), () => notifier.nextStep());
    final docs = [
      AppLocalizations.of(context)!.docPartTimeConfirm, 
      AppLocalizations.of(context)!.docStdContract, 
      AppLocalizations.of(context)!.docBizRegCopy, 
      AppLocalizations.of(context)!.docArcCopy, 
      AppLocalizations.of(context)!.docPassportCopy, 
      AppLocalizations.of(context)!.docEnrollmentCert, 
      AppLocalizations.of(context)!.docTranscript, 
      AppLocalizations.of(context)!.docTopikCert, 
      AppLocalizations.of(context)!.docApplicationForm, 
      AppLocalizations.of(context)!.docPowerOfAttorney, 
      AppLocalizations.of(context)!.docEtc
    ];
    return Scaffold(backgroundColor: Colors.white, appBar: AppBar(title: Text(AppLocalizations.of(context)!.permitFinalDocTitle), centerTitle: true, elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black, leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => notifier.prevStep())), body: Column(children: [
       Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.check, size: 12, color: Colors.blue), const SizedBox(width: 4), Text(AppLocalizations.of(context)!.badgeFinalDocCompleted, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12))])),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.permitFinalDocSubtitle, textAlign: TextAlign.center, style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 30),
          Container(width: 160, height: 200, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))], border: Border.all(color: Colors.blue.shade100)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.folder_open, size: 60, color: Colors.blue), const SizedBox(height: 12), const Text("FINAL DOCUMENT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)), Text(AppLocalizations.of(context)!.labelFinalPdf, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)), const SizedBox(height: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), color: Colors.grey[100], child: const Text("(PDF / 3.2MB)", style: TextStyle(fontSize: 10, color: Colors.grey)))] )),
          const SizedBox(height: 40),
          Align(alignment: Alignment.centerLeft, child: Text(AppLocalizations.of(context)!.lblIncludedDocs, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]))),
          const SizedBox(height: 12),
          Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(12)), child: Column(children: docs.asMap().entries.map((e) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))), child: Row(children: [Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.description, size: 14, color: Colors.blue)), const SizedBox(width: 12), Expanded(child: Text(e.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))), const Icon(Icons.check, size: 16, color: Colors.blue)]))).toList()))
       ]))),
       Padding(padding: const EdgeInsets.all(20), child: SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: () => notifier.downloadPdf(), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A2B49), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: state.isPdfDownloaded ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(AppLocalizations.of(context)!.btnMovingToGuide, style: const TextStyle(color: Colors.white)), const SizedBox(width: 8), const Icon(Icons.chevron_right, color: Colors.white)]) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.download, color: Colors.white), const SizedBox(width: 8), Text(AppLocalizations.of(context)!.btnDownloadPdfGuide, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))])))),
    ]));
  }
}

// -----------------------------------------------------------------------------
// STEP 9: HiKorea Guide
// -----------------------------------------------------------------------------
class _Step9HiKoreaGuide extends StatelessWidget {
  final AlbaPermitNotifier notifier;
  const _Step9HiKoreaGuide(this.notifier);
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, appBar: AppBar(title: Text(AppLocalizations.of(context)!.permitGuideTitle), centerTitle: true, elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black, leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => notifier.prevStep())), body: Column(children: [
       Expanded(child: ListView(padding: const EdgeInsets.all(24), children: [
          Text(AppLocalizations.of(context)!.permitGuideSubtitle, style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black)),
          const SizedBox(height: 8),
          const Text("복잡한 과정은 쿠티가 다 끝냈어요.\n가이드에 따라 1분 만에 접수해보세요.", style: TextStyle(color: Colors.grey, fontSize: 13)), // This static text was not in the provided JSON effectively (except maybe implied). But I will leave it or see if I can use similar key? No. User didn't provide key for this specific line. "Guide Step 1" starts below. I'll leave it hardcoded as it wasn't explicitly forbidden (only user data) but better to leave it.
          const SizedBox(height: 30),
          _step(1, AppLocalizations.of(context)!.guideStep1, icon: Icons.public, child: Container(margin: const EdgeInsets.only(top: 12), height: 160, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Text("하이코리아 홈페이지 캡쳐 이미지\n(추후 삽입 예정)", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)))) ,
          _step(2, AppLocalizations.of(context)!.guideStep2, icon: Icons.mouse, child: Container(margin: const EdgeInsets.only(top: 12), height: 160, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Text("민원선택 화면 캡쳐 이미지\n(추후 삽입 예정)", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)))),
          _step(3, AppLocalizations.of(context)!.guideStep3, highlight: true, desc: AppLocalizations.of(context)!.guideStep3Desc, icon: Icons.folder_zip, child: Container(margin: const EdgeInsets.only(top: 12), height: 160, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Text("서류 업로드 화면 캡쳐 이미지\n(추후 삽입 예정)", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)))),
          _step(4, AppLocalizations.of(context)!.guideStep4, child: GestureDetector(
            onTap: () { /* Todo: Implement Upload */ },
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200, style: BorderStyle.none), // Placeholder for dashed border if needed, or just solid
              ),
              child: Container(
                   width: double.infinity,
                   height: double.infinity,
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.blue.shade300, width: 1.5),
                     borderRadius: BorderRadius.circular(12),
                     color: Colors.blue.shade50
                   ),
                   child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                     Icon(Icons.camera_alt, color: Colors.blue.shade300, size: 32),
                     const SizedBox(height: 8),
                     Text(AppLocalizations.of(context)!.btnUploadReceipt, style: TextStyle(color: Colors.blue.shade400, fontWeight: FontWeight.bold))
                   ]))
              )
            )
          )),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.amber[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber[100]!)), child: Row(children: [Icon(Icons.lightbulb, color: Colors.amber[700], size: 20), const SizedBox(width: 12), Expanded(child: Text(AppLocalizations.of(context)!.tipSubmissionTime, style: const TextStyle(fontSize: 12, color: Colors.brown)))]))
       ])),
       Padding(padding: const EdgeInsets.all(20), child: SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: () => notifier.nextStep(), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A2B49), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: Text(AppLocalizations.of(context)!.btnAppliedNext, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))))
    ]));
  }
  Widget _step(int i, String t, {bool highlight = false, String? desc, IconData? icon, Widget? child}) => Padding(padding: const EdgeInsets.only(bottom: 24), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: highlight ? Colors.blue : Colors.white, border: Border.all(color: highlight ? Colors.blue : Colors.grey[300]!), shape: BoxShape.circle), alignment: Alignment.center, child: Text("$i", style: TextStyle(color: highlight ? Colors.white : Colors.grey, fontWeight: FontWeight.bold))), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Flexible(child: Text(t, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: highlight ? Colors.blue : Colors.black))), if (icon != null) Padding(padding: const EdgeInsets.only(left: 8), child: Icon(icon, size: 16, color: Colors.grey))]), if (desc != null) Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)), child: Text(desc, style: const TextStyle(fontSize: 12, color: Colors.blue))), if (child != null) child]))]));
}

// -----------------------------------------------------------------------------
// STEP 10: Final Permit
// -----------------------------------------------------------------------------
class _Step10FinalPermit extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(backgroundColor: Colors.white, body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
       Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.yellow[100], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.yellow[200]!)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.verified, size: 14, color: Colors.yellow[900]), const SizedBox(width: 4), Text(AppLocalizations.of(context)!.badgeFinalApproved, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.yellow[900]))])),
       const SizedBox(height: 30),
       Stack(clipBehavior: Clip.none, children: [
         Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.indigo[50], shape: BoxShape.circle), child: const Icon(Icons.confirmation_number, size: 50, color: Colors.indigo)),
         const Positioned(bottom: 0, right: 0, child: CircleAvatar(backgroundColor: Colors.green, radius: 14, child: Icon(Icons.check, color: Colors.white, size: 16)))
       ]),
       const SizedBox(height: 24),
       Text(AppLocalizations.of(context)!.permitCongratsTitle, textAlign: TextAlign.center, style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900)),
       const SizedBox(height: 12),
       Text(AppLocalizations.of(context)!.permitCongratsDesc, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
       const SizedBox(height: 40),
       Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
         Row(children: [const Icon(Icons.lightbulb, color: Colors.amber, size: 20), const SizedBox(width: 8), Text(AppLocalizations.of(context)!.tipWorkStartTitle, style: const TextStyle(fontWeight: FontWeight.bold))]),
         const SizedBox(height: 12),
         Text("• ${AppLocalizations.of(context)!.tipWorkStart1}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
         const SizedBox(height: 4),
         Text("• ${AppLocalizations.of(context)!.tipWorkStart2}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
         const SizedBox(height: 4),
         Text("• ${AppLocalizations.of(context)!.tipWorkStart3}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
       ])),
       const SizedBox(height: 40),
       SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: () { 
          // Reset application state and then pop
          ref.read(albaPermitProvider.notifier).resetApplication();
          Navigator.pop(context);
       }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A2B49), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: Text(AppLocalizations.of(context)!.btnCheckMyVisa, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))
    ]))));
  }
}

// -----------------------------------------------------------------------------
// STEP 2: Document Check (NEW)
// -----------------------------------------------------------------------------
class _StepCheckDocs extends ConsumerWidget {
  final AlbaPermitNotifier notifier;
  const _StepCheckDocs(this.notifier);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch Document Provider for real-time updates
    ref.watch(documentProvider); 
    final missingDocs = ref.read(documentProvider.notifier).hasRequiredDocsForPartTime();
    final isComplete = missingDocs.isEmpty;
    final requiredDocs = ['외국인등록증', '여권', '성적증명서', '토픽증명서', '거주지 증빙'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.permitChecklistTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => notifier.prevStep(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                      AppLocalizations.of(context)!.permitChecklistDesc.split('\n')[0],
                      style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4, color: const Color(0xFF111827)),
                   ),
                   const SizedBox(height: 12),
                   Text(
                       AppLocalizations.of(context)!.permitChecklistDesc.split('\n').last,
                       style: GoogleFonts.notoSansKr(fontSize: 16, color: const Color(0xFF6B7280), height: 1.5),
                   ),
                   const SizedBox(height: 32),
                   Container(
                     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
                     child: Column(
                       children: requiredDocs.map((doc) {
                         final isMissing = missingDocs.contains(doc);
                         final isLast = doc == requiredDocs.last;
                         return Column(
                           children: [
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                               child: Row(
                                 children: [
                                   Container(width: 24, height: 24, decoration: BoxDecoration(color: isMissing ? const Color(0xFFF3F4F6) : const Color(0xFFDCFCE7), shape: BoxShape.circle), child: Icon(isMissing ? Icons.remove : Icons.check, size: 16, color: isMissing ? const Color(0xFF9CA3AF) : const Color(0xFF16A34A))),
                                   const SizedBox(width: 16),
                                   Expanded(child: Text(doc, style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w500, color: isMissing ? const Color(0xFF9CA3AF) : const Color(0xFF1F2937)))),
                                   Text(isMissing ? AppLocalizations.of(context)!.statusNotRegistered : AppLocalizations.of(context)!.statusVerified, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700, color: isMissing ? const Color(0xFFEF4444) : const Color(0xFF16A34A))),
                                 ],
                               ),
                             ),
                             if (!isLast) const Divider(height: 1, color: Color(0xFFF3F4F6)),
                           ],
                         );
                       }).toList(),
                     ),
                   ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFE5E7EB)))),
            child: Column(
              children: [
                if (!isComplete) ...[
                  SizedBox(width: double.infinity, height: 56, child: OutlinedButton(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecWalletScreen())); }, style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF3B82F6)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: Text(AppLocalizations.of(context)!.btnFillDocuments, style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF3B82F6))))),
                  const SizedBox(height: 12),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isComplete ? () => notifier.nextStep() : null,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), disabledBackgroundColor: const Color(0xFFF3F4F6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                    child: Text(isComplete ? AppLocalizations.of(context)!.btnInfoCorrectNext : AppLocalizations.of(context)!.btnPrepareLater, style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w700, color: isComplete ? Colors.white : const Color(0xFF9CA3AF))),
                  ),
                ),
                if (!isComplete)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextButton(
                      onPressed: () => notifier.nextStep(),
                      child: Text(AppLocalizations.of(context)!.linkSkipToEmployer, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600], decoration: TextDecoration.underline)),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
