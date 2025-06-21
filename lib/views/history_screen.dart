// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_1/view_model/history_view_model.dart';
import 'package:aplikasi_1/widget/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = HistoryViewModel();
        viewModel.fetchAllPengirimanByTanggal();
        return viewModel;
      },
      child: Scaffold(
        body: Consumer<HistoryViewModel>(
          builder: (context, viewModel, _) {
            return Container(
                padding: EdgeInsets.all(24),
                child: viewModel.isLoadingPesananByTanggal
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12),
                          Text('Semua Pesanan',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          viewModel.errorMessage != ''
                              ? Expanded(
                                  child: Center(
                                      child: Text(viewModel.errorMessage)))
                              : Expanded(
                                  child: ListView.builder(
                                      itemCount: viewModel.groupedList.length,
                                      itemBuilder: (context, index) {
                                        final group =
                                            viewModel.groupedList[index];
                                        print(
                                            'GroupedList: ${viewModel.groupedList}');
                                        return Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 8),
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.2),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2),
                                                      )
                                                    ]),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .date_range_outlined,
                                                            color:
                                                                Color.fromARGB(
                                                                    200,
                                                                    50,
                                                                    50,
                                                                    50)),
                                                        const SizedBox(
                                                            width: 16),
                                                        Text(
                                                          DateFormatter
                                                              .formatDate(group
                                                                  .tanggal),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          200,
                                                                          50,
                                                                          50,
                                                                          50)),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(),
                                                    SizedBox(height: 8),
                                                    ...group.pengirimanList.map(
                                                      (item) {
                                                        print(
                                                            'Item: ${item.noDO}');
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    item.noDO,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(item
                                                                      .namaCust),
                                                                ],
                                                              ),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                  color: viewModel
                                                                      .changeStatusColor(
                                                                          item.status),
                                                                ),
                                                                width: 25,
                                                                height: 25,
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }))
                        ],
                      ));
          },
        ),
      ),
    );
  }
}
