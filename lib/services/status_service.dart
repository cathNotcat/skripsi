import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StatusService {
  Future<int> updateStatus(
      String noPeng, String noUrut, int statusChange) async {
    final prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('ip_address');
    final url = Uri.parse('$baseUrl/pengiriman/update/$noPeng/$noUrut');
    var response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Status': statusChange}),
    );

    if (response.statusCode == 200) {
      print('Status updated successfully');
      return response.statusCode;
    } else if (response.statusCode == 404) {
      print('Tidak ada data pengiriman di updateStatus Service NoPengiriman');
      return response.statusCode;
    } else {
      print('Gagal update status. Status code: ${response.statusCode}');
      return response.statusCode;
    }
  }
}
