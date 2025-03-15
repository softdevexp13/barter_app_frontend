import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  static Future<List<dynamic>> fetchOffers() async {
    final url = Uri.parse('$baseUrl/api/offers');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['offers'];
    } else {
      throw Exception("Elanlar yüklənərkən xəta baş verdi");
    }
  }
}
