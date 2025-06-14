// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_admin_1/view_models/pengiriman_view_model.dart';
import 'package:web_admin_1/widget/header.dart';

class PengirimanScreen extends StatefulWidget {
  const PengirimanScreen({super.key});

  @override
  State<PengirimanScreen> createState() => _PengirimanScreenState();
}

class _PengirimanScreenState extends State<PengirimanScreen> {
  final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = PengirimanViewModel();
        viewModel.fetchPengirimanData(formattedDate);
        viewModel.fetchAllSopir();
        return viewModel;
      },
      child: Scaffold(
        body: Consumer<PengirimanViewModel>(
          builder: (context, viewModel, _) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: viewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Header(
                          pesanan: viewModel.pesanan,
                          belumDikirim: viewModel.belumDikirim,
                          sedangDikirim: viewModel.sedangDikirim,
                          selesai: viewModel.selesai,
                        ),
                        SizedBox(height: 48),
                        Text('Sopir',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Expanded(
                            child: ListView.builder(
                                itemCount: viewModel.namaSopir.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 100,
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                        SizedBox(width: 48),
                                        GestureDetector(
                                          onTap: () {
                                            SharedPreferences.getInstance()
                                                .then((prefs) {
                                              prefs.setString('selected_sopir',
                                                  viewModel.namaSopir[index]);
                                            });

                                            Navigator.of(context)
                                                .pushNamed('/sopirProses');
                                          },
                                          child: Text(
                                            viewModel.namaSopir[index],
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }))
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
