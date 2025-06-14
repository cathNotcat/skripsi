import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_admin_1/models/login_response_model.dart';

class LoginService {
  final baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<LoginResponseModel> login(String kode, String nama) async {
    try {
      var url = Uri.parse('$baseUrl/user/admin');

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'kode': kode,
          'nama': nama,
        }),
      );

      var responseBody = jsonDecode(response.body);

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
