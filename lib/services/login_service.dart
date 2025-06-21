import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aplikasi_1/models/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  // final baseUrl = dotenv.env['BASE_URL'] ?? '';
  String namaSopir = '';
  String platNo = '';

  Future<LoginResponseModel> login(String kode, String nama) async {
    final prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('ip_address');
    try {
      var url = Uri.parse('$baseUrl/user/sopir');

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'kode': kode,
          'nama': nama,
        }),
      );

      var responseBody = jsonDecode(response.body);
      var data = responseBody['data'];
      namaSopir = data['Nama'];
      platNo = data['PlatNo'];
      print('nama sopir: $namaSopir');
      print('platNo: $platNo');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_sopir', namaSopir);
      await prefs.setString('plat_nomor', platNo);

      return LoginResponseModel(
        status: responseBody['status'],
        message: responseBody['message'],
      );
    } catch (e) {
      return LoginResponseModel(
        status: 500,
        message: 'Tidak ada koneksi. Silakan periksa kembali.',
      );
    }
  }
}
