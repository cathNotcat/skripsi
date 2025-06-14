import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SopirService {
  final baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<List<String>> getAllSopir() async {
    var url = Uri.parse('$baseUrl/sopir');
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> rawList = json['data'];
      return List<String>.from(rawList);
    }
    return [];
  }
}
