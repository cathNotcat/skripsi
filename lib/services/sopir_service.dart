import 'package:aplikasi_1/models/sopir.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SopirService {
  // final baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<Sopir?> getSopir() async {
    final prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('ip_address');
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
