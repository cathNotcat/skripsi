import 'dart:convert';
import 'package:aplikasi_1/models/pengiriman_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PengirimanService {
  Future<List<PengirimanDetailModel>> getPengirimanByDate(
      String formattedDate, String sopir) async {
    final prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('ip_address');
    print('in pengiriman service: $sopir');
    print('in pengiriman service base url: $baseUrl');
    final url =
        Uri.parse('$baseUrl/pengiriman/tanggal/sopir/$formattedDate/$sopir');

    print('in pengiriman service url: $url');
    print('in pengiriman service: almost response');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    print('in pengiriman service: after response');
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final List<dynamic> data = responseBody['data'];
      print('in pengiriman service data: $data');
      return data.map((e) => PengirimanDetailModel.fromJson(e)).toList();
    } else {
      throw Exception(
          'Failed to fetch pengiriman data: ${response.statusCode}');
    }
  }

  Future<List<GroupedPengirimanModel>> getAllPengirimanDataByTanggal() async {
    final prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('ip_address');
    String? namaSopir = prefs.getString('selected_sopir');
    print('namaSopir in getAllPengirimanDataByTanggal: $namaSopir');

    var url = Uri.parse('$baseUrl/pengiriman/all/tanggal/$namaSopir');
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

  Future<List<PengirimanDetailModel>> getPengirimanData(String date) async {
    final prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('ip_address');
    var url = Uri.parse('$baseUrl/pengiriman/tanggal/$date');
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      final List<dynamic> data = responseBody['data'] ?? [];
      return data.map((item) => PengirimanDetailModel.fromJson(item)).toList();
    } else {
      throw Exception('Error in getPengirimanData');
    }
  }
}
