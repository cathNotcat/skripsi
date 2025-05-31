// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_1/main.dart';
import 'package:aplikasi_1/view_model/home_view_model.dart';
import 'package:aplikasi_1/widget/colors_widget.dart';
import 'package:aplikasi_1/widget/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = HomeViewModel();
        return viewModel;
      },
      child: Scaffold(
        body: Consumer<HomeViewModel>(builder: (context, viewModel, _) {
          return Container(
            padding: EdgeInsets.all(24),
            margin: EdgeInsets.only(top: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat Datang,'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ADI',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: viewModel.refreshData,
                      child: Icon(Icons.refresh),
                    ),
                  ],
                ),
                Container(
                  height: 130,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorsWidget.containerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_month_outlined),
                          SizedBox(width: 16),
                          Text(DateFormatter.formatDateToday(),
                              style: TextStyle(color: ColorsWidget.textColor)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.drive_eta_outlined),
                          SizedBox(width: 16),
                          Text(
                            'L 1622 JK',
                            style: TextStyle(color: ColorsWidget.textColor),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.history_rounded),
                          SizedBox(width: 16),
                          Text(
                            '${viewModel.selesai} pesanan selesai',
                            style: TextStyle(color: ColorsWidget.textColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Notifikasi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorsWidget.containerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notifications_outlined),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.notif,
                                style: TextStyle(color: ColorsWidget.textColor),
                              ),
                              viewModel.noNotif
                                  ? SizedBox()
                                  : FilledButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Navbar(chosenIndex: 1),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                          ColorsWidget.buttonColor,
                                        ),
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: FittedBox(
                                        // 🔹 Ensures text scales correctly
                                        fit: BoxFit.scaleDown,
                                        child: Text('Lihat Detail'),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                viewModel.noDO.isEmpty
                    ? SizedBox()
                    : Text(
                        'Pesanan Selesai Hari Ini',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.noDO.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ColorsWidget.containerColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.assignment_outlined),
                            SizedBox(width: 16),
                            Text(
                              // 'SON/00056/0724/MM',
                              viewModel.noDO[index],
                              style: TextStyle(color: ColorsWidget.textColor),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
