import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuty_app/providers/point_provider.dart';

class DocumentItem {
  final String id;
  final String title;
  final String expiryDate;
  final bool isVerified;

  DocumentItem({
    required this.id,
    required this.title,
    required this.expiryDate,
    this.isVerified = false,
  });
}

class DocumentNotifier extends StateNotifier<List<DocumentItem>> {
  final Ref ref;
  DocumentNotifier(this.ref) : super([]);

  void addDocumentWithReward(DocumentItem doc) {
    state = [...state, doc];
    ref.read(pointProvider.notifier).earnPoints(300, "${doc.title} 인증 보상");
  }

  // 시간제 취업 필수 서류 체크 로직
  List<String> hasRequiredDocsForPartTime() {
    final requiredDocs = ['외국인등록증', '여권', '성적증명서', '토픽증명서', '거주지 증빙'];
    List<String> missingDocs = [];

    for (var req in requiredDocs) {
      bool hasDoc = state.any((doc) => doc.title.contains(req));
      if (!hasDoc) missingDocs.add(req);
    }
    return missingDocs;
  }
}

final documentProvider = StateNotifierProvider<DocumentNotifier, List<DocumentItem>>((ref) {
  return DocumentNotifier(ref);
});
