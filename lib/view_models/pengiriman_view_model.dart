import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_admin_1/held_karp.dart';
import 'package:web_admin_1/k_means.dart';
import 'package:web_admin_1/models/customer_model.dart';
import 'package:web_admin_1/models/latlng_model.dart';
import 'package:web_admin_1/models/pengiriman_model.dart';
import 'package:web_admin_1/models/pesanan_model.dart';
import 'package:web_admin_1/services/customer_service.dart';
import 'package:web_admin_1/services/pengiriman_service.dart';
import 'package:web_admin_1/services/sopir_service.dart';
import 'package:web_admin_1/services/target_service.dart';
import 'package:web_admin_1/widget/charts.dart';
import 'package:web_admin_1/widget/date_formatter.dart';
import 'package:collection/collection.dart';

const monthMap = {
  "January": "Jan",
  "February": "Feb",
  "March": "Mar",
  "April": "Apr",
  "May": "May",
  "June": "Jun",
  "July": "Jul",
  "August": "Aug",
  "September": "Sep",
  "October": "Oct",
  "November": "Nov",
  "December": "Dec",
};

class PengirimanViewModel extends ChangeNotifier {
  final apiService = PengirimanService();
  final sopirService = SopirService();
  final pengirimanService = PengirimanService();
  final monthlyService = TargetService();
  final customerService = CustomerService();

  CustomerModel? customer;

  int totalPesanan7Hari = 0;
  int totalBarang = 0;

  String namaCust = '';
  String alamatCust = '';

  List<PengirimanModel> details = [];
  List<PengirimanAllModel> allModel = [];
  List<String> namaSopir = [];

  bool isLoading = false;
  // bool isLoading = true;
  bool isLoadingPesanan = true;
  bool isLoadingPesananByTanggal = true;
  bool adaPengiriman = false;
  bool isCalculating = false;

  int pesanan = 0;
  int belumDikirim = 0;
  int sedangDikirim = 0;
  int selesai = 0;
  int allPengiriman = 0;
  int countAllPengiriman = 0;
  int totalYear = 0;

  DateTime? filterDate;
  String? filterSopir;
  int? filterStatus;

  String? selectedSopir;

  List<BarChartItem> items = [];
  String? error;

  List<String> points = [];
  // List<String> points = ['-7.375729652261953, 112.6788318829139'];
  List<GroupedPengirimanModel> groupedList = [];
  List<GroupedPengirimanModel> filteredGroupedList = [];
  List<GroupedPengirimanModel> _originalGroupedList = [];
  List<PesananModel> selectedPesananForCalculation = [];
  List<PesananModel> tempPesananList = [];
  List<PengirimanModel> tempPengirimanList = [];
  List<PesananModel> listOfPesanan = [];
  List<PengirimanModel> rutePengirimanList = [];

  Map<String, String> custCoordinateMap = {};

  Map<String, bool> selectedMap = {};

  void toggleSelection(String noDO, bool isSelected) {
    selectedMap[noDO] = isSelected;
    notifyListeners();
  }

  void togglePesananSelection(PesananModel pesanan, bool selected) {
    if (selected) {
      selectedPesananForCalculation.add(pesanan);
    } else {
      selectedPesananForCalculation.removeWhere((p) => p.noDO == pesanan.noDO);
    }
    notifyListeners();
  }

  List<PengirimanModel> get selectedItems {
    return details.where((item) => selectedMap[item.noDO] == true).toList();
  }

