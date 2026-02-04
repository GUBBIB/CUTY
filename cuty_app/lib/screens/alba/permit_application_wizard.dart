import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart'; // simulation for now
import '../../providers/alba_permit_provider.dart';
import '../../providers/document_provider.dart';
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
                Text('시간제 취업 허가\n준비하기', style: GoogleFonts.notoSansKr(fontSize: 22, fontWeight: FontWeight.w900, height: 1.2, color: const Color(0xFF0F172A))),
                const SizedBox(height: 8),
                Text('어떤 방식으로 알바를 구하셨나요?\n쿠티가 서류 준비를 도와드릴게요!', style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, height: 1.5, color: const Color(0xFF1E293B))),
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
                Text.rich(
                  TextSpan(children: [
                    const TextSpan(text: '안전한 서류 준비를 위해\n'), 
                    TextSpan(text: '비자 정보', style: GoogleFonts.notoSansKr(color: const Color(0xFF2563EB))), 
                    const TextSpan(text: '를\n연동해주세요.')
                  ]), 
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
                        Expanded(child: Text("MY에 저장된 비자지갑 데이터를\n안전하게 불러오는 것에 동의합니다.", style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[800]))),
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
                      ? Row(mainAxisAlignment: MainAxisAlignment.center, children: const [SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)), SizedBox(width: 12), Text("연동 중...", style: TextStyle(color: Colors.white, fontSize: 18))])
                      : const Text("비자지갑 안전하게 연동하기", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
                  )
                ),
                
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.security, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("CUTY는 고객님의 개인정보를 안전하게 보호합니다.", style: GoogleFonts.notoSansKr(fontSize: 11, color: Colors.grey)),
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
      appBar: AppBar(title: const Text('사업자 서류 촬영 안내'), centerTitle: true, elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black, leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => notifier.prevStep())),
      body: Column(children: [
         Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
             Text.rich(TextSpan(children: [const TextSpan(text: '일하게 된 곳의\n'), TextSpan(text: '사업자 서류', style: GoogleFonts.notoSansKr(color: const Color(0xFF2563EB))), const TextSpan(text: '를 준비해주세요.')]), style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), height: 1.3)),
             const SizedBox(height: 12),
             Text('사장님께 아래 3가지 서류의 촬영 동의를 구해주세요.', style: GoogleFonts.notoSansKr(fontSize: 14, color: const Color(0xFF64748B))),
             const SizedBox(height: 32),
             Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                 Text('촬영할 서류 리스트', style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))), const SizedBox(height: 12),
                 _listItem(1, '사업자 등록증'), const SizedBox(height: 8), _listItem(2, '근로계약서'), const SizedBox(height: 8), _listItem(3, '사업주 신분증 사본')
             ])),
             const SizedBox(height: 32),
             _checkbox(state.consentChecked, '(필수) 사장님께 위 서류들의 촬영 동의를 구했습니다.', () => notifier.toggleConsent()), const SizedBox(height: 16),
             _checkbox(state.purposeChecked, '(필수) 수집된 정보는 취업 허가 신청 목적으로만 사용됩니다.', () => notifier.togglePurpose())
         ]))),
         Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).padding.bottom + 20), child: SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: isAllChecked ? () => notifier.nextStep() : null, style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: const Color(0xFF1A2B49), disabledBackgroundColor: Colors.grey[300], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.camera_alt, size: 20), const SizedBox(width: 8), Text('확인했습니다. 촬영하기', style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w700))]))))
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
    final steps = [{'title': '먼저, 사업자등록증을\n찍어주세요.', 'desc': '사업자 번호가 잘 보이게 찍어주세요.'}, {'title': '다음은 근로계약서입니다.', 'desc': '글자가 잘 보이게 찍어주세요.'}, {'title': '마지막으로 사업주 신분증을\n찍어주세요.', 'desc': '주민등록번호 뒷자리는 가려도 됩니다.'}];
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
        Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text.rich(TextSpan(children: [const TextSpan(text: '거의 다 됐어요!\n'), TextSpan(text: '정보', style: GoogleFonts.notoSansKr(color: const Color(0xFF2563EB))), const TextSpan(text: '를 확인해주세요.')]), style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A))), const SizedBox(height: 8), Text('사업자등록증 내용을 바탕으로\n자동 입력된 정보입니다.', style: GoogleFonts.notoSansKr(fontSize: 14, color: const Color(0xFF64748B)))])),
        Expanded(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 24), children: [_field('상호명', state.companyName, notifier.updateCompanyName), _field('사업자 등록번호', state.bizNo, notifier.updateBizNo), _field('대표자명', state.ownerName, notifier.updateOwnerName), _field('사업자 주소', state.address, notifier.updateAddress, maxLines: 2), _field('시급', state.hourlyWage, notifier.updateHourlyWage), _field('근무 시간', state.weekdayWork, notifier.updateWorkingHours), const SizedBox(height: 30), 
        // Changed: Checkbox instead of badge
        _checkbox(state.infoCorrectChecked, '(필수) 기입된 정보가 맞아요', () => notifier.toggleInfoCorrect()), const SizedBox(height: 20)])),
        Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).padding.bottom + 20), child: SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: state.infoCorrectChecked ? () => notifier.nextStep() : null, style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: const Color(0xFF1A2B49), disabledBackgroundColor: Colors.grey[300], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.work, size: 20), const SizedBox(width: 8), Text('정보가 맞아요 (다음)', style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.bold))]))))
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
    return Scaffold(backgroundColor: Colors.grey[100], appBar: AppBar(title: const Text('전자 서명'), centerTitle: true, elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black, leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => widget.notifier.prevStep())), body: Stack(children: [
        SingleChildScrollView(padding: const EdgeInsets.all(20), child: Container(padding: const EdgeInsets.all(24), color: Colors.white, child: Column(children: [
            Text("외국인유학생 시간제취업 확인서", style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w900, decoration: TextDecoration.underline)),
            const SizedBox(height: 20),
            // Complex Table (Compact: Employer only per request)
            Table(border: TableBorder.all(color: Colors.black), columnWidths: const {0: FixedColumnWidth(80)}, children: [
              // 2. Employer Section ONLY
              TableRow(children: [
                 TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Container(height: 280, color: Colors.grey[50], alignment: Alignment.center, child: const Text("취업\n예정\n근무처", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)))),
                 TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Column(children: [
                    _tableRow("업 체 명", widget.state.companyName),
                    Container(height: 1, color: Colors.black),
                    _tableRow("사업자\n등록번호", widget.state.bizNo, labelWidth: 60),
                    Container(height: 1, color: Colors.black),
                    _tableRow("주 소", widget.state.address),
                    Container(height: 1, color: Colors.black),
                    // Signature Row
                    IntrinsicHeight(child: Row(children: [
                      Container(width: 80, padding: const EdgeInsets.all(8), alignment: Alignment.center, child: const Text("고 용 주", style: TextStyle(fontWeight: FontWeight.bold))),
                      Container(width: 1, color: Colors.black),
                      // Display signature image when saved
                      Expanded(child: Container(height: 60, padding: EdgeInsets.zero, alignment: Alignment.center, child: widget.state.isSignatureSaved 
                        ? ClipRect(
                            child: SizedBox(
                                width: 100, height: 60,
                                child: CustomPaint(painter: _SignaturePainter(widget.state.signaturePoints))
                            )
                        )
                        : const Text("(인 또는 서명)", style: TextStyle(color: Colors.grey))
                      ))
                    ])),
                    Container(height: 1, color: Colors.black),
                    _tableRow("취업기간", widget.state.employmentPeriod),
                    Container(height: 1, color: Colors.black),
                    _tableRow("급여(시급)", widget.state.hourlyWage),
                 ]))
              ]),
            ]),
            // Removed bottom text as requested
            const SizedBox(height: 100)
        ]))),
        Positioned(bottom: 0, left: 0, right: 0, child: Container(padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 20), color: Colors.white, child: ElevatedButton(onPressed: () => widget.state.isSignatureSaved ? widget.notifier.nextStep() : setState(() => _modal = true), style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: const Color(0xFF1A2B49), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(widget.state.isSignatureSaved ? Icons.check : Icons.edit, size: 18), const SizedBox(width: 8), Text(widget.state.isSignatureSaved ? "서명 완료 및 제출하기" : "사업주 서명하기", style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.bold))]))))
    ]));
  }
  Widget _tableRow(String label, String value, {double labelWidth = 80}) => IntrinsicHeight(child: Row(children: [Container(width: labelWidth, padding: const EdgeInsets.all(8), alignment: Alignment.center, child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))), Container(width: 1, color: Colors.black), Expanded(child: Container(padding: const EdgeInsets.all(8), alignment: Alignment.centerLeft, child: Text(value, style: const TextStyle(fontSize: 12))))]));
  Widget _modalView() => Scaffold(backgroundColor: Colors.black54, body: Align(alignment: Alignment.bottomCenter, child: Container(height: 480, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))), padding: const EdgeInsets.all(24), child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("고용주 서명", style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.bold)), IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _modal = false))]), const SizedBox(height: 16), Expanded(child: Container(decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(12)), child: ClipRect(child: GestureDetector(onPanUpdate: (d) => widget.notifier.addSignaturePoint(d.localPosition), onPanEnd: (_) => widget.notifier.addSignaturePoint(null), child: CustomPaint(painter: _SignaturePainter(widget.state.signaturePoints), size: Size.infinite))))), const SizedBox(height: 16), Row(children: [Expanded(child: TextButton(onPressed: () => widget.notifier.clearSignature(), child: const Text("지우기"))), const SizedBox(width: 12), Expanded(flex: 2, child: ElevatedButton(onPressed: () { widget.notifier.saveSignature(); setState(() => _modal = false); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), child: const Text("서명 완료")))])]))));
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
      Text.rich(TextSpan(children: [const TextSpan(text: '서류 제출 완료!\n'), TextSpan(text: 'CUTY가 확인하고 있어요.', style: TextStyle(color: Colors.blue))], style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A))), textAlign: TextAlign.center),
      const SizedBox(height: 12),
      Text('검토는 영업일 기준 1일 내에 완료됩니다.', textAlign: TextAlign.center, style: GoogleFonts.notoSansKr(fontSize: 16, color: const Color(0xFF64748B))),
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
                    Text("와우!\n학교 승인이 완료되었어요! 🎉", textAlign: TextAlign.center, style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900, height: 1.3, color: const Color(0xFF0F172A))),
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
                           Container(height: 40, decoration: BoxDecoration(color: Colors.grey[50], borderRadius: const BorderRadius.vertical(top: Radius.circular(8))), alignment: Alignment.center, child: Text("학교 승인 완료", style: GoogleFonts.notoSansKr(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[500]))),
                           Expanded(
                             child: Center(
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Icon(Icons.check_circle, size: 40, color: Colors.green[100]),
                                   const SizedBox(height: 8),
                                   Text("시간제 취업 확인서", textAlign: TextAlign.center, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[400])),
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
                      Text("통합 서류 확인하러 가기", style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
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
    final docs = ["외국인 유학생 시간제 취업 확인서", "표준근로계약서", "사업자등록증 사본", "외국인등록증 (앞/뒤)", "여권 사본", "재학증명서", "성적증명서", "TOPIK 한국어능력시험 성적표", "통합 신청서 (신고서)", "위임장 (신고자용)", "기타 구비 서류"];
    return Scaffold(backgroundColor: Colors.white, appBar: AppBar(title: const Text("최종 서류 통합"), centerTitle: true, elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black, leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => notifier.prevStep())), body: Column(children: [
       Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.check, size: 12, color: Colors.blue), SizedBox(width: 4), Text("11종 서류 통합 완료", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12))])),
          const SizedBox(height: 16),
          Text.rich(TextSpan(children: [const TextSpan(text: "따로따로 준비할 필요 없이\n"), TextSpan(text: "하나의 PDF", style: TextStyle(color: Colors.blue)), const TextSpan(text: "로 묶었어요")]), textAlign: TextAlign.center, style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 30),
          Container(width: 160, height: 200, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))], border: Border.all(color: Colors.blue.shade100)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.folder_open, size: 60, color: Colors.blue), const SizedBox(height: 12), const Text("FINAL DOCUMENT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)), const Text("✨ CUTY\n통합 신청 폴더", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)), const SizedBox(height: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), color: Colors.grey[100], child: const Text("(PDF / 3.2MB)", style: TextStyle(fontSize: 10, color: Colors.grey)))] )),
          const SizedBox(height: 40),
          Align(alignment: Alignment.centerLeft, child: Text(" 포함된 서류 목록", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]))),
          const SizedBox(height: 12),
          Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(12)), child: Column(children: docs.asMap().entries.map((e) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))), child: Row(children: [Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.description, size: 14, color: Colors.blue)), const SizedBox(width: 12), Expanded(child: Text(e.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))), const Icon(Icons.check, size: 16, color: Colors.blue)]))).toList()))
       ]))),
       Padding(padding: const EdgeInsets.all(20), child: SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: () => notifier.downloadPdf(), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A2B49), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: state.isPdfDownloaded ? Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Text("가이드 페이지로 이동 중...", style: TextStyle(color: Colors.white)), SizedBox(width: 8), Icon(Icons.chevron_right, color: Colors.white)]) : Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.download, color: Colors.white), SizedBox(width: 8), Text("통합 PDF 다운로드 및 접수 가이드", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))])))),
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
    return Scaffold(backgroundColor: Colors.white, appBar: AppBar(title: const Text("신청 가이드"), centerTitle: true, elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black, leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => notifier.prevStep())), body: Column(children: [
       Expanded(child: ListView(padding: const EdgeInsets.all(24), children: [
          Text.rich(TextSpan(children: [const TextSpan(text: "이제 "), TextSpan(text: "하이코리아", style: TextStyle(color: Colors.blue)), const TextSpan(text: "에서\n서류만 올리면 끝나요!")]), style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text("복잡한 과정은 쿠티가 다 끝냈어요.\n가이드에 따라 1분 만에 접수해보세요.", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 30),
          _step(1, "하이코리아 접속 및 로그인", icon: Icons.public, child: Container(margin: const EdgeInsets.only(top: 12), height: 160, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Text("하이코리아 홈페이지 캡쳐 이미지\n(추후 삽입 예정)", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)))) ,
          _step(2, "민원선택 > 시간제취업 허가 클릭", icon: Icons.mouse, child: Container(margin: const EdgeInsets.only(top: 12), height: 160, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Text("민원선택 화면 캡쳐 이미지\n(추후 삽입 예정)", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)))),
          _step(3, "서류 업로드 (가장 중요!)", highlight: true, desc: "방금 다운로드한 'CUTY 통합 신청 패키지.pdf' 하나만 올리면 끝!\n(재학/성적증명서, 신분증, 계약서 등 포함됨)", icon: Icons.folder_zip, child: Container(margin: const EdgeInsets.only(top: 12), height: 160, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Text("서류 업로드 화면 캡쳐 이미지\n(추후 삽입 예정)", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)))),
          _step(4, "접수 완료 및 접수증 업로드", child: GestureDetector(
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
                     Text("접수증 캡쳐본 올리기", style: TextStyle(color: Colors.blue.shade400, fontWeight: FontWeight.bold))
                   ]))
              )
            )
          )),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.amber[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber[100]!)), child: Row(children: [Icon(Icons.lightbulb, color: Colors.amber[700], size: 20), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text("접수 꿀팁", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.brown)), Text("평일 오전 9시 ~ 오후 6시 사이에 신청하면 처리가 빨라요.", style: TextStyle(fontSize: 12, color: Colors.brown))]))]))
       ])),
       Padding(padding: const EdgeInsets.all(20), child: SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: () => notifier.nextStep(), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A2B49), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text("신청 완료했어요 (다음)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))))
    ]));
  }
  Widget _step(int i, String t, {bool highlight = false, String? desc, IconData? icon, Widget? child}) => Padding(padding: const EdgeInsets.only(bottom: 24), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: highlight ? Colors.blue : Colors.white, border: Border.all(color: highlight ? Colors.blue : Colors.grey[300]!), shape: BoxShape.circle), alignment: Alignment.center, child: Text("$i", style: TextStyle(color: highlight ? Colors.white : Colors.grey, fontWeight: FontWeight.bold))), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text(t, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: highlight ? Colors.blue : Colors.black)), if (icon != null) Padding(padding: const EdgeInsets.only(left: 8), child: Icon(icon, size: 16, color: Colors.grey))]), if (desc != null) Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)), child: Text(desc, style: const TextStyle(fontSize: 12, color: Colors.blue))), if (child != null) child]))]));
}

