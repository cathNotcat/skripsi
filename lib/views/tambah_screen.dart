// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_1/view_models/tambah_pesanan_view_model.dart';
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
        return viewModel;
      },
      child: Scaffold(
        body: Consumer<TambahPesananViewModel>(
          builder: (context, viewModel, _) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'Tambah Pesanan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
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
                                const SizedBox(height: 12),
                                InputField(
                                  label: 'No. Urut',
                                  controller: viewModel.noUrutController,
                                ),
                                const SizedBox(height: 12),
                                InputField(
                                  label: 'Tanggal Kirim',
                                  controller: viewModel.tanggalKirimController,
                                  isDate: true,
                                  isInput: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InputField(
                                  label: 'No. SO',
                                  controller: viewModel.noSoController,
                                ),
                                const SizedBox(height: 12),
                                InputField(
                                  label: 'Customer',
                                  controller: viewModel.customerController,
                                ),
                                const SizedBox(height: 12),
                                InputField(
                                  label: 'No Pesan',
                                  controller: viewModel.noPesanController,
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        counter = 1;
                                        counterTambah = 1;
                                        print('clicked');
                                        viewModel.fetchDbsppData(
                                            showSnackBar: (msg, color) =>
                                                ErrorTopSnackbar.show(
                                                  context,
                                                  message: msg,
                                                  backgroundColor: color,
                                                ));
                                        print('clicked');
                                        viewModel.fetchDbsppDetData();
                                        print('clicked');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 23, 96, 232),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        'Lihat Detail',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    viewModel.isLihatDetail
                        ? viewModel.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
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
                                            children: [
                                              _columnHeader('No.'),
                                              _columnHeader('Kode Barang'),
                                              _columnHeader('Nama Barang'),
                                              _columnHeader('Qnt'),
                                              _columnHeader('Satuan'),
                                              _columnHeader('Keterangan'),
                                            ],
                                          ),
                                          ...viewModel.detailDO.map(
                                            (item) => TableRow(
                                              children: [
                                                _columnValue('${counter++}'),
                                                _columnValue(item.kodeBarang),
                                                _columnValue(item.namaBarang),
                                                _columnValue(item.quantity),
                                                _columnValue(item.satuan),
                                                _columnValue(item.keterangan),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await viewModel.tambahPesanan(
                                        showSnackBar: (msg, color) =>
                                            ErrorTopSnackbar.show(
                                          context,
                                          message: msg,
                                          backgroundColor: color,
                                        ),
                                      );
                                      counter = 1;
                                      counterTambah = 1;
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 23, 96, 232),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Tambah Pesanan',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              )
                        : const SizedBox(),
                    const SizedBox(height: 24),
                    viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : viewModel.isPesananExist
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
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
                                            children: [
                                              _columnHeader('No.'),
                                              _columnHeader('No.DO'),
                                              _columnHeader('Customer'),
                                              _columnHeader('Nama'),
                                              _columnHeader('Hapus'),
                                            ],
                                          ),
                                          // Data rows
                                          ...viewModel.listOfPesanan.map(
                                            (item) => TableRow(
                                              children: [
                                                _columnValue(
                                                    '${counterTambah++}'),
                                                _columnValue(item.noDO),
                                                _columnValue(item.kodeCustSupp),
                                                _columnValue(item.nama),
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: IconButton(
                                                        onPressed: () {
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
                                                        icon: const Icon(
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
                                  ),
                                  SizedBox(height: 24),
                                  viewModel.isCalculating
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : ElevatedButton(
                                          onPressed: () async {
                                            await viewModel.selesaiPesanan();
                                            Navigator.of(context)
                                                .pushNamed('/sopirProses');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                                255, 23, 96, 232),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            'Selesai',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                ],
                              )
                            : const SizedBox()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _columnHeader(String value) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.bold))));
  }

  Widget _columnValue(String value) {
    return Center(
        child: Padding(padding: const EdgeInsets.all(8.0), child: Text(value)));
  }
}
