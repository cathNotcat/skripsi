import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_1/view_models/tambah_pesanan_view_model.dart';
import 'package:web_admin_1/widget/button.dart';
import 'package:web_admin_1/widget/date_formatter.dart';
import 'package:web_admin_1/widget/error_top_snackbar.dart';
import 'package:web_admin_1/widget/input_field.dart';

class TambahScreen extends StatefulWidget {
  const TambahScreen({super.key});

  @override
  State<TambahScreen> createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  @override
  Widget build(BuildContext context) {
    int counter = 1;
    int counterTambah = 1;
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = TambahPesananViewModel();
        viewModel.fetchPengirimanData(DateFormatter.formatToday());
        print('islihat detail: ${viewModel.isLihatDetail}');
        return viewModel;
      },
      child: Scaffold(
        body: Consumer<TambahPesananViewModel>(
          builder: (context, viewModel, _) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),
                    Text(
                      'Tambah Pesanan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(16),
                      // height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InputField(
                                  label: 'Input No. DO',
                                  controller: viewModel.inputDoController,
                                  isInput: true,
                                ),
                                SizedBox(height: 12),
                                InputField(
                                  label: 'No. Urut',
                                  controller: viewModel.noUrutController,
                                ),
                                SizedBox(height: 12),
                                InputField(
                                  label: 'Tanggal Kirim',
                                  controller: viewModel.tanggalKirimController,
                                  isDate: true,
                                  isInput: true,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 32),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InputField(
                                  label: 'No. SO',
                                  controller: viewModel.noSoController,
                                ),
                                SizedBox(height: 12),
                                InputField(
                                  label: 'Customer',
                                  controller: viewModel.customerController,
                                ),
                                SizedBox(height: 12),
                                InputField(
                                  label: 'No Pesan',
                                  controller: viewModel.noPesanController,
                                ),
                                SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ButtonDetail(
                                        'Lihat Detail',
                                        viewModel.fetchDbsppData,
                                        viewModel.fetchDbsppDetData),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    viewModel.isLihatDetail
                        ? viewModel.isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Column(
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
                                          4: FlexColumnWidth(1),
                                          5: FlexColumnWidth(1),
                                        },
                                        border: TableBorder.all(
                                            color: Colors.grey[300]!),
                                        children: [
                                          TableRow(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200]),
                                            children: const [
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'No.',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Kode Barang',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)))),
                                              Center(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Nama Barang',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)))),
                                              Center(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Qnt',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)))),
                                              Center(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Satuan',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)))),
                                              Center(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Keterangan',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)))),
                                            ],
                                          ),
                                          ...viewModel.detailDO.map(
                                            (item) => TableRow(
                                              children: [
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text('${counter++}'),
                                                  ),
                                                ),
                                                Center(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                            item.kodeBarang))),
                                                Center(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                            item.namaBarang))),
                                                Center(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                            item.quantity))),
                                                Center(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child:
                                                            Text(item.satuan))),
                                                Center(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                            item.keterangan))),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  ButtonDetail(
                                    'Tambah Pesanan',
                                    () => viewModel.tambahPesanan(
                                      // noDO: viewModel.inputDoController.text,
                                      // kodeCust:
                                      //     viewModel.customerController.text,
                                      // tanggalKirim:
                                      //     viewModel.tanggalKirimController.text,
                                      showSnackBar: (msg, color) =>
                                          ErrorTopSnackbar.show(
                                        context,
                                        message: msg,
                                        backgroundColor: color,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                        : SizedBox(),
                    SizedBox(height: 24),
                    viewModel.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : viewModel.isPesananExist
                            ? Column(
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
                                          4: FlexColumnWidth(0.5),
                                        },
                                        border: TableBorder.all(
                                            color: Colors.grey[300]!),
                                        children: [
                                          TableRow(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200]),
                                            children: const [
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'No.',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('No. DO',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)))),
                                              Center(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Customer',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)))),
                                              Center(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Nama',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)))),
                                              Center(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Hapus',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)))),
                                            ],
                                          ),
                                          // Data rows
                                          ...viewModel.listOfPesanan.map(
                                            (item) => TableRow(
                                              children: [
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                        '${counterTambah++}'),
                                                  ),
                                                ),
                                                Center(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child:
                                                            Text(item.noDO))),
                                                Center(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(item
                                                            .kodeCustSupp))),
                                                Center(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child:
                                                            Text(item.nama))),
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          print(
                                                              'pressed hapus');
                                                          viewModel
                                                              .hapusPesanan(
                                                            context: context,
                                                            showSnackBar: (msg,
                                                                    color) =>
                                                                ErrorTopSnackbar
                                                                    .show(
                                                              context,
                                                              message: msg,
                                                              backgroundColor:
                                                                  color,
                                                            ),
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : SizedBox()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
