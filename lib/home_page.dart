// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_1/main.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var baseUrl = 'http://10.0.2.2/backend_api';

  DateTime now = DateTime.now();

  String nama = '';
  String hariIni = '';

  String notif = 'Tidak ada pesanan untuk hari ini';
  bool noNotif = true;
  bool isLoadingSupir = true;

  int pesanan = 0;
  int selesai = 0;

  Color buttonColor = Color.fromARGB(255, 23, 96, 232);
  Color containerColor = Color.fromARGB(255, 255, 255, 255);
  Color textColor = Color.fromARGB(255, 82, 89, 105);

  List<String> noDO = [];

  @override
  void initState() {
    super.initState();
    _formatDate();
    _getSopir();
    _getPengirimanSupirData();
  }

  void _formatDate() {
    initializeDateFormatting('id_ID', null).then((_) {
      Intl.defaultLocale = 'id_ID';

      DateTime today = DateTime.now();
      String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(today);
      setState(() {
        hariIni = formattedDate;
      });
      print(formattedDate);
    });
  }

  Future<void> _getPengirimanSupirData() async {
    pesanan = 0;
    selesai = 0;
    noDO.clear();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    var url = Uri.parse('$baseUrl/pengiriman/tanggal/$formattedDate');

    try {
      var response =
          await http.get(url, headers: {'Content-Type': 'application/json'});
      print('status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        print('response message: ${responseBody['message']}');
        var data = responseBody['data'];
        if (data != null) {
          setState(() {
            for (var item in data) {
              String status = item["Status"];
              if (status == "0") {
                pesanan++;
              }
              if (status == "1") {
                pesanan++;
              }
              if (status == "2") {
                selesai++;
                noDO.add(item['NoDO']);
              }
            }
            if (responseBody['message'] != 'No data found') {
              notif = 'Anda memiliki $pesanan pesanan';
              noNotif = false;
            }
          });
        } else {
          print('Unexpected response structure.');
        }
      } else {
        print(
            'Failed to load user data(getpengiriman on home): ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> _getSopir() async {
    var url = Uri.parse('$baseUrl/sopir/adi');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var data = responseBody['data'];
        if (data != null) {
          setState(() {
            nama = data['kodesopir'];
            isLoadingSupir = false;
          });
        } else {
          print('Unexpected response structure.');
        }
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> _refreshData() async {
    _getSopir();
    _getPengirimanSupirData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoadingSupir
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.only(top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang,',
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          nama,
                          style: TextStyle(
                              fontSize: 42, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: _refreshData,
                          child: Icon(Icons.refresh),
                        ),
                      ]),
                  Container(
                    height: 130,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month_outlined),
                            SizedBox(width: 16),
                            Text(
                              hariIni,
                              style: TextStyle(color: textColor),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.drive_eta_outlined),
                            SizedBox(width: 16),
                            Text(
                              'L 1622 JK',
                              style: TextStyle(color: textColor),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.history_rounded),
                            SizedBox(width: 16),
                            Text(
                              '$selesai pesanan selesai',
                              style: TextStyle(color: textColor),
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
                      color: containerColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notifications_outlined),
                            SizedBox(width: 16),
                            Text(
                              notif,
                              style: TextStyle(color: textColor),
                            ),
                          ],
                        ),
                        noNotif
                            ? SizedBox()
                            : FilledButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Navbar(
                                        chosenIndex: 1,
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(buttonColor),
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                                ),
                                child: Text('Lihat Detail'),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  noDO.isEmpty
                      ? SizedBox()
                      : Text(
                          'Pesanan Selesai Hari Ini',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                        itemCount: noDO.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: containerColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.assignment_outlined),
                                SizedBox(width: 16),
                                Text(
                                  // 'SON/00056/0724/MM',
                                  noDO[index],
                                  style: TextStyle(color: textColor),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
    );
  }
}

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  Color buttonColor = Color.fromARGB(255, 23, 96, 232);
  Color containerColor = Color.fromARGB(255, 255, 255, 255);
  Color textColor = Color.fromARGB(255, 82, 89, 105);
  Color backgroundColor = Color.fromARGB(255, 245, 245, 245);

  var baseUrl = 'http://10.0.2.2/backend_api';
  DateTime now = DateTime.now();

  final LatLng _initialPosition = LatLng(37.42796133580664, -122.085749655962);

  void _onMapCreated(GoogleMapController controller) {}

  String detNoDO = '';
  String detAlamat = '';
  String detCust = '';
  String detJumlahBrg = '';
  String detStatus = '';
  String detNoPeng = '';

  List<String> detKodeBrg = [];
  List<String> detQty = [];

  int pilihan_widget = 0;
  int index_selected = 0;

  bool isDataAvailable = false;
  bool isPesananSelesai = false;

  List<Map<String, dynamic>> details = [];
  List<Map<String, dynamic>> detDetails = [];

  int pesanan = 0;

  @override
  void initState() {
    super.initState();
    _getPengirimanSupirData();
  }

  Future<void> _getPengirimanSupirData() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    var url = Uri.parse('$baseUrl/pengiriman/tanggal/$formattedDate');

    try {
      var response =
          await http.get(url, headers: {'Content-Type': 'application/json'});
      print('status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var data = responseBody['data'];
        if (data != null) {
          setState(() {
            details = List<Map<String, dynamic>>.from(
                data.map((item) => item as Map<String, dynamic>));
            for (var det in details) {
              if (det['Status'] == "2") {
                isPesananSelesai = true;
              }
            }
            pesanan = data.length;

            if (responseBody['message'] != 'No data found') {
              isDataAvailable = true;
            }
          });
          print(details[0]['NoDO']);
        } else {
          print('Unexpected response structure.');
        }
      } else {
        print(
            'Failed to load user data(getpengiriman on pesanan page): ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> _confirmModal(BuildContext context, String noPeng) {
    print('ispesanan selesai: $isPesananSelesai');
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: containerColor,
          title: Center(
            child: const Text(
              'Apakah anda yakin ingin menyelesaikan pesanan?',
              textAlign: TextAlign.center,
            ),
          ),
          contentPadding: EdgeInsets.all(20),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 20),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    backgroundColor: buttonColor,
                  ),
                  child: const Text(
                    'Selesai',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _changeStatus(noPeng, 2);
                    setState(() {
                      _getPengirimanSupirData();
                      detStatus = '2';
                    });
                    print('ispesanan selesai: $isPesananSelesai');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String getStatusString(String status) {
    switch (status) {
      case '0':
        return "Belum Dikirim";
      case '1':
        return "Sedang Dikirim";
      case '2':
        return "Selesai";
      default:
        return "Unknown Status";
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case '0':
        return Color.fromARGB(255, 239, 181, 176);
      case '1':
        return Color.fromARGB(255, 251, 228, 199);
      case '2':
        return Color.fromARGB(255, 183, 240, 213);
      default:
        return Color.fromARGB(255, 217, 217, 217);
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case '0':
        return Color.fromARGB(255, 215, 37, 24);
      case '1':
        return Color.fromARGB(255, 189, 111, 9);
      case '2':
        return Color.fromARGB(255, 13, 130, 75);
      default:
        return Color.fromARGB(255, 217, 217, 217);
    }
  }

  Future<void> _changeStatus(String noPeng, int statusChange) async {
    print('no bukti: $noPeng');
    print('status change: $statusChange');

    var url = Uri.parse('$baseUrl/pengiriman/update/$noPeng');

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'Status': statusChange,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _getPengirimanSupirData();
        });
        print('Status updated successfully');
      } else if (response.statusCode == 404) {
        print('No data found with the provided NoPengiriman');
      } else {
        print('Failed to update status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> _getDbsppDetData(String nobukti) async {
    var url = Uri.parse('$baseUrl/dbsppdet/nobukti');

    try {
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'NOBUKTI': nobukti,
          }));
      print('status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var data = responseBody['data'];
        if (data != null) {
          setState(() {
            detDetails = List<Map<String, dynamic>>.from(
                data.map((item) => item as Map<String, dynamic>));
          });
          print(detDetails[0]['KodeBrg']);
        } else {
          print('Unexpected response structure.');
        }
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 150,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 14,
          ),
          markers: {
            Marker(
              markerId: MarkerId('marker_1'),
              position: _initialPosition,
              infoWindow: InfoWindow(title: 'My Marker'),
            ),
          },
        ),
        panel: Container(
          color: backgroundColor,
          child: Column(
            children: [
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(vertical: 10),
              ),
              SizedBox(height: 10),
              isDataAvailable == true
                  ? pilihan_widget == 0
                      ? _listPesananPage()
                      : _detailPesananPage()
                  : Center(
                      child: Text('Tidak ada pesanan'),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _listPesananPage() {
    return Expanded(
      child: ListView(
        children: details
            .asMap()
            .map((index, item) {
              return MapEntry(
                  index,
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: containerColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['NoDO']!, // Access NoDO from the item
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 8, bottom: 8, left: 12, right: 12),
                              decoration: BoxDecoration(
                                  color: getStatusColor(item['Status']),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Text(
                                getStatusString(item['Status']),
                                style: TextStyle(
                                    color: getStatusTextColor(item['Status']),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              item['Alamat']!, // Access Alamat from the item
                              style: TextStyle(color: textColor, fontSize: 14),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 20),
                            SizedBox(width: 8),
                            Text(
                              item['Nama']!,
                              style: TextStyle(color: textColor, fontSize: 14),
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.inbox_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '${item['JumlahBarang']} jenis barang',
                              style: TextStyle(color: textColor, fontSize: 14),
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 24),
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 23, 96, 232),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              onPressed: () {
                                print('no pengiriman: ${item['NoPengiriman']}');
                                setState(() {
                                  pilihan_widget = 1;
                                  index_selected = index;
                                  if (item['Status'] != "2") {
                                    _changeStatus(item['NoPengiriman'], 1);
                                    detStatus = '1';
                                  }
                                  detNoDO = item['NoDO'];
                                  detAlamat = item['Alamat'];
                                  detCust = item['Nama'];
                                  detJumlahBrg = item['JumlahBarang'];
                                  detNoPeng = item['NoPengiriman'];
                                  _getPengirimanSupirData();
                                  _getDbsppDetData(item['NoDO']);
                                });
                                print('det no do: $detNoDO');
                              },
                              child: Text(
                                'Lihat Detail',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            })
            .values
            .toList(),
      ),
    );
  }

  Widget _detailPesananPage() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                pilihan_widget = 0;
              });
            },
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  color: Color.fromARGB(255, 152, 162, 179),
                ),
                SizedBox(width: 16),
                Text(
                  'Back',
                  style: TextStyle(color: Color.fromARGB(255, 152, 162, 179)),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // 'SON/00054/0724/MM',
                detNoDO,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                decoration: BoxDecoration(
                    color: getStatusColor(detStatus),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Text(
                  getStatusString(detStatus),
                  style: TextStyle(
                      color: getStatusTextColor(detStatus),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                // 'Jl. Pasar Turi no. 19-21',
                detAlamat,
                style: TextStyle(color: textColor, fontSize: 14),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                // 'Sastroijo Pungli',
                detCust,
                style: TextStyle(color: textColor, fontSize: 14),
              )
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                // '3 jenis barang',
                '$detJumlahBrg jenis barang',
                style: TextStyle(color: textColor, fontSize: 14),
              )
            ],
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Barang',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kode Barang',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Jumlah',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // SizedBox(height: 16),
                Container(
                  height: (50 * detDetails.length).toDouble(),
                  // height: 100,
                  child: ListView.builder(
                      itemCount: detDetails.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(bottom: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                // detKodeBrg[index],
                                detDetails[index]['KodeBrg'],
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                // '${detQty[index]}',
                                detDetails[index]['Quantity'],
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 24),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: detStatus == "2"
                      ? Color.fromARGB(255, 217, 217, 217)
                      : Color.fromARGB(255, 13, 130, 75),
                  // backgroundColor: const Color.fromARGB(255, 13, 130, 75),
                  foregroundColor: detStatus == "2"
                      ? Color.fromARGB(255, 82, 89, 105)
                      : Colors.white,
                  // foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  print('detnopeng: $detNoPeng');
                  if (detStatus != '2') {
                    _confirmModal(context, detNoPeng);
                    getStatusColor(detStatus);
                    getStatusString(detStatus);
                    getStatusTextColor(detStatus);
                  }
                },
                child: Text(
                  detStatus == '2' ? 'Pesanan Selesai' : 'Selesaikan Pesanan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelesaiPage extends StatefulWidget {
  const SelesaiPage({super.key});

  @override
  State<SelesaiPage> createState() => _SelesaiPageState();
}

class _SelesaiPageState extends State<SelesaiPage> {
  var baseUrl = 'http://10.0.2.2/backend_api';

  List<Map<String, dynamic>> filteredOrdersData = [];

  Color buttonColor = Color.fromARGB(255, 23, 96, 232);
  Color containerColor = Color.fromARGB(255, 255, 255, 255);
  Color textColor = Color.fromARGB(255, 82, 89, 105);

  @override
  void initState() {
    super.initState();
    _getHistory();
    filteredOrdersData = ordersData;
  }

  Map<String, bool> selectedMonths = {
    "January": false,
    "February": false,
    "March": false,
    "April": false,
    "May": false,
    "June": false,
    "July": false,
    "August": false,
    "September": false,
    "October": false,
    "November": false,
    "December": false,
  };

  Map<String, bool> selectedYears = {
    "2023": false,
    "2024": false,
  };

  List<Map<String, dynamic>> ordersData = [];
  void applyFilters() {
    setState(() {
      filteredOrdersData = ordersData.where((order) {
        DateTime date = DateTime.parse(order["TANGGAL"]);
        String month = DateFormat('MMMM').format(date); // Month in full text
        String year = date.year.toString();

        // Match the selected months and years
        return (selectedMonths[month] ?? false) ||
            (selectedYears[year] ?? false);
      }).toList();
    });
  }

  Future<void> _getHistory() async {
    var url = Uri.parse('$baseUrl/dbso/tanggal');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var data = responseBody['data'];
        if (data != null) {
          for (var orders in data) {
            setState(() {
              ordersData.add(orders);
            });
          }
          // print(ordersData);
        } else {
          print('Unexpected response structure.');
        }
      } else {
        print('Failed to load user data(gethistory): ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan Selesai',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Container(
            //   padding: EdgeInsets.all(16),
            //   color: Colors.grey[200],
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // Filter by Month
            //       Text(
            //         "Filter by Month",
            //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //       ),
            //       Wrap(
            //         spacing: 8.0,
            //         children: selectedMonths.keys.map((month) {
            //           return FilterChip(
            //             label: Text(month),
            //             selected: selectedMonths[month] ?? false,
            //             onSelected: (selected) {
            //               setState(() {
            //                 selectedMonths[month] = selected;
            //               });
            //               applyFilters();
            //             },
            //           );
            //         }).toList(),
            //       ),
            //       SizedBox(height: 16),
            //       // Filter by Year
            //       Text(
            //         "Filter by Year",
            //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //       ),
            //       Wrap(
            //         spacing: 8.0,
            //         children: selectedYears.keys.map((year) {
            //           return FilterChip(
            //             label: Text(year),
            //             selected: selectedYears[year] ?? false,
            //             onSelected: (selected) {
            //               setState(() {
            //                 selectedYears[year] = selected;
            //               });
            //               applyFilters();
            //             },
            //           );
            //         }).toList(),
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                interactive: true,
                thickness: 8.0,
                radius: Radius.circular(8.0),
                child: ListView.builder(
                  itemCount: ordersData.length,
                  itemBuilder: (context, index) {
                    var dateData = ordersData[index];
                    String rawDate = dateData["TANGGAL"];
                    List<String> orders =
                        List<String>.from(dateData["NOBUKTI"]);
                    DateTime dateTime = DateTime.parse(rawDate);
                    String formattedDate =
                        DateFormat('d MMMM yyyy').format(dateTime);
                    return Container(
                      margin: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              formattedDate,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: orders.length,
                            itemBuilder: (context, orderIndex) {
                              return Container(
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: containerColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.assignment_outlined),
                                        SizedBox(width: 16),
                                        Text(
                                          orders[orderIndex],
                                          style: TextStyle(color: textColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
