import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_admin_1/models/pengiriman_all_model.dart';
import 'package:web_admin_1/models/pengiriman_model.dart';

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

  // Future<List<PengirimanAllModel>> getAllPengirimanDataByTanggal() async {
  //   var url = Uri.parse('$baseUrl/pengiriman/tanggal');
  //   var response = await http.get(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //   );

  //   if (response.statusCode == 200) {
  //     var responseBody = jsonDecode(response.body);
  //     final List<dynamic> data = responseBody['data'] ?? [];
  //     return data.map((item) => PengirimanAllModel.fromJson(item)).toList();
  //   } else {
  //     throw Exception('Error in getPengirimanData');
  //   }
  // }
}
