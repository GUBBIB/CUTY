import 'package:cuty_app/config/app_config.dart';
import 'package:cuty_app/models/document.dart';
import 'package:cuty_app/services/token_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DocumentService {
  final String baseUrl = AppConfig.baseApiUrl;
  final TokenService _tokenService = TokenService();

  /// 사용자의 서류 목록을 조회합니다
  Future<Map<String, dynamic>> getDocuments({
    int page = 1,
    int perPage = 10,
    DocumentType? documentType,
  }) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        String url = '$baseUrl/documents?page=$page&per_page=$perPage';
        if (documentType != null) {
          url += '&type=${documentType.value}';
        }
        
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final Map<String, dynamic> data = responseData['data'];

          final List<Document> documents = (data['documents'] as List).map((json) {
            try {
              return Document.fromJson(json);
            } catch (e) {
              print('Document parsing error: $e');
              rethrow;
            }
          }).toList();

          return {
            'documents': documents,
            'total': data['total'],
            'pages': data['pages'],
            'currentPage': data['current_page'],
            'perPage': data['per_page'],
            'hasNext': data['has_next'],
            'hasPrev': data['has_prev'],
          };
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '서류 목록을 불러오는데 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  /// 서류 상세 정보를 조회합니다
  Future<Document> getDocument(int documentId) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/documents/$documentId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return Document.fromJson(responseData['data']);
        } else if (response.statusCode == 404) {
          throw Exception('존재하지 않는 서류입니다');
        } else if (response.statusCode == 410) {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '삭제된 서류입니다');
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '서류를 불러오는데 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  /// 새로운 서류를 생성합니다
  Future<Document> createDocument({
    required DocumentType documentType,
    required int imageStoreId,
    String? name,
  }) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        print('서류 생성 요청 정보:');
        print('URL: $baseUrl/documents');
        print('Document Type: ${documentType.value}');
        print('Image Store ID: $imageStoreId');

        final response = await http.post(
          Uri.parse('$baseUrl/documents'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'document_type': documentType.value,
            'image_store_id': imageStoreId,
            if (name != null) 'name': name,
          }),
        );

        print('서류 생성 응답 상태 코드: ${response.statusCode}');
        print('서류 생성 응답 헤더들:');
        response.headers.forEach((key, value) {
          print('  $key: $value');
        });
        print('서류 생성 응답 본문: ${response.body}');

        if (response.statusCode == 201) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          print('✅ 서류 반환 완료');
          return Document.fromJson(responseData['data']);
        } else if (response.statusCode == 410) {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '삭제된 이미지입니다');
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '서류 생성에 실패했습니다');
        }
      } catch (e, stacktrace) {
        print('⛔서류 생성 오류: ${e.toString()}');
        print('스택트레이스: $stacktrace');
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  /// 서류 정보를 업데이트합니다
  Future<Document> updateDocument({
    required int documentId,
    DocumentType? documentType,
    int? imageStoreId,
    String? name,
  }) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final Map<String, dynamic> body = {};
        if (documentType != null) body['document_type'] = documentType.value;
        if (imageStoreId != null) body['image_store_id'] = imageStoreId;
        if (name != null) body['name'] = name;

        if (body.isEmpty) {
          throw Exception('업데이트할 데이터가 필요합니다');
        }

        final response = await http.put(
          Uri.parse('$baseUrl/documents/$documentId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return Document.fromJson(responseData['data']);
        } else if (response.statusCode == 410) {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '삭제된 서류 또는 이미지입니다');
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '서류 수정에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  /// 서류를 삭제합니다
  Future<void> deleteDocument(int documentId) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.delete(
          Uri.parse('$baseUrl/documents/$documentId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          // 성공적으로 삭제됨
          return;
        } else if (response.statusCode == 404) {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '존재하지 않는 서류입니다');
        } else if (response.statusCode == 410) {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '삭제된 서류입니다');
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '서류 삭제에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  /// 여러 서류를 한 번에 삭제합니다
  Future<Map<String, dynamic>> deleteMultipleDocuments(List<int> documentIds) async {
    return await _tokenService.tokenRequired((token) async {
      try {
        if (documentIds.isEmpty) {
          throw Exception('삭제할 서류가 선택되지 않았습니다');
        }

        final response = await http.delete(
          Uri.parse('$baseUrl/documents/bulk-delete'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'document_ids': documentIds,
          }),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return {
            'success': true,
            'message': responseData['message'],
            'deletedCount': responseData['data']['deleted_count'],
            'deletedIds': List<int>.from(responseData['data']['deleted_ids']),
            'totalRequested': responseData['data']['total_requested'],
            'notFoundIds': responseData['data']['not_found_ids'] != null 
                ? List<int>.from(responseData['data']['not_found_ids'])
                : <int>[],
            'notFoundCount': responseData['data']['not_found_count'] ?? 0,
          };
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '서류 삭제에 실패했습니다');
        }
      } catch (e) {
        if (e is Exception) {
          rethrow;
        }
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  /// 사용 가능한 서류 타입 목록을 조회합니다
  Future<List<Map<String, String>>> getDocumentTypes() async {
    return await _tokenService.tokenRequired((token) async {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/documents/types'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final List<dynamic> typesData = responseData['data'];
          
          return typesData.map((type) => {
            'value': type['value'] as String,
            'name': type['name'] as String,
          }).toList();
        } else {
          final error = json.decode(response.body);
          throw Exception(error['error'] ?? '서류 타입을 불러오는데 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
      }
    });
  }

  /// 로컬에서 사용 가능한 서류 타입 목록을 반환합니다 (서버 연결 없이)
  List<Map<String, String>> getLocalDocumentTypes() {
    return DocumentType.values.map((type) => {
      'value': type.value,
      'name': type.displayName,
    }).toList();
  }
}
