import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cuty_app/config/app_config.dart';
import 'package:cuty_app/services/token_service.dart';


class RequestService {
  final String baseUrl = AppConfig.baseApiUrl;
  final TokenService _tokenService = TokenService();

  Future<void> createRequest({
    required String req_type_str,
    String? idempotencyKey,
  }) async {
    return _tokenService.tokenRequired((token) async {

      try {
        final uri = Uri.parse('$baseUrl/requests/');
        final body = {
          'req_type_str': req_type_str,
          if(idempotencyKey != null) 'idempotencyKey': idempotencyKey,
        };
        print("uri, body 생성 : $uri | $body");

        final response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );

        print("reponse 응답 완료 $response");

        if (response.statusCode != 201) {
          final error = _safeDecode(response.body);
          throw Exception(error['message'] ?? '신청 요청 생성에 실패했습니다');
        }
      } catch (e) {
        throw Exception('서버 연결 실패: $e');
      }
    });
  }

  Map<String, dynamic> _safeDecode(String body){
    if (body.isEmpty) return {};
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}