import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_admin_1/models/pengiriman_model.dart';
import 'package:web_admin_1/services/pengiriman_service.dart';

class PengirimanViewModel extends ChangeNotifier {
  final apiService = PengirimanService();

  int totalPesanan7Hari = 0;
  int totalBarang = 0;

  List<PengirimanModel> details = [];
  List<PengirimanAllModel> allModel = [];
  bool isLoading = true;
  bool isLoadingPesanan = true;
  bool isLoadingPesananByTanggal = true;
  bool adaPengiriman = false;

  int pesanan = 0;
  int belumDikirim = 0;
  int sedangDikirim = 0;
  int selesai = 0;
  int allPengiriman = 0;
  int countAllPengiriman = 0;

  List<GroupedPengirimanModel> groupedList = [];

  Future<void> fetchPengirimanData(String formattedDate) async {
    try {
      final List<PengirimanModel> data =
          await apiService.getPengirimanData(formattedDate);

      print('Raw data: ${data.runtimeType}');

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
      print('Error in fetchPengirimanData in pengiriman view model: $e');
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

  Future<void> fetchBarang() async {
    int totalPesanan = 0;
    int totalBrg = 0;

    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final result = await fetchPengirimanList(formattedDate);
      totalPesanan += result.length;

      for (final item in result) {
        final jumlah = int.tryParse(item.jumlahBarang) ?? 0;
        totalBrg += jumlah;
      }
    }

    totalPesanan7Hari = totalPesanan;
    totalBarang = totalBrg;
    isLoadingPesanan = false;
    notifyListeners();
  }

  Future<void> fetchAllPengirimanByTanggal() async {
    try {
      groupedList = await apiService.getAllPengirimanDataByTanggal();
      isLoadingPesananByTanggal = false;

      for (var pengiriman in groupedList) {
        allModel = pengiriman.pengirimanList;
        for (var i = 0; i < allModel.length; i++) {
          allPengiriman += 1;
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error fetching grouped pengiriman: $e');
    }
  }

  String changeStatus(String status) {
    switch (status) {
      case '0':
        return 'Belum Dikirim';
      case '1':
        return 'Sedang Dikirim';
      case '2':
        return 'Selesai';
      default:
        return '';
    }
  }

  Color changeStatusColor(String status) {
    switch (status) {
      case '0':
        return const Color.fromARGB(255, 255, 98, 83);
      case '1':
        return const Color.fromARGB(255, 255, 184, 98);
      case '2':
        return const Color.fromARGB(255, 25, 206, 121);
      default:
        return const Color.fromARGB(255, 217, 217, 217);
    }
  }
}
