import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_admin_1/models/pengiriman_model.dart';
import 'package:web_admin_1/widget/date_formatter.dart';

class PengirimanService {
  final baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<List<PengirimanModel>> getPengirimanData(String date) async {
    var url = Uri.parse('$baseUrl/pengiriman/tanggal/$date');
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      final List<dynamic> data = responseBody['data'] ?? [];
      return data.map((item) => PengirimanModel.fromJson(item)).toList();
    } else {
      throw Exception('Error in getPengirimanData');
    }
  }

  Future<List<GroupedPengirimanModel>> getAllPengirimanDataByTanggal() async {
    var url = Uri.parse('$baseUrl/pengiriman/tanggal');
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      final List<dynamic> data = responseBody['data'] ?? [];

      return data.map((item) => GroupedPengirimanModel.fromJson(item)).toList();
    } else {
      throw Exception('Error getAllPengirimanDataByTanggal');
    }
  }

  Future<List<PengirimanAllModel>> getAllPengirimanData() async {
    var url = Uri.parse('$baseUrl/pengiriman');
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      final List<dynamic> data = responseBody['data'] ?? [];
      return data.map((item) => PengirimanAllModel.fromJson(item)).toList();
    } else {
      throw Exception('Error in getPengirimanData');
    }
  }

  Future<void> uploadPesanan(List<Map<String, dynamic>> sortedPesanan) async {
    var url = Uri.parse('$baseUrl/upload/pengiriman');

    for (var pesanan in sortedPesanan) {
      try {
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'NoDO': pesanan['NoDO'],
            'KodeSopir': pesanan['KodeSopir'],
            'KodeCustSupp': pesanan['KodeCustSupp'],
            'TanggalKirim': pesanan['TanggalKirim'],
            'Status': pesanan['Status'],
          }),
        );

        print('Status: ${response.statusCode} for NoDO: ${pesanan['NoDO']}');

        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          print('Success in uploadPesanan service: ${responseBody['data']}');
        } else {
          print('Failed to upload NoDO ${pesanan['NoDO']}: ${response.body}');
        }
      } catch (e) {
        print('Error uploading NoDO in uploadPesanan ${pesanan['NoDO']}: $e');
      }
    }
  }
}
