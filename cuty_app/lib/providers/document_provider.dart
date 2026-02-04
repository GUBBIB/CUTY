import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuty_app/providers/point_provider.dart';
import '../models/document_model.dart';
import '../services/local_storage_service.dart';

class DocumentNotifier extends StateNotifier<List<Document>> {
  final Ref ref;
  DocumentNotifier(this.ref) : super([]) {
    _loadDocuments();
  }

  void _loadDocuments() {
    final rawList = LocalStorageService().getDocuments();
    if (rawList.isNotEmpty) {
      state = rawList.map((e) => Document.fromJson(e)).toList();
    }
  }

  void addDocumentWithReward(Document doc) {
    state = [...state, doc];
    _saveDocuments(); // Save changes
    ref.read(pointProvider.notifier).earnPoints(300, "${doc.name} 인증 보상");
  }

  void _saveDocuments() {
    LocalStorageService().saveDocuments(state.map((e) => e.toJson()).toList());
  }

  // 시간제 취업 필수 서류 체크 로직
  // Checks if we have documents of specific types or names
  List<String> hasRequiredDocsForPartTime() {
    final requiredDocs = ['외국인등록증', '여권', '성적증명서', '토픽증명서', '거주지 증빙'];
    List<String> missingDocs = [];

    for (var req in requiredDocs) {
      // Check if any document name contains the required string
      bool hasDoc = state.any((doc) => doc.name.contains(req) || doc.type.contains(req));
      if (!hasDoc) missingDocs.add(req);
    }
    return missingDocs;
  }
}

final documentProvider = StateNotifierProvider<DocumentNotifier, List<Document>>((ref) {
  return DocumentNotifier(ref);
});
