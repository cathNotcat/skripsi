import 'package:aplikasi_1/models/pengiriman_model.dart';
import 'package:aplikasi_1/services/pengiriman_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryViewModel extends ChangeNotifier {
  final apiService = PengirimanService();

  int totalPesanan7Hari = 0;
  int totalBarang = 0;

  List<PengirimanDetailModel> details = [];
  bool isLoading = true;
  bool isLoadingPesanan = true;
  bool isLoadingPesananByTanggal = true;
  bool adaPengiriman = false;

  int pesanan = 0;
  int belumDikirim = 0;
  int sedangDikirim = 0;
  int selesai = 0;

  String errorMessage = '';

  List<GroupedPengirimanModel> groupedList = [];

  Future<void> fetchPengirimanData(String formattedDate) async {
    try {
      final List<PengirimanDetailModel> data =
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

  void statusCount(List<PengirimanDetailModel> data) {
    pesanan = data.length;
    belumDikirim = data.where((item) => item.status == '0').length;
    sedangDikirim = data.where((item) => item.status == '1').length;
    selesai = data.where((item) => item.status == '2').length;
  }

  Future<List<PengirimanDetailModel>> fetchPengirimanList(
      String formattedDate) async {
    try {
      return await apiService.getPengirimanData(formattedDate);
    } catch (e) {
      print('Error in fetchPengirimanList: $e');
      return [];
    }
  }

  Future<void> fetchPesananSeminggu() async {
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
      print('grouplist in viewmodel: $groupedList');
      // if (groupedList.isEmpty) {
      //   errorMessage = 'Tidak ada data pengiriman.';
      // }
      isLoadingPesananByTanggal = false;

      notifyListeners();
    } catch (e) {
      if (groupedList.isEmpty) {
        errorMessage = 'Tidak ada data pengiriman.';
      }
      isLoadingPesananByTanggal = false;
      notifyListeners();
      print('Error fetching grouped pengiriman: $e');
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
