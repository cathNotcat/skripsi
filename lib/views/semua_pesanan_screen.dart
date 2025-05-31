import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_1/view_models/pengiriman_view_model.dart';
import 'package:web_admin_1/widget/date_formatter.dart';

class SemuaPesanan extends StatefulWidget {
  const SemuaPesanan({super.key});

  @override
  State<SemuaPesanan> createState() => _SemuaPesananState();
}

class _SemuaPesananState extends State<SemuaPesanan> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = PengirimanViewModel();
        viewModel.fetchAllPengirimanByTanggal();
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
                        const Text('Semua Pesanan',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: viewModel.groupedList.length > 7 ? 7 : 7,
                            itemBuilder: (context, index) {
                              final group = viewModel.groupedList[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
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
                                                    Icons.date_range_outlined,
                                                    color: Color.fromARGB(
                                                        200, 50, 50, 50)),
                                                const SizedBox(width: 16),
                                                Text(
                                                  DateFormatter.formatDate(
                                                      group.tanggal),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          200, 50, 50, 50)),
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
                                                            TextAlign.start)),
                                                Expanded(
                                                    child: Text('Customer',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.start)),
                                                Expanded(
                                                    child: Text('Status',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.start)),
                                                Expanded(
                                                    child: Text(
                                                        'Pengiriman Selesai',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.start)),
                                              ],
                                            ),
                                            const Divider(),
                                            const SizedBox(height: 8),
                                            ...group.pengirimanList.map((item) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(item.noDO,
                                                            textAlign: TextAlign
                                                                .start)),
                                                    Expanded(
                                                        child: Text(
                                                            item.namaCust,
                                                            textAlign: TextAlign
                                                                .start)),
                                                    Expanded(
                                                        child: Text(
                                                            viewModel
                                                                .changeStatus(
                                                                    item
                                                                        .status),
                                                            style: TextStyle(
                                                                color: viewModel
                                                                    .changeStatusColor(item
                                                                        .status)),
                                                            textAlign: TextAlign
                                                                .start)),
                                                    Expanded(
                                                        child: Text(
                                                            item.selesaiAt,
                                                            textAlign: TextAlign
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
