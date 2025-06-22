import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TargetService {
  final baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<Map<String, String>> fetchMonthlySO() async {
    final response = await http.get(Uri.parse('$baseUrl/get-monthly-so'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data'] as Map<String, dynamic>;
      return data.map((key, value) => MapEntry(key, value.toString()));
    } else {
      throw Exception('Failed to load monthly SO');
    }
  }
}
