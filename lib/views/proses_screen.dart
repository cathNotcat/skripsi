// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_1/models/pengiriman_model.dart';
import 'package:web_admin_1/models/pesanan_model.dart';
import 'package:web_admin_1/view_models/pengiriman_view_model.dart';
import 'package:web_admin_1/widget/button.dart';
import 'package:web_admin_1/widget/date_formatter.dart';
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
        viewModel.fetchPengirimanData(formattedDate);
        // viewModel.fetchPengirimanBySopir(formattedDate);
        // viewModel.fetchSopirNow();
        // viewModel.initSelected(details);
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
                      'Proses',
                      // 'Proses ${viewModel.selectedSopir}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Button('+ Tambah Pesanan', '/tambahPesanan'),
                  ],
                ),
                SizedBox(height: 12),
                // _listPengiriman(v iewModel, viewModel.details)
                viewModel.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : viewModel.adaPengiriman == false
                        ? _nullPengiriman()
                        : _listPengiriman(viewModel, viewModel.details,
                            viewModel.tempPengirimanList)
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

  Widget _listPengiriman(
    PengirimanViewModel viewModel,
    List<PengirimanModel> details,
    List<PengirimanModel> tempPengirimanList,
  ) {
    return Column(
      children: [
        SizedBox(height: 8),
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
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                    },
                    border: TableBorder.all(color: Colors.grey[300]!),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        children: [
                          _columnTitles('No Bukti'),
                          _columnTitles('Nama Customer'),
                          _columnTitles('Alamat'),
                          _columnTitles('Status'),
                        ],
                      ),
                      ...details.map((item) => TableRow(
                            children: [
                              Center(
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(item.noDO))),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(item.nama),
                              )),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(item.alamat),
                              )),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(item.status),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    getStatusString(item.status),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                            ],
                          )),
                      ...tempPengirimanList.map((item) => TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: viewModel.selectedMap[item.noDO] ??
                                          false,
                                      onChanged: (bool? value) {
                                        viewModel.toggleSelection(
                                            item.noDO, value ?? false);
                                      },
                                    ),
                                    Expanded(child: Text(item.noDO)),
                                  ],
                                ),
                              ),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(item.nama),
                              )),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(item.alamat),
                              )),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[200],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "Belum Kalkulasi",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        if (viewModel.selectedMap.containsValue(true))
          viewModel.isCalculating
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () async {
                    print('Kalkulasi Rute pressed');
                    await viewModel.selesaiPesanan();
                    viewModel.moveSelectedToRutePengiriman();
                    await viewModel
                        .fetchPengirimanData(DateFormatter.formatToday());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 23, 96, 232),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Kalkulasi Rute',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
        SizedBox(height: 24),
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
