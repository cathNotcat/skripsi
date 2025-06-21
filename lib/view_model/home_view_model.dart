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

  String notif = '';
  bool noNotif = true;
  bool isLoadingSupir = true;

  String? baseUrl = '';
  String? selectedSopir;
  String? platNo;

  Future<void> fetchSopirNow() async {
    final prefs = await SharedPreferences.getInstance();
    selectedSopir = prefs.getString('selected_sopir');
    platNo = prefs.getString('plat_nomor');
    notifyListeners();
  }

  Future<void> fetchPengirimanData() async {
    // Reset values
    pesanan = 0;
    selesai = 0;
    noDO.clear();
    noNotif = true;
    notif = '';
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    String? sopir = prefs.getString('selected_sopir');

    try {
      final List<PengirimanDetailModel> dataList = await pengirimanService
          .getPengirimanByDate(DateFormatter.formatToday(), sopir ?? '');

      for (var item in dataList) {
        final status = item.status;

        if (status == "0" || status == "1") {
          pesanan++;
        } else if (status == "2") {
          selesai++;
          noDO.add(item.noDO);
        }
      }
      print('pesanan in fetchPengirimanData before: $pesanan');

      if (dataList.isNotEmpty) {
        print('pesanan in fetchPengirimanData: $pesanan');
        notif = 'Anda memiliki $pesanan pesanan';
        noNotif = false;
      } else {
        notif = 'Tidak ada pesanan untuk hari ini';
      }

      notifyListeners();
    } catch (e) {
      print('Error in fetchPengirimanData ViewModel: $e');
    }
  }

  void fetchSopir() async {
    final result = await sopirService.getSopir();
    sopir = result;
    isLoadingSupir = false;
    notifyListeners();
    print('sopir: ${sopir}');
  }

  Future<void> refreshData() async {
    fetchSopir();
    fetchPengirimanData();
  }
}
