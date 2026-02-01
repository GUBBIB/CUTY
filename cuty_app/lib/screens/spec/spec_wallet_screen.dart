import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuty_app/providers/document_provider.dart';

// UI 정의용 정적 클래스
class SpecDocDefinition {
  final String name;
  final IconData icon;

  const SpecDocDefinition({
    required this.name,
    required this.icon,
  });
}

class SpecWalletScreen extends ConsumerWidget {
  const SpecWalletScreen({super.key});

  // 1. 필수 신분/체류 (Identity & Residence)
  static const List<SpecDocDefinition> identityDocs = [
    SpecDocDefinition(name: "외국인등록증", icon: Icons.badge_outlined),
    SpecDocDefinition(name: "학생증", icon: Icons.badge),
    SpecDocDefinition(name: "여권사본", icon: Icons.airplanemode_active),
    SpecDocDefinition(name: "거주지 증빙", icon: Icons.home_work_outlined),
    SpecDocDefinition(name: "거주지증명서", icon: Icons.home),
    SpecDocDefinition(name: "임대차증명서", icon: Icons.article),
    SpecDocDefinition(name: "기숙사 거주 인증서", icon: Icons.apartment),
    SpecDocDefinition(name: "거주지 제공확인서", icon: Icons.check_circle_outline),
  ];

  // 2. 학업 및 어학 (Academics & Language)
  static const List<SpecDocDefinition> academicDocs = [
    SpecDocDefinition(name: "재학증명서", icon: Icons.school),
    SpecDocDefinition(name: "성적증명서", icon: Icons.grade),
    SpecDocDefinition(name: "수료증", icon: Icons.card_membership),
    SpecDocDefinition(name: "토픽증명서", icon: Icons.language),
    SpecDocDefinition(name: "사회통합프로그램증명서", icon: Icons.diversity_3),
    SpecDocDefinition(name: "외국어 증명서", icon: Icons.translate),
  ];

  // 3. 커리어 및 스펙 (Career & Achievements)
  static const List<SpecDocDefinition> careerDocs = [
    SpecDocDefinition(name: "봉사활동 인증서", icon: Icons.volunteer_activism),
    SpecDocDefinition(name: "경력인증서", icon: Icons.work),
    SpecDocDefinition(name: "상장", icon: Icons.emoji_events),
    SpecDocDefinition(name: "자격증", icon: Icons.verified),
    SpecDocDefinition(name: "면허", icon: Icons.drive_eta),
    SpecDocDefinition(name: "기타", icon: Icons.folder_open),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 실제 보유 중인 서류 리스트 가져오기
    final myDocs = ref.watch(documentProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: const Text('스펙 지갑'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          children: [
            _buildSection(context, "🪪 필수 신분/체류", "안전한 체류를 위한 필수 서류", identityDocs, myDocs, ref),
            const SizedBox(height: 32),
            _buildSection(context, "🎓 학업 및 어학", "학교 생활과 어학 능력 증명", academicDocs, myDocs, ref),
            const SizedBox(height: 32),
            _buildSection(context, "🏆 커리어 및 스펙", "나만의 경쟁력을 증명하는 곳", careerDocs, myDocs, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String subtitle, List<SpecDocDefinition> docs, List<DocumentItem> myDocs, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const SizedBox(height: 16),
        
        // Grid
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8, // Slightly taller cards
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final def = docs[index];
            
            // 보유 여부 확인
            final matchingDoc = myDocs.firstWhere(
              (doc) => doc.title == def.name || doc.title.startsWith(def.name),
              orElse: () => DocumentItem(id: "", title: "", expiryDate: "none", isVerified: false),
            );
            
            final isRegistered = matchingDoc.isVerified;

            return _buildDocCard(context, def, isRegistered, matchingDoc.expiryDate, ref);
          },
        ),
      ],
    );
  }

  Widget _buildDocCard(BuildContext context, SpecDocDefinition def, bool isRegistered, String expiryDate, WidgetRef ref) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isRegistered
            ? const BorderSide(color: Colors.indigoAccent, width: 1.5)
            : BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => _showDocumentOptions(context, def, isRegistered, ref),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              def.icon, 
              size: 32, 
              color: isRegistered ? Colors.indigo : Colors.grey[300]
            ),
            const SizedBox(height: 12),
            Text(
              def.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12, // Slightly smaller font for dense grid
                fontWeight: isRegistered ? FontWeight.bold : FontWeight.w500,
                color: isRegistered ? Colors.black87 : Colors.grey[600],
              ),
            ),
             if (isRegistered && expiryDate != "none") ...[
               const SizedBox(height: 6),
               Container(
                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                 decoration: BoxDecoration(
                   color: Colors.indigo.withOpacity(0.08),
                   borderRadius: BorderRadius.circular(6),
                 ),
                 child: Text(
                   expiryDate,
                   style: const TextStyle(
                     fontSize: 10,
                     color: Colors.indigo,
                     fontWeight: FontWeight.w700,
                   ),
                 ),
               )
             ] else if (!isRegistered) ...[
                const SizedBox(height: 4),
                const Text(
                  "+300P",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFF9800), // Orange
                    letterSpacing: -0.2, // 공간 확보를 위해 자간 살짝 축소
                  ),
                )
             ]
          ],
        ),
      ),
    );
  }

  void _showDocumentOptions(BuildContext context, SpecDocDefinition def, bool isRegistered, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      def.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (isRegistered)
                       Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text("등록됨", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                       )
                  ],
                ),
                const SizedBox(height: 24),
                
                // 1. 확인하기
                _buildActionTile(
                  context, 
                  icon: Icons.visibility_outlined, 
                  label: '확인하기',
                  onTap: () {
                    Navigator.pop(context);
                    if (!isRegistered) {
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("등록된 서류가 없습니다.")));
                    } else {
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("서류 이미지를 불러옵니다...")));
                    }
                  },
                ),
                
                const SizedBox(height: 12),
                
                if (!isRegistered) ...[
                  // 2. PDF 등록
                  _buildActionTile(
                    context, 
                    icon: Icons.picture_as_pdf_outlined, 
                    label: '인증하고 300P 받기 (PDF)',
                    onTap: () {
                      // 실제 등록 로직
                      ref.read(documentProvider.notifier).addDocumentWithReward(
                          DocumentItem(
                            id: DateTime.now().toString(),
                            title: def.name,  // 클릭한 서류 이름으로 등록
                            expiryDate: "2026-12-31",
                            isVerified: true,
                          )
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("🎉 서류 인증 보상 300P가 적립되었습니다!"),
                          backgroundColor: Colors.blueAccent,
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 12),

                  // 3. 카메라 등록
                  _buildActionTile(
                    context, 
                    icon: Icons.camera_alt_outlined, 
                    label: '인증하고 300P 받기 (촬영)',
                    onTap: () {
                      // 실제 등록 로직
                      ref.read(documentProvider.notifier).addDocumentWithReward(
                          DocumentItem(
                            id: DateTime.now().toString(),
                            title: def.name, // 클릭한 서류 이름으로 등록
                            expiryDate: "2026-12-31",
                            isVerified: true,
                          )
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("🎉 서류 인증 보상 300P가 적립되었습니다!"),
                          backgroundColor: Colors.blueAccent,
                        ),
                      );
                    },
                  ),
                ] else ...[
                   _buildActionTile(
                    context, 
                    icon: Icons.delete_outline, 
                    label: '삭제하기',
                    onTap: () {
                       Navigator.pop(context);
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("삭제 기능은 준비중입니다.")));
                    },
                  )
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionTile(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[800]),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
