import 'package:aplikasi_1/models/pengiriman_model.dart';
import 'package:aplikasi_1/models/sopir_model.dart';
import 'package:aplikasi_1/services/pengiriman_service.dart';
import 'package:aplikasi_1/services/sopir_service.dart';
import 'package:aplikasi_1/widget/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeViewModel extends ChangeNotifier {
  final pengirimanService = PengirimanService();
  final sopirService = SopirService();
  Sopir? sopir;

  int pesanan = 0;
  int selesai = 0;
  List<String> noDO = [];

  String hariIni = '';

  String notif = 'Tidak ada pesanan untuk hari ini';
  bool noNotif = true;
  bool isLoadingSupir = true;

  String? baseUrl = '';

  // Future<void> getPengirimanSopirData() async {
  //   pesanan = 0;
  //   selesai = 0;
  //   noDO.clear();

  //   String formattedDate = DateFormatter.formatDateToday();

  //   final prefs = await SharedPreferences.getInstance();
  //   baseUrl = prefs.getString('ip_address');
  //   notifyListeners();
  //   var url = Uri.parse('$baseUrl/pengiriman/tanggal/$formattedDate');

  //   try {
  //     var response = await http.get(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //     if (response.statusCode == 200) {
  //       var responseBody = jsonDecode(response.body);
  //       var data = responseBody['data'];
  //       if (data != null) {
  //         for (var item in data) {
  //           String status = item["Status"];
  //           if (status == "0" || status == "1") {
  //             pesanan++;
  //             notifyListeners();
  //           }
  //           if (status == "2") {
  //             selesai++;
  //             noDO.add(item['NoDO']);
  //             notifyListeners();
  //           }
  //           if (responseBody['message'] != 'No data found') {
  //             notif = 'Anda memiliki $pesanan pesanan';
  //             noNotif = false;
  //             notifyListeners();
  //           }
  //         }
  //       } else {
  //         print('Unexpected response structure.');
  //       }
  //     } else {
  //       print(
  //         'Gagal memuat user di _getPengirimanSopirData Home: ${response.statusCode}',
  //       );
  //     }
  //   } catch (e) {
  //     print('Error in _getPengirimanSopirData: $e');
  //   }
  // }
  Future<void> getPengirimanSopirData() async {
    // Reset values
    pesanan = 0;
    selesai = 0;
    noDO.clear();
    noNotif = true;
    notif = '';
    notifyListeners();

    try {
      final List<PengirimanModel> dataList = await pengirimanService
          .getPengirimanByDate(DateFormatter.formatDateToday());

      for (var item in dataList) {
        final status = item.status;

        if (status == "0" || status == "1") {
          pesanan++;
        } else if (status == "2") {
          selesai++;
          noDO.add(item.noDO);
        }
      }

      if (dataList.isNotEmpty) {
        notif = 'Anda memiliki $pesanan pesanan';
        noNotif = false;
      }

      notifyListeners();
    } catch (e) {
      print('Error in getPengirimanSopirData ViewModel: $e');
    }
  }

  void getSopir() async {
    final result = await sopirService.getSopir();
    sopir = result;
    isLoadingSupir = false;
    notifyListeners();
    print('sopir: ${sopir}');
  }

  Future<void> refreshData() async {
    getSopir();
    getPengirimanSopirData();
  }
}
