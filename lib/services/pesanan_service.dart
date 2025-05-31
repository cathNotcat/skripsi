import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_admin_1/models/dbspp_model.dart';
import 'package:web_admin_1/models/pesanan_model.dart';

class PesananService {
  final baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<List<PesananModel>> getPengirimanData(String date) async {
    var url = Uri.parse('$baseUrl/pengiriman/tanggal/$date');
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print('Raw data: ${jsonDecode(response.body)}');

      final List<dynamic> data = responseBody['data'] ?? [];
      return data.map((item) => PesananModel.fromJson(item)).toList();
    } else {
      throw Exception('Error in getPengirimanData');
    }
  }

  Future<DBSPPModel> getDbsppData(String noDO) async {
    var url = Uri.parse('$baseUrl/dbspp/nobukti');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'NOBUKTI': noDO,
        }));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      print('data dbspp: $data');
      return DBSPPModel.fromJson(data);
    } else {
      throw Exception('Error in getDbsppData');
    }
  }

  Future<List<DBSPPDetModel>> getDbsppDetData(String noDO) async {
    var url = Uri.parse('$baseUrl/dbsppdet/nobukti');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'NOBUKTI': noDO,
        }));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body)['data'];
      final List<dynamic> data = responseBody;
      return data.map((item) => DBSPPDetModel.fromJson(item)).toList();
    } else {
      throw Exception('Error in getDbsppData');
    }
  }

  Future<bool> hapusPesanan(String noDO, String tanggalKirim) async {
    var url = Uri.parse('$baseUrl/pengiriman/delete');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'NoDO': noDO, 'TanggalKirim': tanggalKirim}),
    );

    return response.statusCode == 200;
  }

  Future<void> tambahPesanan(List<Map<String, dynamic>> pesananList) async {
    var url = Uri.parse('$baseUrl/upload/pengiriman');
    for (var pesanan in pesananList) {
      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pesanan),
      );
    }
  }
}
