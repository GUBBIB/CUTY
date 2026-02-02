import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/diagnosis_provider.dart';
import '../../models/diagnosis_model.dart';
import 'result_screen.dart';

class ConsultingScreen extends ConsumerStatefulWidget {
  const ConsultingScreen({super.key});

  @override
  ConsumerState<ConsultingScreen> createState() => _ConsultingScreenState();
}

class _ConsultingScreenState extends ConsumerState<ConsultingScreen> with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  final int _totalSteps = 5; 
  late AnimationController _loadingController;
  
  bool _isOtherJob = false;
  final _otherJobController = TextEditingController();

  final List<String> _jobCategories = ["서비스", "관광", "무역", "IT/기술", "마케팅", "교육", "의료/코디네이터", "기타"];
  final List<String> _locations = ["서울", "경기/인천", "부산", "대구", "대전", "광주", "상관없음"];
  
  // Accordion State for "Deep Depth Experience"
  final Map<String, bool> _isExpanded = {
    "인턴십": false,
    "시간제 취업(알바)": false,
    "과거 E-7 근무": false,
  };
  // Text Controllers for "Other" Inputs
  final _internOtherController = TextEditingController();
  final _albaOtherController = TextEditingController();
  final _e7CodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _otherJobController.dispose();
    _internOtherController.dispose();
    _albaOtherController.dispose();
    _e7CodeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    setState(() => _currentStep++);
  }

  Future<void> _submit(bool useDocuments) async {
    showDialog(context: context, barrierDismissible: false, builder: (context) => _buildLoadingDialog(useDocuments));
    await ref.read(diagnosisProvider.notifier).analyze(useDocuments: useDocuments);
    if (mounted) {
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResultScreen()));
    }
  }

  Widget _buildLoadingDialog(bool useDocuments) {
     return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               RotationTransition(turns: _loadingController, child: Icon(useDocuments ? Icons.wallet : Icons.analytics, size: 60, color: Colors.indigo)),
               const SizedBox(height: 24),
               Text(useDocuments ? "서류지갑을\n열어보고 있어요..." : "설문 내용을 바탕으로\n분석 중입니다...", textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to toggle multi-select values
  void _toggleSelection(List<String> currentList, String value, Function(List<String>) onUpdate) {
    final newList = List<String>.from(currentList);
    if (newList.contains(value)) {
      newList.remove(value);
    } else {
      newList.add(value);
    }
    onUpdate(newList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("쿠티바라 취업 컨설팅"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_currentStep + 1) / (_totalSteps + 1), backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation(Colors.indigo)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Persona
                  Center(child: Container(
                    width: 80, height: 80, 
                    decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.person_pin, size: 40, color: Colors.indigo)
                  )),
                  const SizedBox(height: 16),
                  
                  // Question Bubble
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    ),
                    child: Text(_getQuestionText(_currentStep), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.4), textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 30),

                  // Input Area
                  _buildInputArea(_currentStep),
                ],
              ),
            ),
          ),
          
          // Bottom Navigation
          if (_currentStep < 4)
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _canProceed() ? _nextStep : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: Colors.indigo,
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("선택 완료", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
  
  bool _canProceed() {
    final state = ref.read(diagnosisProvider);
    switch (_currentStep) {
      case 0: return state.answer.targetJobs.isNotEmpty;
      case 1: return state.answer.preferredLocations.isNotEmpty;
      case 2: return state.answer.koreanLevel.isNotEmpty;
      case 3: return true; 
      default: return true;
    }
  }

  String _getQuestionText(int step) {
    switch (step) {
      case 0: return "반갑습니다! 취업 컨설턴트 쿠티바라입니다.\n관심 있는 분야를 모두 선택해주세요.";
      case 1: return "어느 지역에서 근무하기를\n희망하시나요?";
      case 2: return "현재 한국어 실력은\n어느 정도라고 생각하시나요?";
      case 3: return "관련 경력이 있다면 알려주세요.\n(없다면 '선택 완료'를 눌러주세요)";
      case 4: return "마지막으로, 정확한 분석을 위해\n서류지갑을 확인해도 될까요?";
      default: return "";
    }
  }

  Widget _buildInputArea(int step) {
    final notifier = ref.read(diagnosisProvider.notifier);
    final state = ref.watch(diagnosisProvider);

    switch (step) {
      case 0: // Job (Multi-select)
        return Column(
          children: [
            Wrap(
              spacing: 10, runSpacing: 10,
              alignment: WrapAlignment.center,
              children: _jobCategories.map((job) {
                final isSelected = state.answer.targetJobs.contains(job);
                return FilterChip(
                  label: Text(job),
                  selected: isSelected,
                  onSelected: (val) {
                     if (job == "기타" && val) {
                       setState(() => _isOtherJob = true);
                     } else if (job == "기타" && !val) {
                       setState(() => _isOtherJob = false);
                     }
                     _toggleSelection(state.answer.targetJobs, job, (l) => notifier.updateAnswer(state.answer.copyWith(targetJobs: l)));
                  },
                  selectedColor: Colors.indigo.withOpacity(0.2),
                  checkmarkColor: Colors.indigo,
                  labelStyle: TextStyle(color: isSelected ? Colors.indigo : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: isSelected ? Colors.indigo : Colors.grey[300]!),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (_isOtherJob) 
               TextField(
                 controller: _otherJobController,
                 decoration: InputDecoration(
                    labelText: "기타 직무 입력",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: IconButton(icon: const Icon(Icons.check), onPressed: () {
                         _toggleSelection(state.answer.targetJobs, _otherJobController.text, (l) => notifier.updateAnswer(state.answer.copyWith(targetJobs: l)));
                         _otherJobController.clear();
                    })
                 ),
               )
          ],
        );
      
      case 1: // Location (Multi-select)
        return Wrap(
          spacing: 10, runSpacing: 10,
          alignment: WrapAlignment.center,
          children: _locations.map((loc) {
            final isSelected = state.answer.preferredLocations.contains(loc);
            return FilterChip(
              label: Text(loc),
              selected: isSelected,
              onSelected: (_) => _toggleSelection(state.answer.preferredLocations, loc, (l) => notifier.updateAnswer(state.answer.copyWith(preferredLocations: l))),
              selectedColor: Colors.indigo.withOpacity(0.2),
              checkmarkColor: Colors.indigo,
              labelStyle: TextStyle(color: isSelected ? Colors.indigo : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              backgroundColor: Colors.white,
              side: BorderSide(color: isSelected ? Colors.indigo : Colors.grey[300]!),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        );

      case 2: // Korean
        final lvls = ["기초 (인사말)", "일상회화 (식당/마트)", "비즈니스 (토론 가능)", "원어민 수준"];
        return Column(children: lvls.map((l) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildSelectableTile(l, state.answer.koreanLevel == l, () => notifier.updateAnswer(state.answer.copyWith(koreanLevel: l))),
        )).toList());

      case 3: // Experience (Sub-questions) + Other
      case 3: // Experience (Accordion Deep Depth)
        return Column(
          children: [
            _buildAccordionSection(
              "인턴십", 
              ["사무/행정", "무역/유통", "IT/개발", "기타"],
              notifier, state,
              _internOtherController,
            ),
            const SizedBox(height: 12),
            _buildAccordionSection(
              "시간제 취업(알바)", 
              ["식당/서빙", "통번역", "행사 보조", "기타"],
              notifier, state,
              _albaOtherController,
            ),
            const SizedBox(height: 12),
            _buildE7AccordionSection(notifier, state),
          ],
        );

      case 4: // Consent
        return Column(
          children: [
            ListTile(
               leading: const Icon(Icons.verified_user, size: 32, color: Colors.amber),
               title: const Text("서류 검증 안내"),
               subtitle: const Text("보유하신 학위/어학성적을 통해 가산점을 받을 수 있습니다."),
               contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Yes (Left, Filled)
                Expanded(child: ElevatedButton(onPressed: () => _submit(true), style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, padding: const EdgeInsets.symmetric(vertical: 16)), child: const Text("네, 서류 연동할게요", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                const SizedBox(width: 12),
                // No (Right, Outlined)
                Expanded(child: OutlinedButton(onPressed: () => _submit(false), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), foregroundColor: Colors.grey, side: const BorderSide(color: Colors.grey)), child: const Text("아니요, 괜찮아요"))),
              ],
            )
          ],
        );

      default: return const SizedBox();
    }
  }
  
  Widget _buildSelectableTile(String text, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.indigo : Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            if (isSelected) const Icon(Icons.check, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }



  Widget _buildAccordionSection(
    String category, 
    List<String> options, 
    DiagnosisNotifier notifier, 
    DiagnosisState state,
    TextEditingController otherController,
  ) {
    bool isExpanded = _isExpanded[category] ?? false;
    // Count selected items in this category
    int selectedCount = state.answer.experiences.where((e) => e.category == category).length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isExpanded || selectedCount > 0 ? Colors.indigo : Colors.grey[200]!),
        boxShadow: isExpanded ? [BoxShadow(color: Colors.indigo.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))] : [],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _isExpanded[category] = !isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(category, style: TextStyle(
                        fontSize: 16, 
                        fontWeight: isExpanded || selectedCount > 0 ? FontWeight.bold : FontWeight.normal,
                        color: isExpanded || selectedCount > 0 ? Colors.indigo : Colors.black87
                      )),
                      if (selectedCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.indigo, borderRadius: BorderRadius.circular(10)),
                          child: Text("$selectedCount", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                    ],
                  ),
                  Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
            ),
          ),
          // Body (Animated)
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  ...options.map((option) {
                    final isSelected = state.answer.experiences.any((e) => e.category == category && e.detailType == option);
                    final isOther = option == "기타";

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          title: Text(option),
                          value: isSelected,
                          activeColor: Colors.indigo,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (val) {
                             final exps = List<CareerExperience>.from(state.answer.experiences);
                             if (val == true) {
                               exps.add(CareerExperience(category: category, detailType: option, customInput: isOther ? otherController.text : null));
                             } else {
                               exps.removeWhere((e) => e.category == category && e.detailType == option);
                             }
                             notifier.updateAnswer(state.answer.copyWith(experiences: exps));
                          },
                        ),
                        // Other Input Animation
                        if (isOther && isSelected)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 8),
                            child: TextField(
                              controller: otherController,
                              decoration: const InputDecoration(
                                isDense: true,
                                hintText: "구체적인 직무 내용을 입력해주세요",
                                border: UnderlineInputBorder(),
                              ),
                              onChanged: (text) {
                                // Update logic to save text in real-time or on submit
                                final exps = List<CareerExperience>.from(state.answer.experiences);
                                final index = exps.indexWhere((e) => e.category == category && e.detailType == "기타");
                                if (index != -1) {
                                  exps[index] = CareerExperience(category: category, detailType: "기타", customInput: text);
                                  notifier.updateAnswer(state.answer.copyWith(experiences: exps));
                                }
                              },
                            ),
                          )
                      ],
                    );
                  }),
                ],
              ),
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          )
        ],
      ),
    );
  }

  Widget _buildE7AccordionSection(DiagnosisNotifier notifier, DiagnosisState state) {
    const category = "과거 E-7 근무";
    bool isExpanded = _isExpanded[category] ?? false;
    bool hasData = state.answer.experiences.any((e) => e.category == category);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isExpanded || hasData ? Colors.indigo : Colors.grey[200]!),
        boxShadow: isExpanded ? [BoxShadow(color: Colors.indigo.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))] : [],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded[category] = !isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Row(
                    children: [
                      Text(category, style: TextStyle(fontSize: 16, fontWeight: isExpanded || hasData ? FontWeight.bold : FontWeight.normal, color: isExpanded || hasData ? Colors.indigo : Colors.black87)),
                      if (hasData) const Padding(padding: EdgeInsets.only(left:8), child: Icon(Icons.check_circle, size: 16, color: Colors.indigo))
                    ],
                   ),
                   Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  const Text("직종 코드 (4자리) 또는 직종명을 입력해주세요.", style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _e7CodeController,
                          decoration: InputDecoration(
                            hintText: "예) 2351, 기계공학",
                            isDense: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                           if (_e7CodeController.text.isNotEmpty) {
                             final exps = List<CareerExperience>.from(state.answer.experiences);
                             // Remove existing E7 if any to replace
                             exps.removeWhere((e) => e.category == category);
                             exps.add(CareerExperience(category: category, detailType: "E-7", customInput: _e7CodeController.text));
                             notifier.updateAnswer(state.answer.copyWith(experiences: exps));
                             setState(() => _isExpanded[category] = false); // Auto close on save
                           }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                        child: const Text("저장", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  if (hasData)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text("입력됨: ${state.answer.experiences.firstWhere((e) => e.category == category).customInput}", style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                    )
                ],
              ),
            )
        ],
      )
    );
  }
}
