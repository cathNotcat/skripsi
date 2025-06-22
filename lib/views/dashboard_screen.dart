import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_1/main.dart';
import 'package:web_admin_1/view_models/pengiriman_view_model.dart';
import 'package:web_admin_1/widget/button.dart';
import 'package:web_admin_1/widget/charts.dart';
import 'package:web_admin_1/widget/date_formatter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = PengirimanViewModel();
        viewModel.fetchPengirimanData(DateFormatter.formatToday());
        viewModel.fetchBarang();
        viewModel.fetchAllPengirimanByTanggal();
        viewModel.setFilterStatus(0);
        viewModel.loadMonthlyData();
        return viewModel;
      },
      child: Scaffold(
        body: Consumer<PengirimanViewModel>(
          builder: (context, viewModel, _) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          const Text('Dashboard',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          // const SizedBox(height: 12),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _dashboardCard('Total Pesanan', 'semua',
                                  '${viewModel.allPengiriman}'),
                              const SizedBox(width: 32),
                              _dashboardCard(
                                  'Total Barang Dikirim',
                                  'seminggu terakhir',
                                  viewModel.totalBarang.toString()),
                              const SizedBox(width: 32),
                              _dashboardCard(
                                  'Pesanan Belum Dikirim',
                                  'hari ini',
                                  viewModel.belumDikirim.toString()),
                            ],
                          ),
                          const SizedBox(height: 24),
                          viewModel.isLoadingPesanan
                              ? const Center(child: CircularProgressIndicator())
                              : Container(
                                  height: 380,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: viewModel.items.isEmpty
                                      ? const Center(
                                          child: Text('No data available'))
                                      : Column(
                                          children: [
                                            const Text('Target Penjualan',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    height: 300,
                                                    child: DashboardBarChart(
                                                      data: viewModel.items,
                                                      maxY: viewModel.maxY,
                                                      barWidth: 30,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 100),
                                                const Column(
                                                  children: [
                                                    Text('Jumlah Sales Order',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                                    Text('tahun lalu',
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    Text('980',
                                                        style: TextStyle(
                                                            fontSize: 40,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text('sales order',
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                                const SizedBox(width: 100),
                                                const Column(
                                                  children: [
                                                    Text('Target Kenaikan',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                                    Text('tahun ini',
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    Text('20%',
                                                        style: TextStyle(
                                                            fontSize: 40,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text('dari tahun lalu',
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                                const SizedBox(width: 100),
                                                const Column(
                                                  children: [
                                                    Text('Target Jumlah',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                                    Text('tahun ini',
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    Text('1.176',
                                                        style: TextStyle(
                                                            fontSize: 40,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text('sales order',
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                                const SizedBox(width: 80),
                                              ],
                                            ),
                                          ],
                                        ),
                                ),

                          const SizedBox(height: 24),
                          Container(
                            height: 100,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.trending_up_outlined),
                                    SizedBox(width: 16),
                                    Text(
                                      'Aksi Cepat',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Button('Buat Pengiriman', '/pengirimanPage')
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'Pesanan Belum Dikirim',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          viewModel.filterStatus == 0
                              ? viewModel.filteredGroupedList.isEmpty
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
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                          child: Text('Tidak ada pesanan')),
                                    )
                                  : Column(children: [
                                      ...viewModel.filteredGroupedList
                                          .take(3)
                                          .map((group) {
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
                                                  padding:
                                                      const EdgeInsets.all(24),
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
                                                        offset:
                                                            const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                              Icons
                                                                  .date_range_outlined,
                                                              color: Color
                                                                  .fromARGB(
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
                                                            style: const TextStyle(
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
                                                      const SizedBox(
                                                          height: 24),
                                                      const Row(
                                                        children: [
                                                          Expanded(
                                                              child: Text(
                                                                  'No. DO',
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
                                                              child: Text(
                                                                  'Status',
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
                                                              child: Text(
                                                                  'Sopir',
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
                                                              const EdgeInsets
                                                                  .all(8.0),
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
                                                                      item
                                                                          .namaCust,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start)),
                                                              Expanded(
                                                                  child: Text(
                                                                      viewModel
                                                                          .changeStatus(item
                                                                              .status),
                                                                      style: TextStyle(
                                                                          color: viewModel.changeStatusColor(item
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
                                      }),
                                      if (viewModel.filteredGroupedList.length >
                                          3)
                                        Align(
                                          alignment: Alignment.center,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                  '/belumDikirimPage');
                                            },
                                            child: const Text(
                                              'Lihat Semua',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 91, 146, 248),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ])
                              : const SizedBox(),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'Pesanan Terakhir',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
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
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                      child: Text('Tidak ada pesanan')),
                                )
                              : Column(
                                  children: [
                                    ...viewModel.groupedList
                                        .take(3)
                                        .map((group) {
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
                                                padding:
                                                    const EdgeInsets.all(24),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 2),
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
                                                    const SizedBox(height: 24),
                                                    const Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                                'No. DO',
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
                                                            child: Text(
                                                                'Status',
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
                                                            const EdgeInsets
                                                                .all(8.0),
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
                                                                    item
                                                                        .namaCust,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start)),
                                                            Expanded(
                                                                child: Text(
                                                                    viewModel
                                                                        .changeStatus(item
                                                                            .status),
                                                                    style: TextStyle(
                                                                        color: viewModel.changeStatusColor(item
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
                                    }),
                                    if (viewModel.groupedList.length > 3)
                                      Align(
                                        alignment: Alignment.center,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed('/semuaPesanan');
                                          },
                                          child: const Text(
                                            'Lihat Semua',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 91, 146, 248),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _dashboardCard(String title, String desc, String value) {
    return Expanded(
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text(desc, style: const TextStyle(fontSize: 12)),
            Text(value,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
