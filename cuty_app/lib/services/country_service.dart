import 'package:cuty_app/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/country.dart';

class CountryService {
  final String baseUrl = AppConfig.baseApiUrl;

  Future<Map<String, dynamic>> getCountries({
    int page = 1,
    int perPage = 10,
    String search = '',
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/countries?page=$page&per_page=$perPage&search=$search'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Country> countries = (data['countries'] as List)
            .map((json) => Country.fromJson(json))
            .toList();

        return {
          'countries': countries,
          'total': data['total'],
          'pages': data['pages'],
          'currentPage': data['current_page'],
          'perPage': data['per_page'],
          'search': data['search'],
        };
      } else {
        throw Exception('국가 목록을 불러오는데 실패했습니다');
      }
    } catch (e) {
      print(e);
      throw Exception('서버 연결에 실패했습니다: ${e.toString()}');
    }
  }
}
