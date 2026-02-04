import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/f27_visa_provider.dart';

class F27VisaCalculatorScreen extends StatefulWidget {
  const F27VisaCalculatorScreen({super.key});

  @override
  State<F27VisaCalculatorScreen> createState() => _F27VisaCalculatorScreenState();
}

class _F27VisaCalculatorScreenState extends State<F27VisaCalculatorScreen> {
  final TextEditingController _regionScoreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controller with current provider value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<VisaScoreProvider>(context, listen: false);
      if (provider.regionalScore > 0) {
        _regionScoreController.text = provider.regionalScore.toString();
      }
    });
  }

  @override
  void dispose() {
    _regionScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VisaScoreProvider>(
      builder: (context, store, child) {
        final currentScore = store.calculateTotalScore();
        final isPass = currentScore >= 80;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: Text('F-2-7 점수 예측', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold, color: Colors.black)),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.grey),
                onPressed: () {
                  store.reset();
                  _regionScoreController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('초기화되었습니다.')));
                },
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSectionTitle('1. 기본 항목 (최대 130점)'),
                    
                    // --- 나이 ---
                    _buildCard(
                      title: '나이 (Age)',
                      subtitle: '만 나이 기준',
                      children: [
                        _buildRadioItem(store, '나이', '18~24세', 23),
                        _buildRadioItem(store, '나이', '25~29세', 25, isBest: true),
                        _buildRadioItem(store, '나이', '30~34세', 23),
                        _buildRadioItem(store, '나이', '35~39세', 20),
                        _buildRadioItem(store, '나이', '40~44세', 12),
                        _buildRadioItem(store, '나이', '45~50세', 8),
                        _buildRadioItem(store, '나이', '51세 이상', 3),
                      ],
                    ),

                    // --- 학력 ---
                    _buildCard(
                      title: '학력 (Education)',
                      subtitle: '최종 학력 및 전공',
                      children: [
                        SwitchListTile(
                          title: Text('이공계 전공 또는 복수 전공 (2개 학위)', style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w600)),
                          subtitle: Text('체크 시 더 높은 배점 적용', style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.grey)),
                          value: store.isStemOrDoubleMajor,
                          activeThumbColor: const Color(0xFF0277BD),
                          onChanged: (val) {
                            store.updateStemStatus(val);
                          },
                        ),
                        const Divider(),
                        _buildRadioItem(store, '학력', '박사', store.isStemOrDoubleMajor ? 25 : 20),
                        _buildRadioItem(store, '학력', '석사', store.isStemOrDoubleMajor ? 20 : 17),
                        _buildRadioItem(store, '학력', '학사', store.isStemOrDoubleMajor ? 17 : 15),
                        _buildRadioItem(store, '학력', '전문학사', store.isStemOrDoubleMajor ? 15 : 10),
                      ],
                    ),

                    // --- 한국어 ---
                    _buildCard(
                      title: '한국어 (Korean)',
                      subtitle: 'TOPIK 급수 또는 사회통합 단계',
                      children: [
                        _buildRadioItem(store, '한국어', 'TOPIK 5~6급 / KIIP 5단계', 20),
                        _buildRadioItem(store, '한국어', 'TOPIK 4급 / KIIP 4단계', 15),
                        _buildRadioItem(store, '한국어', 'TOPIK 3급 / KIIP 3단계', 10),
                        _buildRadioItem(store, '한국어', 'TOPIK 2급 / KIIP 2단계', 5),
                        _buildRadioItem(store, '한국어', 'TOPIK 1급 / KIIP 1단계', 3),
                      ],
                    ),

                    // --- 소득 ---
                    _buildCard(
                      title: '연간 소득 (Income)',
                      subtitle: '전년도 소득금액증명원 기준',
                      children: [
                        _buildRadioItem(store, '소득', '1억 원 이상', 60),
                        _buildRadioItem(store, '소득', '9천만 ~ 1억 미만', 58),
                        _buildRadioItem(store, '소득', '8천만 ~ 9천만 미만', 56),
                        _buildRadioItem(store, '소득', '7천만 ~ 8천만 미만', 53),
                        _buildRadioItem(store, '소득', '6천만 ~ 7천만 미만', 50),
                        _buildRadioItem(store, '소득', '5천만 ~ 6천만 미만', 45),
                        _buildRadioItem(store, '소득', '4천만 ~ 5천만 미만', 40),
                        _buildRadioItem(store, '소득', '3천만 ~ 4천만 미만', 30),
                        _buildRadioItem(store, '소득', '최저임금 ~ 3천만 미만', 10),
                        _buildRadioItem(store, '소득', '없음 / 미취업', 0),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _buildSectionTitle('2. 가점 및 감점 (최대 +40 / -80)'),

                    // --- 가점 ---
                    _buildCard(
                      title: '가점 항목 (Bonus Points)',
                      subtitle: '합산 최대 40점까지 인정',
                      children: [
                        Text('1. 학위 가점 (택 1)', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                        RadioListTile<String>(
                          title: const Text('해당 없음'),
                          value: 'none',
                          groupValue: store.uniBonusType ?? 'none',
                          onChanged: (val) => store.updateUniBonus(null),
                        ),
                        RadioListTile<String>(
                          title: const Text('세계 우수 대학 (QS 500 / THE 200)'),
                          subtitle: const Text('박사 +30 / 석사 +20 / 학사 +15'),
                          value: 'top_global',
                          groupValue: store.uniBonusType,
                          activeColor: const Color(0xFF0277BD),
                          onChanged: (val) => store.updateUniBonus(val),
                        ),
                        RadioListTile<String>(
                          title: const Text('국내 대학 학위 소지'),
                          subtitle: const Text('박사 +10 / 석사 +7 / 학사 +5'),
                          value: 'domestic',
                          groupValue: store.uniBonusType,
                          activeColor: const Color(0xFF0277BD),
                          onChanged: (val) => store.updateUniBonus(val),
                        ),
                        
                        const Divider(),
                        Text('2. 정책 및 특별 가점 (중복 가능)', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                        _buildCheckboxItem('사회통합프로그램(KIIP) 5단계 이수 (+10)', store.kiipCompleted, (val) => store.updateKiipBonus(val!)),
                        _buildCheckboxItem('첨단/미래산업 분야 종사 (+20)', store.highTechIndustry, (val) => store.updateHighTechBonus(val!)),
                        _buildCheckboxItem('중앙행정기관장 추천 (+20)', store.govRecommendation, (val) => store.updateGovBonus(val!)),
                        _buildCheckboxItem('한국전 참전국 우수인재 (+20)', store.warVeteran, (val) => store.updateVeteranBonus(val!)),
                        
                        const Divider(),
                        Text('3. 국내 사회봉사 (택 1)', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                        _buildRadioItem(store, '봉사', '3년 이상', 7),
                        _buildRadioItem(store, '봉사', '2년 이상', 5),
                        _buildRadioItem(store, '봉사', '1년 이상', 1),

                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(child: Text('4. 지역 특화 거주/근무 (최대 20점)', style: GoogleFonts.notoSansKr(fontSize: 14))),
                              SizedBox(
                                width: 60,
                                child: TextField(
                                  controller: _regionScoreController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(hintText: '0', isDense: true),
                                  onChanged: (val) {
                                    store.updateRegionalScore(int.tryParse(val) ?? 0);
                                  },
                                ),
                              ),
                              const Text(' 점'),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // --- 감점 ---
                    _buildCard(
                      title: '감점 항목 (Penalty)',
                      subtitle: '위반 사실이 있는 경우',
                      children: [
                        _buildCheckboxItem('출입국관리법 위반 (-30점)', store.immigrationViolation, (val) => store.updateImmigrationPenalty(val!), isPenalty: true),
                        _buildCheckboxItem('형사 처벌 이력 (-40점)', store.criminalPunishment, (val) => store.updateCriminalPenalty(val!), isPenalty: true),
                      ],
                    ),
                    
                    const SizedBox(height: 100), // 하단 여백
                  ],
                ),
              ),
              
              // --- 하단 고정 바 ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5))],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 스펙 지갑 연동 토글
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_balance_wallet, color: store.isSpecWalletLinked ? const Color(0xFF0277BD) : Colors.grey),
                            const SizedBox(width: 8),
                            Text('내 스펙지갑 연동', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w600, color: Colors.black87)),
                          ],
                        ),
                        Switch(
                          value: store.isSpecWalletLinked,
                          activeThumbColor: const Color(0xFF0277BD),
                          onChanged: (val) {
                            store.toggleSpecWallet(val);
                            if (val) {
                               _regionScoreController.text = store.regionalScore.toString();
                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('스펙지갑에서 데이터를 불러왔습니다.')));
                            } else {
                               _regionScoreController.clear();
                            }
                          },
                        )
                      ],
                    ),
                    const Divider(height: 24),
                    // 점수 표시
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('현재 예측 점수', style: GoogleFonts.notoSansKr(color: Colors.grey[600], fontSize: 12)),
                            Text('$currentScore점', style: GoogleFonts.notoSansKr(fontSize: 28, fontWeight: FontWeight.w800, color: isPass ? const Color(0xFF0277BD) : Colors.orange)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isPass ? const Color(0xFF0277BD) : Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isPass ? '안정권이에요! 🎉' : '조금만 더! 💪',
                            style: GoogleFonts.notoSansKr(
                              fontWeight: FontWeight.w700,
                              color: isPass ? Colors.white : Colors.orange,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // --- 위젯 빌더 헬퍼 ---
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Text(title, style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1E2B4D))),
    );
  }

  Widget _buildCard({required String title, required String subtitle, required List<Widget> children}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(title, style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Text(subtitle, style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.grey[600])),
          children: children,
        ),
      ),
    );
  }

  Widget _buildRadioItem(VisaScoreProvider store, String group, String label, int score, {bool isBest = false}) {
    String? groupValue;
    // 그룹별 Value 매핑
    if (group == '나이') {
      groupValue = store.selectedAge;
    } else if (group == '학력') {
      groupValue = store.educationLevel;
    } else if (group == '한국어') {
      groupValue = store.koreanLevel;
    } else if (group == '소득') {
      groupValue = store.incomeBracket;
    } else if (group == '봉사') {
      groupValue = store.volunteerBonus;
    }

    return RadioListTile<String>(
      title: Row(
        children: [
          Expanded(child: Text(label, style: GoogleFonts.notoSansKr(fontSize: 14))),
          if (isBest) 
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(color: Colors.amber[100], borderRadius: BorderRadius.circular(4)),
              child: const Text('BEST', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange)),
            ),
        ],
      ),
      secondary: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
        child: Text('+$score', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
      ),
      value: label,
      groupValue: groupValue,
      activeColor: const Color(0xFF0277BD),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      dense: true,
      onChanged: (val) {
        if (group == '나이') {
          store.updateAge(val);
        } else if (group == '학력') {
          store.updateEducation(val);
        } else if (group == '한국어') {
          store.updateKoreanLevel(val);
        } else if (group == '소득') {
          store.updateIncome(val);
        } else if (group == '봉사') {
          store.updateVolunteerBonus(val);
        }
      },
    );
  }

  Widget _buildCheckboxItem(String label, bool value, Function(bool?) onChanged, {bool isPenalty = false}) {
    return CheckboxListTile(
      title: Text(label, style: GoogleFonts.notoSansKr(fontSize: 14)),
      value: value,
      activeColor: isPenalty ? Colors.red : const Color(0xFF0277BD),
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      dense: true,
    );
  }
}
