import 'package:flutter/material.dart';
import 'package:web_admin_1/models/dbspp_model.dart';
import 'package:web_admin_1/models/dbsppdet_model.dart';
import 'package:web_admin_1/services/pesanan_service.dart';

class TambahPesananViewModel extends ChangeNotifier {
  final apiService = PesananService();
  DBSPPModel? dbsppData;

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

  // List<DBSPPModel> details = [];
  List<DBSPPDetModel> listOfPesanan = [];

  Future<void> fetchDbsppData() async {
    try {
      dbsppData = await apiService.getDbsppData(inputDoController.text);

      if (dbsppData != null) {
        noUrutController.text = dbsppData!.noUrut;
        noSoController.text = dbsppData!.noSO;
        noPesanController.text = dbsppData!.noPesan;
        customerController.text = dbsppData!.kodeCustSupp;
      }
      notifyListeners();
    } catch (e) {
      print('Error in fetchDbsppData. Errors: $e');
    }
  }

  Future<void> fetchDbsppDetData() async {
    try {
      final List<DBSPPDetModel> dbsppDetData =
          await apiService.getDbsppDetData(inputDoController.text);
      isLoading = false;
      if (dbsppDetData.isNotEmpty) {
        listOfPesanan = dbsppDetData;
      }
    } catch (e) {
      print('Error in fetchDbsppDetData. Errors: $e');
    }
  }
}
