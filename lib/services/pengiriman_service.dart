import 'dart:convert';
import 'package:aplikasi_1/models/pengiriman_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PengirimanService {
  Future<List<PengirimanModel>> getPengirimanByDate(
      String formattedDate) async {
    final prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('ip_address');
    final url = Uri.parse('$baseUrl/pengiriman/tanggal/$formattedDate');

    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final List<dynamic> data = responseBody['data'];
      return data.map((e) => PengirimanModel.fromJson(e)).toList();
    } else {
      throw Exception(
          'Failed to fetch pengiriman data: ${response.statusCode}');
    }
  }
}