// -----------------------------------------------------------------------------
// STEP 10: Final Permit
// -----------------------------------------------------------------------------
class _Step10FinalPermit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
       Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.yellow[100], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.yellow[200]!)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.verified, size: 14, color: Colors.yellow[900]), const SizedBox(width: 4), Text("최종 허가 완료", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.yellow[900]))])),
       const SizedBox(height: 30),
       Stack(clipBehavior: Clip.none, children: [
         Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.indigo[50], shape: BoxShape.circle), child: const Icon(Icons.confirmation_number, size: 50, color: Colors.indigo)),
         const Positioned(bottom: 0, right: 0, child: CircleAvatar(backgroundColor: Colors.green, radius: 14, child: Icon(Icons.check, color: Colors.white, size: 16)))
       ]),
       const SizedBox(height: 24),
       Text.rich(TextSpan(children: [const TextSpan(text: "축하합니다!\n이제 바로 "), TextSpan(text: "일할 수 있어요!", style: TextStyle(color: Colors.indigo)), const TextSpan(text: " 🥳")]), textAlign: TextAlign.center, style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.w900)),
       const SizedBox(height: 12),
       const Text("성공적인 아르바이트 생활을\nCUTY가 응원합니다.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
       const SizedBox(height: 40),
       Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
         Row(children: const [Icon(Icons.lightbulb, color: Colors.amber, size: 20), SizedBox(width: 8), Text("아르바이트 시작 전 꿀팁!", style: TextStyle(fontWeight: FontWeight.bold))]),
         const SizedBox(height: 12),
         const Text("• 학기 중 주당 25시간 이내로 근무해야 해요.", style: TextStyle(fontSize: 12, color: Colors.grey)),
         const SizedBox(height: 4),
         const Text("• 주휴수당은 주 15시간 이상 근무 시 받을 수 있어요.", style: TextStyle(fontSize: 12, color: Colors.grey)),
         const SizedBox(height: 4),
         const Text("• 근로계약서는 꼭 보관해두세요!", style: TextStyle(fontSize: 12, color: Colors.grey)),
       ])),
       const SizedBox(height: 40),
       SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A2B49), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text("내 비자 상태 확인하기 (완료)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))
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
        title: const Text("필수 서류 확인", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                     "시간제 취업 허가를 위해\n필수 서류를 확인합니다.",
                     style: GoogleFonts.notoSansKr(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4, color: const Color(0xFF111827)),
                   ),
                   const SizedBox(height: 12),
                   Text(
                     "스펙 지갑에 등록된 서류 정보를\n자동으로 불러왔어요.",
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
                                   Text(isMissing ? "미등록" : "인증 완료", style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700, color: isMissing ? const Color(0xFFEF4444) : const Color(0xFF16A34A))),
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
                  SizedBox(width: double.infinity, height: 56, child: OutlinedButton(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecWalletScreen())); }, style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF3B82F6)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: Text("부족한 서류 채우러 가기", style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF3B82F6))))),
                  const SizedBox(height: 12),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isComplete ? () => notifier.nextStep() : null,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), disabledBackgroundColor: const Color(0xFFF3F4F6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                    child: Text(isComplete ? "다음 단계로" : "서류 준비가 필요해요", style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w700, color: isComplete ? Colors.white : const Color(0xFF9CA3AF))),
                  ),
                ),
                if (!isComplete)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextButton(
                      onPressed: () => notifier.nextStep(),
                      child: Text("나중에 서류 채울게요 (사업주 먼저)", style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600], decoration: TextDecoration.underline)),
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
