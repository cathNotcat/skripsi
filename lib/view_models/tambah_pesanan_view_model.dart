import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:web_admin_1/held_karp.dart';
import 'package:web_admin_1/models/customer_model.dart';
import 'package:web_admin_1/models/dbspp_model.dart';
import 'package:web_admin_1/models/pesanan_model.dart';
import 'package:web_admin_1/services/customer_service.dart';
import 'package:web_admin_1/services/notification_service.dart';
import 'package:web_admin_1/services/pengiriman_service.dart';
import 'package:web_admin_1/services/pesanan_service.dart';

class TambahPesananViewModel extends ChangeNotifier {
  final pesananService = PesananService();
  final pengirimanService = PengirimanService();
  final customerService = CustomerService();
  final notificationService = NotificationService();

  DBSPPModel? dbsppData;
  CustomerModel? customer;

  bool isLihatDetail = false;
  bool isLoading = true;
  bool isPesananExist = false;
  bool isCalculating = false;

  List<String> points = ['-7.375729652261953, 112.6788318829139'];
  Map<String, String> custCoordinateMap = {};
  String namaCust = '';
  String message = '';
  int counter = 1;

  DateTime now = DateTime.now();

  final TextEditingController inputDoController = TextEditingController();
  final TextEditingController noUrutController = TextEditingController();
  final TextEditingController tanggalKirimController = TextEditingController();
  final TextEditingController noPesanController = TextEditingController();
  final TextEditingController noSoController = TextEditingController();
  final TextEditingController customerController = TextEditingController();

  List<PesananModel> listOfPesanan = [];
  List<DBSPPDetModel> detailDO = [];

  final deviceToken = dotenv.env['NOTIF_DEVICE_TOKEN'] ?? '';

  Future<void> fetchPengirimanData(String formattedDate) async {
    try {
      final List<PesananModel> data =
          await pesananService.getPengirimanData(formattedDate);

      isLoading = false;

      if (data.isNotEmpty) {
        isPesananExist = true;
        listOfPesanan = data;
      } else {
        isPesananExist = false;
      }

      notifyListeners();
    } catch (e) {
      print('Error in fetchPengirimanData in tambah pesanan view model: $e');
    }
  }

  Future<void> fetchDbsppData() async {
    String dateNow = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    try {
      if (inputDoController.text != '' || inputDoController.text.isNotEmpty) {
        dbsppData = await pesananService.getDbsppData(inputDoController.text);
        print('dbspp data: $dbsppData');
        if (dbsppData != null) {
          noUrutController.text = dbsppData!.noUrut;
          noSoController.text = dbsppData!.noSO;
          tanggalKirimController.text = dateNow;
          noPesanController.text = dbsppData!.noPesan;
          customerController.text = dbsppData!.kodeCustSupp;
          isLoading = false;
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error in fetchDbsppData. Errors: $e');
    }
  }

  Future<void> fetchDbsppDetData() async {
    try {
      final List<DBSPPDetModel> dbsppDetData =
          await pesananService.getDbsppDetData(inputDoController.text);
      isLoading = false;
      isLihatDetail = true;
      print('islihatdetail after: $isLihatDetail');
      if (dbsppDetData.isNotEmpty) {
        detailDO = dbsppDetData;
        isLoading = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error in fetchDbsppDetData. Errors: $e');
    }
  }

  Future<void> fetchCustDetails(String kodeCust) async {
    try {
      customer = await customerService.getCustomerDetails(kodeCust);
      namaCust = customer!.nama;
      String coordinate = customer!.koordinat;
      points.add(coordinate.toString());
      custCoordinateMap[kodeCust] = coordinate;
      notifyListeners();
    } catch (e) {
      print('Error in fetchCustDetails: $e');
    }
  }

  Future<void> tambahPesanan({
    required void Function(String message, Color color) showSnackBar,
  }) async {
    isPesananExist = true;

    final isNoDOExist =
        listOfPesanan.any((item) => item.noDO == inputDoController.text);

    if (isNoDOExist) {
      showSnackBar("No. DO sudah ada!", Colors.red);
      return;
    }

    await fetchCustDetails(customerController.text);

    final newPesanan = PesananModel(
      noDO: inputDoController.text,
      kodeSopir: 'ADI',
      kodeCustSupp: customerController.text,
      tanggalKirim: tanggalKirimController.text,
      nama: namaCust,
      status: '0',
    );

    listOfPesanan.add(newPesanan);
    print('list of pesanan: $listOfPesanan');
    notifyListeners();
  }

  Future<void> hapusPesanan({
    required BuildContext context,
    required void Function(String msg, Color color) showSnackBar,
  }) async {
    listOfPesanan.removeWhere((item) => item.noDO == inputDoController.text);
    notifyListeners();

    try {
      final success = await pesananService.hapusPesanan(
          inputDoController.text, tanggalKirimController.text);
      if (success) {
        showSnackBar('Pesanan berhasil dihapus', Colors.green.shade300);
      } else {
        showSnackBar('Gagal menghapus pesanan', Colors.red);
      }
    } catch (e) {
      print('Gagal hapus pesanan: $e');
      showSnackBar('Terjadi kesalahan saat menghapus', Colors.red);
    }
  }

  Future<void> selesaiPesanan() async {
    if (points.isEmpty) {
      print('Tidak ada koordinat');
      return;
    }

    isCalculating = true;
    notifyListeners();
    try {
      List<String> sortedKodeCustSupp = await _calculateHeldKarp();

      List<Map<String, dynamic>> sortedPesanan = [];
      for (String kodeCust in sortedKodeCustSupp) {
        PesananModel? pesanan = listOfPesanan
            .where((item) => item.kodeCustSupp == kodeCust)
            .cast<PesananModel?>()
            .firstOrNull;

        if (pesanan != null) {
          sortedPesanan.add({
            'NoDO': pesanan.noDO,
            'KodeSopir': pesanan.kodeSopir,
            'KodeCustSupp': pesanan.kodeCustSupp,
            'TanggalKirim': pesanan.tanggalKirim,
            'Status': pesanan.status,
          });
        }
      }

      print('sortedPesanan before: $sortedPesanan');
      await pengirimanService.uploadPesanan(sortedPesanan);
      // await notificationService.sendNotifications(sortedPesanan);
      notifyListeners();
    } catch (e) {
      print('Error in selesaiPesanan: $e');
    }

    isCalculating = false;
    notifyListeners();
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

  Future<List<String>> _calculateHeldKarp() async {
    List<LatLng> pointsConverted = convertToLatLngList(points);

    HeldKarp heldKarp = HeldKarp();
    List<LatLng> pointsWithHeldKarp =
        await heldKarp.calculateWithHeldKarp(pointsConverted);

    print('before heldkarp: $points');
    print('after heldkarp: $pointsWithHeldKarp');

    List<String> sortedKodeCustSupp = [];

    for (LatLng coord in pointsWithHeldKarp) {
      String coordString =
          "${coord.latitude.toStringAsFixed(15)}, ${coord.longitude.toStringAsFixed(15)}";
      print("Checking for: $coordString");

      for (var entry in custCoordinateMap.entries) {
        print("Stored: ${entry.value} -> ${entry.key}");
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
        sortedKodeCustSupp.add(kodeCust);
      }
    }

    print("Sorted KodeCustSupp after Held-Karp: $sortedKodeCustSupp");

    return sortedKodeCustSupp;
  }
}
