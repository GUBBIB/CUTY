import 'package:cuty_app/common/component/custom_app_bar.dart';
import 'package:cuty_app/common/component/card_container.dart';
import 'package:cuty_app/config/app_colors.dart';
import 'package:cuty_app/models/document.dart';
import 'package:cuty_app/screens/document_detail_screen.dart';
import 'package:cuty_app/common/layout/screen_layout.dart';
import 'package:flutter/material.dart';

class MyDocumentsScreen extends StatefulWidget {
  const MyDocumentsScreen({super.key});

  @override
  State<MyDocumentsScreen> createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen> {
  List<DocumentType> get allDocumentTypes => DocumentType.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '나의 서류',
      ),
      body: ScreenLayout(
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: allDocumentTypes.length,
          itemBuilder: (context, index) {
            final documentType = allDocumentTypes[index];
            return CardContainer(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocumentDetailScreen(
                      documentType: documentType,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getDocumentIcon(documentType),
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          documentType.displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          documentType.value,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getDocumentIcon(DocumentType documentType) {
    switch (documentType) {
      case DocumentType.studentId:
        return Icons.badge;
      case DocumentType.passportCopy:
        return Icons.flight;
      case DocumentType.enrollmentCertificate:
        return Icons.school;
      case DocumentType.transcript:
        return Icons.grade;
      case DocumentType.topikCertificate:
        return Icons.language;
      case DocumentType.socialIntegrationCertificate:
        return Icons.groups;
      case DocumentType.residenceCertificate:
      case DocumentType.residenceConfirmation:
        return Icons.home;
      case DocumentType.rentalContract:
        return Icons.assignment;
      case DocumentType.dormitoryCertificate:
        return Icons.apartment;
      case DocumentType.volunteerCertificate:
        return Icons.volunteer_activism;
      case DocumentType.languageCertificate:
        return Icons.translate;
      case DocumentType.careerCertificate:
        return Icons.work;
      case DocumentType.award:
        return Icons.emoji_events;
      case DocumentType.completionCertificate:
        return Icons.school;
      case DocumentType.license:
        return Icons.card_membership;
      case DocumentType.qualification:
        return Icons.verified;
      case DocumentType.other:
        return Icons.description;
    }
  }

}
