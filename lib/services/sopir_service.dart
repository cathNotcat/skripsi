import 'package:aplikasi_1/model/sopir.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SopirService {
  final baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<Sopir?> getSopir() async {
    var url = Uri.parse('$baseUrl/sopir/adi');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return Sopir(kodeSopir: data['kodesopir']);
      } else {
        print('getSopir() error status code: ${response.statusCode}');
      }
    } catch (e) {
      print('getSopir() error occurred: $e');
    }
    return null;
  }
}
