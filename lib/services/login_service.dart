import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<int> login(String kode, String nama) async {
    var url = Uri.parse('$baseUrl/user/admin');

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'kode': kode,
        'nama': nama,
      }),
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var status = responseBody['status'];
      print('success login: $responseBody');
      return status;
    } else {
      throw Exception('Error in login');
    }
  }
}
