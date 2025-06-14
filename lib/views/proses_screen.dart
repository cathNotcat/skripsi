// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_1/models/pengiriman_model.dart';
import 'package:web_admin_1/view_models/pengiriman_view_model.dart';
import 'package:web_admin_1/widget/button.dart';
import 'package:web_admin_1/widget/header.dart';

class ProsesScreen extends StatelessWidget {
  const ProsesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = PengirimanViewModel();
        viewModel.fetchPengirimanBySopir(formattedDate);
        viewModel.fetchSopirNow();
        return viewModel;
      },
      child: Scaffold(
        body: Consumer<PengirimanViewModel>(builder: (context, viewModel, _) {
          return Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(
                  pesanan: viewModel.pesanan,
                  belumDikirim: viewModel.belumDikirim,
                  sedangDikirim: viewModel.sedangDikirim,
                  selesai: viewModel.selesai,
                ),
                SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Proses ${viewModel.selectedSopir}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Button('+ Tambah Pesanan', '/tambahPesanan'),
                  ],
                ),
                SizedBox(height: 12),
                viewModel.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : viewModel.adaPengiriman == false
                        ? _nullPengiriman()
                        : _listPengiriman(viewModel.details)
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _nullPengiriman() {
    return Container(
      height: 100,
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          'Tidak ada pengiriman',
          style: TextStyle(color: Color.fromARGB(255, 82, 89, 105)),
        ),
      ),
    );
  }

  Widget _listPengiriman(List<PengirimanModel> details) {
    return details.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Text(''),
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(
                                  1), // Adjust these to control the column width ratio
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(1),
                              3: FlexColumnWidth(1),
                            },
                            border: TableBorder.all(color: Colors.grey[300]!),
                            children: [
                              // Header row
                              TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                children: [
                                  _columnTitles('No Bukti'),
                                  _columnTitles('Nama Customer'),
                                  _columnTitles('Alamat'),
                                  _columnTitles('Status'),
                                ],
                              ),
                              // Data rows
                              ...details.map(
                                (item) => TableRow(
                                  children: [
                                    Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(item.noDO))),
                                    Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(item.nama))),
                                    Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(item.alamat))),
                                    Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 12,
                                                right: 12),
                                            decoration: BoxDecoration(
                                                color:
                                                    getStatusColor(item.status),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Text(
                                              getStatusString(item.status),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          );
  }

  Widget _columnTitles(String title) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String getStatusString(String status) {
    switch (status) {
      case '0':
        return 'Belum Dikirim';
      case '1':
        return 'Sedang Dikirim';
      case '2':
        return 'Selesai';
      default:
        return 'Error';
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case '0':
        return const Color.fromARGB(255, 239, 181, 176);
      case '1':
        return const Color.fromARGB(255, 251, 228, 199);
      case '2':
        return const Color.fromARGB(255, 183, 240, 213);
      default:
        return const Color.fromARGB(255, 217, 217, 217);
    }
  }
}
