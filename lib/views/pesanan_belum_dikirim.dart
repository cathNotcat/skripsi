// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_1/view_models/pengiriman_view_model.dart';
import 'package:web_admin_1/widget/date_formatter.dart';

class PesananBelumDikirim extends StatefulWidget {
  const PesananBelumDikirim({super.key});

  @override
  State<PesananBelumDikirim> createState() => _PesananBelumDikirimState();
}

class _PesananBelumDikirimState extends State<PesananBelumDikirim> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = PengirimanViewModel();
        viewModel.fetchAllPengirimanByTanggal();
        viewModel.fetchAllSopir();
        viewModel.setFilterStatus(0);
        return viewModel;
      },
      child: Scaffold(
        body: Consumer<PengirimanViewModel>(
          builder: (context, viewModel, _) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: viewModel.isLoadingPesananByTanggal
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        const Text('Pesanan Belum Dikirim',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickedDate != null) {
                                    viewModel.setFilterDate(pickedDate);
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(viewModel.filterDate == null
                                            ? 'Pilih Tanggal'
                                            : DateFormatter
                                                .formatDateFromDateTime(
                                                    viewModel.filterDate!)),
                                        Icon(Icons.arrow_drop_down)
                                      ],
                                    )),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: viewModel.filterSopir,
                                    hint: Text(
                                      'Pilih Sopir',
                                      style: TextStyle(
                                        color: Colors
                                            .black, // ✅ Set to desired color
                                        fontSize: 14,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      viewModel.setFilterSopir(value);
                                    },
                                    items: viewModel.namaSopir.map((sopir) {
                                      return DropdownMenuItem<String>(
                                        value: sopir,
                                        child: Text(sopir),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  viewModel.clearFilterBD();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Reset Filter'),
                                      Icon(Icons.restart_alt_outlined)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        viewModel.groupedList.isEmpty
                            ? Container(
                                height: 150,
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(child: Text('Tidak ada pesanan')),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      viewModel.filteredGroupedList.length > 7
                                          ? 7
                                          : viewModel
                                              .filteredGroupedList.length,
                                  itemBuilder: (context, index) {
                                    final group =
                                        viewModel.filteredGroupedList[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 8),
                                              padding: const EdgeInsets.all(24),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons
                                                              .date_range_outlined,
                                                          color: Color.fromARGB(
                                                              200, 50, 50, 50)),
                                                      const SizedBox(width: 16),
                                                      Text(
                                                        DateFormatter
                                                            .formatDate(
                                                                group.tanggal),
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Color.fromARGB(
                                                                    200,
                                                                    50,
                                                                    50,
                                                                    50)),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 24),
                                                  const Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text('No. DO',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start)),
                                                      Expanded(
                                                          child: Text(
                                                              'Customer',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start)),
                                                      Expanded(
                                                          child: Text('Status',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start)),
                                                      Expanded(
                                                          child: Text(
                                                              'Pengiriman Selesai',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start)),
                                                      Expanded(
                                                          child: Text('Sopir',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start)),
                                                    ],
                                                  ),
                                                  const Divider(),
                                                  const SizedBox(height: 8),
                                                  ...group.pengirimanList
                                                      .map((item) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Text(
                                                                  item.noDO,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start)),
                                                          Expanded(
                                                              child: Text(
                                                                  item.namaCust,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start)),
                                                          Expanded(
                                                              child: Text(
                                                                  viewModel
                                                                      .changeStatus(item
                                                                          .status),
                                                                  style: TextStyle(
                                                                      color: viewModel
                                                                          .changeStatusColor(item
                                                                              .status)),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start)),
                                                          Expanded(
                                                              child: Text(
                                                                  item
                                                                      .selesaiAt,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start)),
                                                          Expanded(
                                                              child: Text(
                                                                  item
                                                                      .kodeSopir,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start)),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ],
                                              )),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
