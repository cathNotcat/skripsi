import 'package:flutter/material.dart';
import 'package:web_admin_1/models/customer_model.dart';
import 'package:web_admin_1/models/dbspp_model.dart';
import 'package:web_admin_1/models/pesanan_model.dart';
import 'package:web_admin_1/services/customer_service.dart';
import 'package:web_admin_1/services/pengiriman_service.dart';
import 'package:web_admin_1/services/pesanan_service.dart';

class TambahPesananViewModel extends ChangeNotifier {
  final pesananService = PesananService();
  final pengirimanService = PengirimanService();
  final customerService = CustomerService();
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

  List<PesananModel> listOfPesanan = [];
  List<DBSPPDetModel> detailDO = [];
  // List<PesananModel> detailPengiriman = [];
  CustomerModel? customer;

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
      print('Error in fetchPengirimanData: $e');
    }
  }

  Future<void> fetchDbsppData() async {
    try {
      if (inputDoController.text != '' || inputDoController.text.isNotEmpty) {
        dbsppData = await pesananService.getDbsppData(inputDoController.text);
        print('dbspp data: $dbsppData');
        if (dbsppData != null) {
          noUrutController.text = dbsppData!.noUrut;
          noSoController.text = dbsppData!.noSO;
          noPesanController.text = dbsppData!.noPesan;
          customerController.text = dbsppData!.kodeCustSupp;
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
      status: 0,
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
}
