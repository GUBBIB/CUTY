import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/job_post.dart';
import 'providers/job_providers.dart';

class JobDetailScreen extends ConsumerWidget {
  final JobPost job;

  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(jobThemeProvider);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. Top Image Section with SliverAppBar
              SliverAppBar(
                expandedHeight: 280.0,
                pinned: true,
                backgroundColor: Colors.transparent, // Or valid color when collapsed
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background Image
                      // Background Image
                      Image.network(
                        'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=1000&auto=format&fit=crop',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                           return Container(
                             color: Colors.grey[300],
                             child: const Center(child: Icon(Icons.coffee, size: 64, color: Colors.grey)),
                           );
                        },
                      ),
                      // Dark Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                      // Content Overlay
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              job.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: job.tags.map((tag) {
                                final isVisa = tag.contains('비자');
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isVisa ? theme.primaryColor : Colors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // 2. Body Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Job Info & Map
                      // Job Info & Map
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(Icons.monetization_on_rounded, '시급 10,000원', 
                                  isHighlight: true, highlightColor: const Color(0xFF26A69A), fontSize: 20),
                                const SizedBox(height: 12),
                                _buildInfoRow(Icons.timer_rounded, '월/수/금 18:00 - 22:00'),
                                const SizedBox(height: 12),
                                _buildInfoRow(Icons.translate_rounded, '한국어: TOPIK 3급↑'),
                                const SizedBox(height: 12),
                                _buildInfoRow(Icons.local_fire_department_rounded, '마감 D-33', color: Colors.deepOrange),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Map Thumbnail
                          Container(
                            height: 100,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  const Center(child: Icon(Icons.map, color: Colors.grey)),
                                  // Simulated Path
                                  Positioned(
                                    top: 30, left: 35,
                                    child: Icon(Icons.location_on, color: theme.primaryColor, size: 28),
                                  ),
                                  Positioned(
                                    bottom: 0, left: 0, right: 0,
                                    child: Container(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: const Text('2km', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // CUTY Special Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 const Text('🚀', style: TextStyle(fontSize: 18)),
                                 const SizedBox(width: 8),
                                 Text(
                                   '시간제 취업 허가, CUTY가 도와드려요!',
                                   style: const TextStyle(
                                     fontSize: 15,
                                     fontWeight: FontWeight.bold,
                                     color: Color(0xFF1A1A2E), // Navy
                                   ),
                                 ),
                               ],
                             ),
                             const SizedBox(height: 20),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Expanded(child: _buildStepItem(Icons.description_outlined, '① 전자계약\n자동완성')),
                                 Padding(
                                   padding: const EdgeInsets.only(top: 15),
                                   child: Icon(Icons.arrow_forward_rounded, color: Colors.grey[400], size: 16),
                                 ),
                                 Expanded(child: _buildStepItem(Icons.mark_email_read_outlined, '② 학교 승인\n메일 발송')),
                                 Padding(
                                   padding: const EdgeInsets.only(top: 15),
                                   child: Icon(Icons.arrow_forward_rounded, color: Colors.grey[400], size: 16),
                                 ),
                                 Expanded(child: _buildStepItem(Icons.assignment_turned_in_outlined, '③ 하이코리아\n제출 가이드')),
                               ],
                             ),
                             const SizedBox(height: 16),
                             Container(
                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(8),
                                 border: Border.all(color: Colors.grey[200]!),
                               ),
                               child: const Text(
                                 '합격 시, 앱에서 전자계약 및 학교 신청을 원스톱으로 지원해요!',
                                 style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
                                 textAlign: TextAlign.center,
                               ),
                             ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      const Divider(thickness: 1, color: Colors.grey),
                      const SizedBox(height: 24),
                      
                      // Detailed Description
                      Text(
                        '상세 요강',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '저희 카페에서 밝고 성실한 주말 스태프를 모집합니다.\n\n주로 음료 제조 보조와 매장 관리를 담당하게 됩니다. 손님 응대가 많은 편이라 밝은 미소를 가진 분이면 좋겠습니다.\n\n초보자도 환영하며, 업무는 친절하게 알려드립니다. 식사도 제공해드리니 편하게 지원해주세요!',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      const Divider(thickness: 1, color: Colors.grey),
                      const SizedBox(height: 24),
                      
                      // Shop Info
                      Text(
                        '가게 정보',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.storefront_rounded, size: 20, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          const Text('카페 쿠티 (Cafe Cuty)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_outlined, size: 20, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text('부산진구 중앙대로 123번길', style: TextStyle(fontSize: 15, color: Colors.black54)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.call_rounded, size: 20, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          const Text('0507-1234-5678 (채용 담당자)', style: TextStyle(fontSize: 15, color: Colors.black54)),
                        ],
                      ),
                      
                      const SizedBox(height: 32),


                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Bottom Button
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Apply Action
                  _showApplyBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  shadowColor: theme.primaryColor.withValues(alpha: 0.4),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  '지금 바로 지원하기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {
    bool isHighlight = false, 
    Color? color, 
    Color? highlightColor,
    double fontSize = 16,
  }) {
    final finalColor = highlightColor ?? color ?? (isHighlight ? const Color(0xFF2E7D32) : Colors.black87);
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? (isHighlight ? const Color(0xFF2E7D32) : Colors.grey[600])),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              color: finalColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[200]!, width: 2),
          ),
          child: Icon(icon, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.3,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showApplyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        bool isAgreementChecked = true;
        final List<String> strengthOptions = [
          '🏠 10분 내 거주',
          '🗣️ 실전 회화 능통',
          '✨ 알바 경력 보유'
        ];
        final List<String> selectedStrengths = [];

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const Text(
                            '지원하기',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A2E), // Navy
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () => Navigator.pop(context),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Profile Section
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200], // Light grey background
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/unknown_user.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'User Name', // Anonymized Name
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Text(
                                      'D-2 유학비자',
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE0F2F1), // Light Mint
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        '✅ CUTY 비자 검증 완료',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF26A69A), // Mint
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Checkbox
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            checkboxTheme: CheckboxThemeData(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              fillColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return const Color(0xFF26A69A); // Mint
                                }
                                return null;
                              }),
                            )
                          ),
                          child: CheckboxListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            title: const Text(
                              '월/수/금 18:00 - 22:00 근무 가능합니다.',
                              style: TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                            value: isAgreementChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isAgreementChecked = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: const Color(0xFF26A69A), // Mint
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Strength Chips
                      const Text(
                        '나의 강점 어필 (선택)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E), // Navy
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: strengthOptions.map((option) {
                          final isSelected = selectedStrengths.contains(option);
                          return FilterChip(
                            label: Text(option),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  selectedStrengths.add(option);
                                } else {
                                  selectedStrengths.remove(option);
                                }
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: const Color(0xFFE0F2F1), // Light Mint
                            checkmarkColor: const Color(0xFF26A69A),
                            labelStyle: TextStyle(
                              color: isSelected ? const Color(0xFF00695C) : Colors.black87,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected ? const Color(0xFF26A69A) : Colors.grey[300]!,
                              ),
                            ),
                            showCheckmark: false, // Custom style often looks cleaner without checkmark inside chip if color changes, but user asked for Checkbox style... wait, mockup shows simple chips. I'll stick to FilterChip default behavior but style it.
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // Bottom Button
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close bottom sheet
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('지원이 완료되었습니다!'),
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF26A69A), // Mint
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            '프로필 보내고 지원 완료 ✉️',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
