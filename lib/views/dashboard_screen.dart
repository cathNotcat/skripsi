import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_1/view_models/pengiriman_view_model.dart';
import 'package:web_admin_1/widget/button.dart';
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
        viewModel.fetchPesananSeminggu();
        viewModel.fetchAllPengirimanByTanggal();
        return viewModel;
      },
      child: Scaffold(
        body: Consumer<PengirimanViewModel>(
          builder: (context, viewModel, _) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text('Total Pesanan (seminggu)'),
                                    Text(
                                      viewModel.totalPesanan7Hari.toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text('Pesanan Belum Dikirim'),
                                    Text(
                                      viewModel.belumDikirim.toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Aksi Cepat',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 100,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tambah Pesanan',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Button('+', '/tambahPesanan')
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Notifikasi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: viewModel.groupedList.length,
                            itemBuilder: (context, index) {
                              final group = viewModel.groupedList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Date header
                                    Text(
                                      DateFormatter.formatDate(group.tanggal),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    ...group.pengirimanList.map((item) {
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Text(item.noDO,
                                                    textAlign:
                                                        TextAlign.center)),
                                            Expanded(
                                                child: Text(item.namaCust,
                                                    textAlign:
                                                        TextAlign.center)),
                                            Expanded(
                                                child: Text(item.status,
                                                    textAlign:
                                                        TextAlign.center)),
                                            Expanded(
                                                child: Text(item.selesaiAt,
                                                    textAlign:
                                                        TextAlign.center)),
                                          ],
                                        ),
                                      );
                                    }).toList(),
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