  Future<void> loadMonthlyData() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await monthlyService.fetchMonthlySO();
      items = data.entries.map((entry) {
        final shortLabel = monthMap[entry.key] ?? entry.key;
        final value = double.tryParse(entry.value) ?? 0;
        return BarChartItem(label: shortLabel, value: value);
      }).toList();
      print('itemss: $items');
    } catch (e) {
      error = e.toString();
    }

    await countTotalMonthlySO();
    isLoading = false;
    notifyListeners();
  }

  Future<int> countTotalMonthlySO() async {
    final monthlySO = await monthlyService.fetchMonthlySO();
    monthlySO.forEach((key, value) {
      totalYear += int.tryParse(value) ?? 0;
    });

    print('total year: $totalYear');
    return totalYear;
  }

  double get maxY {
    final maxVal =
        items.map((e) => e.value).fold<double>(0, (a, b) => a > b ? a : b);
    return (maxVal / 10).ceil() * 10;
  }

  Future<void> fetchSopirNow() async {
    final prefs = await SharedPreferences.getInstance();
    selectedSopir = prefs.getString('selected_sopir');
    notifyListeners();
  }

  Future<void> fetchAllSopir() async {
    try {
      namaSopir.clear();
      final List<String> data = await sopirService.getAllSopir();

      print('nama sopir: $data');

      for (var nama in data) {
        namaSopir.add(nama);
      }
      notifyListeners();
    } catch (e) {
      print('Error in fetchAllSopir view model: $e');
    }
  }

  Future<void> fetchCustDetails(String kodeCust) async {
    try {
      customer = await customerService.getCustomerDetails(kodeCust);
      namaCust = customer!.nama;
      alamatCust = customer!.alamat;
      String coordinate = customer!.koordinat;
      points.add(coordinate.toString());
      custCoordinateMap[kodeCust] = coordinate;
      notifyListeners();
    } catch (e) {
      print('Error in fetchCustDetails: $e');
    }
  }

  List<LatLng> convertToLatLngList(List<String> coordinateStrings) {
    List<LatLng> latLngList = [];

    for (var coord in coordinateStrings) {
      List<String> parts = coord.split(',');

      if (parts.length == 2) {
        double latitude = double.parse(parts[0].trim());
        double longitude = double.parse(parts[1].trim());

        latLngList.add(LatLng(latitude, longitude));
      } else {
        print("Invalid coordinate format: $coord");
      }
    }

    return latLngList;
  }

  void moveSelectedToRutePengiriman() {
    final selectedNoDOs = selectedMap.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toSet();

    final movedItems = tempPengirimanList
        .where((item) => selectedNoDOs.contains(item.noDO))
        .toList();
    rutePengirimanList.addAll(movedItems);

    tempPengirimanList.removeWhere((item) => selectedNoDOs.contains(item.noDO));

    selectedMap.clear();
    notifyListeners();
  }

  Future<void> selesaiPesanan() async {
    if (points.isEmpty || custCoordinateMap.isEmpty) {
      print('Tidak ada koordinat');
      return;
    }

    isCalculating = true;
    notifyListeners();

    try {
      listOfPesanan = PesananTempStorage.tempPesananList;

      Map<int, List<String>> clusteredKodeCustSupp = await _calculateHeldKarp();

      List<Map<String, dynamic>> sortedPesanan = [];

      for (var entry in clusteredKodeCustSupp.entries) {
        int driverIndex = entry.key;
        List<String> sortedKodeCustSupp = entry.value;

        // Assign KodeSopir by cluster index
        String sopir = driverIndex == 0 ? 'Satuman' : 'Bakri';

        for (String kodeCust in sortedKodeCustSupp) {
          PesananModel? pesanan = listOfPesanan.firstWhereOrNull(
            (item) => item.kodeCustSupp == kodeCust,
          );

          if (pesanan != null) {
            sortedPesanan.add({
              'NoDO': pesanan.noDO,
              'KodeSopir': sopir,
              'KodeCustSupp': pesanan.kodeCustSupp,
              'TanggalKirim': pesanan.tanggalKirim,
              'Status': pesanan.status,
            });
          } else {
            print('⚠️ KodeCustSupp $kodeCust not found in listOfPesanan');
          }
        }
      }

      print('sortedPesanan before upload: $sortedPesanan');
      await pengirimanService.uploadPesanan(sortedPesanan);

      // Optional: you can also clear temp storage or update state here

      notifyListeners();
    } catch (e) {
      print('Error in selesaiPesanan: $e');
    }

    isCalculating = false;
    notifyListeners();
  }

  Future<Map<int, List<String>>> _calculateHeldKarp() async {
    LatLng startingPoint = LatLng(-7.375729652261953, 112.6788318829139);
    List<LatLng> deliveryPoints = convertToLatLngList(points);

    final stopwatch = Stopwatch()..start();
    final clusters = KMeans.clusterPoints(deliveryPoints, 2);

    Map<int, List<String>> clusteredKodeCustSupp = {};

    for (var entry in clusters.entries) {
      int driverIndex = entry.key;
      List<LatLng> clusterPoints = entry.value;

      final result = await HeldKarp()
          .calculateWithHeldKarp([startingPoint, ...clusterPoints]);
      List<LatLng> route = result['path'];
      print("Driver $driverIndex route: $route");

      List<String> sortedCusts = [];

      for (LatLng coord in route) {
        if ((coord.latitude - startingPoint.latitude).abs() < 0.000001 &&
            (coord.longitude - startingPoint.longitude).abs() < 0.000001) {
          continue;
        }

        String? kodeCust;
        double epsilon = 0.000001;

        for (var entry in custCoordinateMap.entries) {
          List<String> storedCoords = entry.value.split(',');
          double storedLat = double.parse(storedCoords[0]);
          double storedLng = double.parse(storedCoords[1]);

          if ((storedLat - coord.latitude).abs() < epsilon &&
              (storedLng - coord.longitude).abs() < epsilon) {
            kodeCust = entry.key;
            break;
          }
        }

        if (kodeCust != null) {
          sortedCusts.add(kodeCust);
        }
      }

      clusteredKodeCustSupp[driverIndex] = sortedCusts;
    }

    stopwatch.stop();
    print(
        'Held-Karp + clustering runtime: ${stopwatch.elapsedMilliseconds} ms');
    print("Clustered & sorted KodeCustSupp: $clusteredKodeCustSupp");

    return clusteredKodeCustSupp;
  }

  Future<void> fetchPengirimanData(String formattedDate) async {
    try {
      final List<PengirimanModel> data =
          await apiService.getPengirimanData(formattedDate);

      final List<PengirimanModel> temp =
          PengirimanTempStorage.tempPengirimanList;

      final Set<String> uploadedNoDOs = data.map((e) => e.noDO).toSet();

      details = data;

      tempPengirimanList =
          temp.where((item) => !uploadedNoDOs.contains(item.noDO)).toList();

      for (var item in tempPengirimanList) {
        await fetchCustDetails(item.kodeCustSupp);
      }

      isLoading = false;
      adaPengiriman = details.isNotEmpty || tempPengirimanList.isNotEmpty;
      statusCount([...details, ...tempPengirimanList]);

      notifyListeners();
    } catch (e) {
      print('Error in fetchPengirimanData: $e');
    }
  }

  Future<void> fetchPengirimanBySopir(String formattedDate) async {
    try {
      await fetchSopirNow();
      final List<PengirimanModel> data = await apiService
          .getPengirimanDataBySopir(formattedDate, selectedSopir ?? '');

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
      final data = await apiService.getAllPengirimanDataByTanggal();

      _originalGroupedList = data;
      filteredGroupedList = data;
      notifyListeners();

      isLoadingPesananByTanggal = false;

      for (var pengiriman in filteredGroupedList) {
        allModel = pengiriman.pengirimanList;
        for (var i = 0; i < allModel.length; i++) {
          allPengiriman += 1;
        }
      }

      setFilterStatus(0);
      groupedList = data;

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

  void _applyFilters() {
    filteredGroupedList = _originalGroupedList
        .map((group) {
          final isDateMatch = filterDate == null ||
              DateFormatter.formatDate(group.tanggal) ==
                  DateFormatter.formatDateFromDateTime(filterDate!);

          final filteredItems = group.pengirimanList.where((item) {
            final statusMatch = filterStatus == null ||
                int.tryParse(item.status.toString()) == filterStatus;
            final sopirMatch = filterSopir == null ||
                item.kodeSopir
                    .toLowerCase()
                    .contains(filterSopir!.toLowerCase());

            return statusMatch && sopirMatch;
          }).toList();

          if (isDateMatch && filteredItems.isNotEmpty) {
            return GroupedPengirimanModel(
              tanggal: group.tanggal,
              pengirimanList: filteredItems,
            );
          } else {
            return null;
          }
        })
        .whereType<GroupedPengirimanModel>()
        .toList();

    groupedList = _originalGroupedList
        .map((group) {
          final isDateMatch = filterDate == null ||
              DateFormatter.formatDate(group.tanggal) ==
                  DateFormatter.formatDateFromDateTime(filterDate!);

          final filteredItems = group.pengirimanList.where((item) {
            final statusMatch = filterStatus == null ||
                int.tryParse(item.status.toString()) == filterStatus;
            final sopirMatch = filterSopir == null ||
                item.kodeSopir
                    .toLowerCase()
                    .contains(filterSopir!.toLowerCase());

            return statusMatch && sopirMatch;
          }).toList();

          if (isDateMatch && filteredItems.isNotEmpty) {
            return GroupedPengirimanModel(
              tanggal: group.tanggal,
              pengirimanList: filteredItems,
            );
          } else {
            return null;
          }
        })
        .whereType<GroupedPengirimanModel>()
        .toList();

    notifyListeners();
  }

  void setFilterDate(DateTime? date) {
    filterDate = date;
    _applyFilters();
  }

  void setFilterSopir(String? sopir) {
    filterSopir = sopir?.isEmpty == true ? null : sopir;
    _applyFilters();
  }

  void setFilterStatus(int? status) {
    filterStatus = status;
    _applyFilters();
  }

  void clearFilter() {
    filterDate = null;
    filterStatus = null;
    filterSopir = null;
    _applyFilters();
  }

  void clearFilterBD() {
    filterDate = null;
    filterSopir = null;
    _applyFilters();
  }
}
