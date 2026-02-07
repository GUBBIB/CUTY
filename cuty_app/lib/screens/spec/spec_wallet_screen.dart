import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuty_app/providers/document_provider.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../models/document_model.dart';
import 'dart:math';

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
  List<SpecDocDefinition> getIdentityDocs(BuildContext context) => [
    SpecDocDefinition(name: AppLocalizations.of(context)!.docARC, icon: Icons.badge_outlined),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docStudentId, icon: Icons.badge),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docPassport, icon: Icons.airplanemode_active),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docResidenceProof, icon: Icons.home_work_outlined),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docResidenceCert, icon: Icons.home),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docLease, icon: Icons.article),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docDorm, icon: Icons.apartment),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docResidenceConfirm, icon: Icons.check_circle_outline),
  ];

  // 2. 학업 및 어학 (Academics & Language)
  List<SpecDocDefinition> getAcademicDocs(BuildContext context) => [
    SpecDocDefinition(name: AppLocalizations.of(context)!.docEnrollment, icon: Icons.school),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docTranscript, icon: Icons.grade),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docCompletion, icon: Icons.card_membership),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docTopik, icon: Icons.language),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docKiip, icon: Icons.diversity_3),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docForeignLang, icon: Icons.translate),
  ];

  // 3. 커리어 및 스펙 (Career & Achievements)
  List<SpecDocDefinition> getCareerDocs(BuildContext context) => [
    SpecDocDefinition(name: AppLocalizations.of(context)!.docVolunteer, icon: Icons.volunteer_activism),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docCareer, icon: Icons.work),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docAward, icon: Icons.emoji_events),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docCertificate, icon: Icons.verified),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docLicense, icon: Icons.drive_eta),
    SpecDocDefinition(name: AppLocalizations.of(context)!.docOther, icon: Icons.folder_open),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 실제 보유 중인 서류 리스트 가져오기
    final myDocs = ref.watch(documentProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.specWalletTitle),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          children: [
            _buildSection(
              context, 
              AppLocalizations.of(context)!.specSectionIdentity, 
              AppLocalizations.of(context)!.specSectionIdentityDesc, 
              getIdentityDocs(context), 
              myDocs, 
              ref
            ),
            const SizedBox(height: 32),
            _buildSection(
              context, 
              AppLocalizations.of(context)!.specSectionAcademic, 
              AppLocalizations.of(context)!.specSectionAcademicDesc, 
              getAcademicDocs(context), 
              myDocs, 
              ref
            ),
            const SizedBox(height: 32),
            _buildSection(
              context, 
              AppLocalizations.of(context)!.specSectionCareer, 
              AppLocalizations.of(context)!.specSectionCareerDesc, 
              getCareerDocs(context), 
              myDocs, 
              ref
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String subtitle, List<SpecDocDefinition> docs, List<Document> myDocs, WidgetRef ref) { // Changed DocumentItem to Document
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
            // We use .name or .title (compatibility getter)
            // But 'firstWhere' requires a return value if not found. 
            // We return a dummy Document with id 0 for "not found".
            final matchingDoc = myDocs.firstWhere(
              (doc) => doc.name == def.name || doc.name.startsWith(def.name),
              orElse: () => Document(id: 0, name: "", type: "", createdAt: DateTime.now(), imageUrl: ""),
            );
            
            final isRegistered = matchingDoc.id != 0;

            return _buildDocCard(context, def, isRegistered, isRegistered ? matchingDoc.expiryDate : "none", ref);
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
                        child: Text(AppLocalizations.of(context)!.lblRegistered, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                       )
                  ],
                ),
                const SizedBox(height: 24),
                
                // 1. 확인하기
                _buildActionTile(
                  context, 
                  icon: Icons.visibility_outlined, 
                  label: AppLocalizations.of(context)!.btnCheckDoc,
                  onTap: () {
                    Navigator.pop(context);
                    if (!isRegistered) {
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.msgDocEmpty)));
                    } else {
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.msgDocLoading)));
                    }
                  },
                ),
                
                const SizedBox(height: 12),
                
                if (!isRegistered) ...[
                  // 2. PDF 등록
                  _buildActionTile(
                    context, 
                    icon: Icons.picture_as_pdf_outlined, 
                    label: AppLocalizations.of(context)!.btnUploadPdf,
                    onTap: () {
                      // 실제 등록 로직
                      ref.read(documentProvider.notifier).addDocumentWithReward(
                          Document(
                            id: Random().nextInt(10000), // generated id
                            name: def.name,  // 클릭한 서류 이름으로 등록
                            type: 'pdf',
                            createdAt: DateTime.now(),
                            imageUrl: 'assets/images/doc_placeholder.png', // dummy
                          )
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.msgDocReward),
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
                    label: AppLocalizations.of(context)!.btnUploadCamera,
                    onTap: () {
                      // 실제 등록 로직
                      ref.read(documentProvider.notifier).addDocumentWithReward(
                          Document(
                            id: Random().nextInt(10000), // generated id
                            name: def.name, 
                            type: 'image',
                            createdAt: DateTime.now(),
                            imageUrl: 'assets/images/doc_placeholder.png',
                          )
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.msgDocReward),
                          backgroundColor: Colors.blueAccent,
                        ),
                      );
                    },
                  ),
                ] else ...[
                   _buildActionTile(
                    context, 
                    icon: Icons.delete_outline, 
                    label: AppLocalizations.of(context)!.btnDeleteDoc,
                    onTap: () {
                       Navigator.pop(context);
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.msgDeleteNotReady)));
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
