import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // MediaType을 위해 추가
import '../config/app_config.dart';
import '../models/image_store.dart';
import 'token_service.dart';

class ImageService {
  final String baseUrl = AppConfig.baseApiUrl;
  final TokenService _tokenService = TokenService();

  Future<PresignedUrlResponse> getPresignedUrl({
    required String contentType,
    required int fileSize,
    required String filename,
  }) async {
    return _tokenService.tokenRequired((token) async {
      try {
        print('Presigned URL 요청 정보:');
        print('URL: $baseUrl/images/presigned-url');
        print('Content-Type: $contentType');
        print('File Size: $fileSize');
        print('Filename: $filename');

        final response = await http.post(
          Uri.parse('$baseUrl/images/presigned-url'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'content_type': contentType,
            'file_size': fileSize,
            'filename': filename,
          }),
        );

        print('Presigned URL 응답 상태 코드: ${response.statusCode}');
        print('Presigned URL 응답 본문: ${response.body}');

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return PresignedUrlResponse.fromJson(data);
        } else {
          final error = json.decode(response.body);
          throw error['detail'] ?? 'Failed to generate presigned URL';
        }
      } catch (e) {
        print('Presigned URL 요청 오류: ${e.toString()}');
        if (e is String) throw e;
        throw 'Error occurred while preparing image upload';
      }
    });
  }

  Future<void> uploadToS3({
    required String url,
    required Map<String, dynamic> fields,
    required List<int> bytes,
    required String contentType,
  }) async {
    try {
      print('S3 업로드 상세 정보:');
      print('URL: $url');
      print('Content-Type: $contentType');
      print('파일 크기: ${bytes.length} bytes');
      print('필드들:');
      fields.forEach((key, value) {
        print('  $key: $value');
      });

      var request = http.MultipartRequest('POST', Uri.parse(url));

      // S3에서 요구하는 필드들 추가
      fields.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // 파일 데이터 추가
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          contentType: MediaType.parse(contentType),
        ),
      );

      print('S3 요청 전송 중...');
      final response = await request.send();
      
      print('S3 응답 상태 코드: ${response.statusCode}');
      print('S3 응답 헤더들:');
      response.headers.forEach((key, value) {
        print('  $key: $value');
      });

      final responseBody = await response.stream.bytesToString();
      print('S3 응답 본문: $responseBody');

      if (response.statusCode != 204) {
        throw 'Failed to upload image: ${response.statusCode}\n$responseBody';
      }
      
      print('S3 업로드 성공!');
    } catch (e) {
      print('S3 업로드 오류: ${e.toString()}');
      if (e is String) throw e;
      throw 'Error occurred while uploading image';
    }
  }
}
