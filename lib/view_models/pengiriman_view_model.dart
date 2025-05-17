import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_admin_1/models/pengiriman_all_model.dart';
import 'package:web_admin_1/models/pengiriman_model.dart';
import 'package:web_admin_1/services/pengiriman_service.dart';

class PengirimanViewModel extends ChangeNotifier {
  final apiService = PengirimanService();

  int totalPesanan7Hari = 0;

  List<PengirimanModel> details = [];
  bool isLoading = true;
  bool adaPengiriman = false;

  int pesanan = 0;
  int belumDikirim = 0;
  int sedangDikirim = 0;
  int selesai = 0;

  List<GroupedPengirimanModel> groupedList = [];

  Future<void> fetchPengirimanData(String formattedDate) async {
    try {
      final List<PengirimanModel> data =
          await apiService.getPengirimanData(formattedDate);

      details = data;
      isLoading = false;

      if (data.isNotEmpty) {
        adaPengiriman = true;
        statusCount(data);
      } else {
        adaPengiriman = false;
        statusCount([]);
      }

      notifyListeners();
    } catch (e) {
      print('Error in fetchPengirimanData: $e');
    }
  }

  void statusCount(List<PengirimanModel> data) {
    pesanan = data.length;
    belumDikirim = data.where((item) => item.status == '0').length;
    sedangDikirim = data.where((item) => item.status == '1').length;
    selesai = data.where((item) => item.status == '2').length;
  }

  Future<List<PengirimanModel>> fetchPengirimanList(
      String formattedDate) async {
    try {
      return await apiService.getPengirimanData(formattedDate);
    } catch (e) {
      print('Error in fetchPengirimanList: $e');
      return [];
    }
  }

  Future<void> fetchPesananSeminggu() async {
    int total = 0;

    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final result = await fetchPengirimanList(formattedDate);
      total += result.length;
    }

    totalPesanan7Hari = total;
    notifyListeners();
  }

  Future<void> fetchAllPengirimanByTanggal() async {
    try {
      groupedList = await apiService.getAllPengirimanDataByTanggal();

      notifyListeners();
    } catch (e) {
      print('Error fetching grouped pengiriman: $e');
    }
  }
}
