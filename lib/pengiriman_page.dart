// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:web_admin_1/held_karp.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PengirimanPage extends StatefulWidget {
  const PengirimanPage({super.key});

  @override
  State<PengirimanPage> createState() => _PengirimanPageState();
}

class _PengirimanPageState extends State<PengirimanPage> {
  var baseUrl = dotenv.env['BASE_URL'] ?? '';

  DateTime now = DateTime.now();

  int pesanan = 0;
  int belumDikirim = 0;
  int sedangDikirim = 0;
  int selesai = 0;

  List<Map<String, dynamic>> details = [];

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
            for (var item in data) {
              pesanan++;
              String status = item["Status"];
              if (status == "0") {
                belumDikirim++;
              } else if (status == "1") {
                sedangDikirim++;
              } else if (status == "2") {
                selesai++;
              }
            }
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

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            Text(
              'Hari Ini ($formattedDate)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Pesanan
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.all(16),
                      height: 100,
                      width: 140,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 217, 217, 217),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Pesanan'),
                          Text(
                            '$pesanan',
                            style: TextStyle(fontSize: 24),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Belum Dikirim
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.all(16),
                      height: 100,
                      width: 140,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 239, 181, 176),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Belum Dikirim'),
                          Text(
                            '$belumDikirim',
                            style: TextStyle(fontSize: 24),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Sedang Dikirim
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.all(16),
                      height: 100,
                      width: 140,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 251, 228, 199),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sedang Dikirim'),
                          Text(
                            '$sedangDikirim',
                            style: TextStyle(fontSize: 24),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Selesai
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      padding: EdgeInsets.all(16),
                      height: 100,
                      width: 140,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 183, 240, 213),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Selesai'),
                          Text(
                            '$selesai',
                            style: TextStyle(fontSize: 24),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 48),
            Text(
              'Supir',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 100,
              padding: EdgeInsets.all(16),
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
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  SizedBox(width: 48),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/supirProses');
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => SupirProsesPage(),
                      //   ),
                      // );
                    },
                    child: Text(
                      'ADI',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupirProsesPage extends StatefulWidget {
  const SupirProsesPage({super.key});

  @override
  State<SupirProsesPage> createState() => _SupirProsesPageState();
}

class _SupirProsesPageState extends State<SupirProsesPage> {
  var baseUrl = dotenv.env['BASE_URL'] ?? '';

  DateTime now = DateTime.now();
  bool adaPengiriman = false;
  bool isLoading = true;

  int pesanan = 0;
  int belumDikirim = 0;
  int sedangDikirim = 0;
  int selesai = 0;

  String status = '';

  List<Map<String, dynamic>> details = [];

  @override
  void initState() {
    super.initState();
    _getPengirimanSupirData();
  }

  Future<void> _getPengirimanSupirData() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    print('formattedDate: $formattedDate');
    var url = Uri.parse('$baseUrl/pengiriman/tanggal/$formattedDate');

    try {
      var response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });

        var responseBody = jsonDecode(response.body);
        var data = responseBody['data'];

        if (data.isNotEmpty) {
          setState(() {
            details = List<Map<String, dynamic>>.from(
                data.map((item) => item as Map<String, dynamic>));
            adaPengiriman = true;
          });
          print('adapengiriman: $adaPengiriman');
          for (var item in data) {
            pesanan++;
            String status = item["Status"];
            if (status == "0") {
              belumDikirim++;
            } else if (status == "1") {
              sedangDikirim++;
            } else if (status == "2") {
              selesai++;
            }
          }
        } else {
          print('_getPengirimanSupirData() data is empty.');
        }
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String hariIni =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            Text(
              'Hari Ini ($hariIni)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Pesanan
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.all(16),
                      height: 100,
                      width: 140,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 217, 217, 217),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Pesanan'),
                          Text(
                            '$pesanan',
                            style: TextStyle(fontSize: 24),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Belum Dikirim
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.all(16),
                      height: 100,
                      width: 140,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 239, 181, 176),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Belum Dikirim'),
                          Text(
                            '$belumDikirim',
                            style: TextStyle(fontSize: 24),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Sedang Dikirim
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16),
                      padding: EdgeInsets.all(16),
                      height: 100,
                      width: 140,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 251, 228, 199),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sedang Dikirim'),
                          Text(
                            '$sedangDikirim',
                            style: TextStyle(fontSize: 24),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Selesai
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      padding: EdgeInsets.all(16),
                      height: 100,
                      width: 140,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 183, 240, 213),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Selesai'),
                          Text(
                            '$selesai',
                            style: TextStyle(fontSize: 24),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Proses',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/tambahPesanan');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 23, 96, 232),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '+ Tambah Pesanan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : adaPengiriman == false
                    ? Container(
                        height: 100,
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Tidak ada pengiriman',
                            style: TextStyle(
                                color: Color.fromARGB(255, 82, 89, 105)),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
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
                                    0: FlexColumnWidth(
                                        1), // Adjust these to control the column width ratio
                                    1: FlexColumnWidth(1),
                                    2: FlexColumnWidth(1),
                                    3: FlexColumnWidth(1),
                                  },
                                  border:
                                      TableBorder.all(color: Colors.grey[300]!),
                                  children: [
                                    // Header row
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200]),
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'No. Bukti',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Kode Customer',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Alamat',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Status',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                      ],
                                    ),
                                    // Data rows
                                    ...details.map(
                                      (item) => TableRow(
                                        children: [
                                          Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  // child: Text(item['Kode Barang']!))),
                                                  child: Text(item['NoDO']!))),
                                          Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  // child: Text(item['Nama Barang']!))),
                                                  child: Text(
                                                      item['KodeCustSupp']!))),
                                          Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  // child: Text(item['Qnt']!))),
                                                  child:
                                                      Text(item['Alamat']!))),
                                          Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: 8,
                                                      bottom: 8,
                                                      left: 12,
                                                      right: 12),
                                                  decoration: BoxDecoration(
                                                      color: getStatusColor(
                                                          item['Status']),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Text(
                                                    getStatusString(
                                                        item['Status']),
                                                    style: TextStyle(
                                                        // color: getStatusTextColor(
                                                        //     item['Status']),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))
          ],
        ),
      ),
    );
  }
}

class CustomSnackBar extends StatelessWidget {
  final String message;

  const CustomSnackBar({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class TambahPesananPage extends StatefulWidget {
  const TambahPesananPage({super.key});

  @override
  State<TambahPesananPage> createState() => _TambahPesananPageState();
}

class _TambahPesananPageState extends State<TambahPesananPage> {
  var baseUrl = dotenv.env['BASE_URL'] ?? '';
  bool isLihatDetail = false;
  bool isLoading = true;
  bool isPesananExist = false;
  bool isCalculating = false;

  List<String> points = ['-7.375729652261953, 112.6788318829139'];
  Map<String, String> custCoordinateMap = {};
  String namaCust = '';
  String message = '';

  DateTime now = DateTime.now();

  final TextEditingController inputDoController = TextEditingController();
  final TextEditingController noUrutController = TextEditingController();
  final TextEditingController tanggalKirimController = TextEditingController();
  final TextEditingController noPesanController = TextEditingController();
  final TextEditingController noSoController = TextEditingController();
  final TextEditingController customerController = TextEditingController();

  List<Map<String, dynamic>> details = [];
  List<Map<String, dynamic>> listOfPesanan = [];

  @override
  void initState() {
    super.initState();
    _getPengirimanSupirData();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    tanggalKirimController.text = formattedDate;
  }

  Future<void> _getDbsppDetData() async {
    var url = Uri.parse('$baseUrl/dbsppdet/nobukti');
    String nobukti = inputDoController.text;

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
            details = List<Map<String, dynamic>>.from(
                data.map((item) => item as Map<String, dynamic>));
            isLoading = false;
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

  Future<void> _getDbsppData() async {
    var url = Uri.parse('$baseUrl/dbspp/nobukti');
    String nobukti = inputDoController.text;
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

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
        print('data: $data');
        if (data != null) {
          setState(() {
            noUrutController.text = data['NoUrut'];
            tanggalKirimController.text = formattedDate;
            noSoController.text = data['NoSO'];
            noPesanController.text = data['NoPesan'];
            customerController.text = data['KodeCustSupp'];
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

  Future<void> _getCustDetails(String kodeCust) async {
    var url = Uri.parse('$baseUrl/customer/alamat/$kodeCust');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var data = responseBody['data'];
        print('data: $data');

        if (data != null) {
          String nama = data['NAMA'].toString();
          String coordinate = data['KOORDINAT'].toString();

          setState(() {
            namaCust = nama;
            points.add(coordinate.toString());
            custCoordinateMap[kodeCust] = coordinate;
          });
          print('namaCust in _getCustDetail: $namaCust');
        }
      }
    } catch (e) {
      print('Error _getCoordinate(): $e');
    }
  }

  Future<void> _tambahPesanan() async {
    print('tambah pesanan clicked');
    setState(() {
      isPesananExist = true;
    });

    String nobukti = inputDoController.text;
    String kodeCust = customerController.text;
    String tanggalKirim = tanggalKirimController.text;

    await _getCustDetails(kodeCust);

    bool isNoDOExist = listOfPesanan.any((item) => item['NoDO'] == nobukti);

    if (isNoDOExist) {
      _showTopSnackBar(context, "No. DO sudah ada!", Colors.red);
      return;
    }

    listOfPesanan.add({
      'NoDO': nobukti,
      'KodeSopir': 'ADI',
      'KodeCustSupp': kodeCust,
      'TanggalKirim': tanggalKirim,
      'Nama': namaCust,
      'Status': 0,
    });
    print('after listOfPesanan added');
  }

  void _showTopSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50, // You can adjust the top value to move it higher or lower
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    // Remove the SnackBar after a delay
    Future.delayed(Duration(seconds: 3), () {
      entry.remove();
    });
  }

  Future<void> _getPengirimanSupirData() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    print('formattedDate: $formattedDate');
    var url = Uri.parse('$baseUrl/pengiriman/tanggal/$formattedDate');

    try {
      var response =
          await http.get(url, headers: {'Content-Type': 'application/json'});
      print('status: ${response.statusCode}');

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        var responseBody = jsonDecode(response.body);
        var data = responseBody['data'];

        if (data.isNotEmpty) {
          setState(() {
            listOfPesanan = List<Map<String, dynamic>>.from(
                data.map((item) => item as Map<String, dynamic>));

            isPesananExist = true;
          });
          print('adapengiriman: $isPesananExist');
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

  Future<void> _uploadPesanan(List<Map<String, dynamic>> sortedPesanan) async {
    var url = Uri.parse('$baseUrl/upload/pengiriman');

    for (var pesanan in sortedPesanan) {
      try {
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'NoDO': pesanan['NoDO'],
            'KodeSopir': pesanan['KodeSopir'],
            'KodeCustSupp': pesanan['KodeCustSupp'],
            'TanggalKirim': pesanan['TanggalKirim'],
            'Status': pesanan['Status'],
          }),
        );

        print('Status: ${response.statusCode} for NoDO: ${pesanan['NoDO']}');

        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          print('Success: ${responseBody['data']}');
        } else {
          print('Failed to upload NoDO ${pesanan['NoDO']}: ${response.body}');
        }
      } catch (e) {
        print('Error uploading NoDO ${pesanan['NoDO']}: $e');
      }
    }
  }

  Future<void> _selesai() async {
    if (points.isEmpty) {
      print("No coordinates available for calculation.");
      return;
    }

    setState(() {
      isCalculating = true;
    });
    List<String> sortedKodeCustSupp = await _calculateHeldKarp();

    List<Map<String, dynamic>> sortedPesanan = [];
    for (String kodeCust in sortedKodeCustSupp) {
      var pesanan = listOfPesanan.firstWhere(
        (item) => item['KodeCustSupp'] == kodeCust,
        orElse: () => {},
      );

      if (pesanan.isNotEmpty) {
        sortedPesanan.add(pesanan);
      }
    }

    await _uploadPesanan(sortedPesanan);

    setState(() {
      isCalculating = false;
    });
  }

  List<LatLng> convertToLatLngList(List<String> coordinateStrings) {
    List<LatLng> latLngList = [];

    for (var coord in coordinateStrings) {
      List<String> parts = coord.split(',');

      if (parts.length == 2) {
        double latitude = double.parse(parts[0].trim());
        double longitude = double.parse(parts[1].trim());

        latLngList.add(LatLng(latitude, longitude));
      } else {
        print("Invalid coordinate format: $coord");
      }
    }

    return latLngList;
  }

  Future<List<String>> _calculateHeldKarp() async {
    List<LatLng> pointsConverted = convertToLatLngList(points);

    HeldKarp heldKarp = HeldKarp();
    List<LatLng> pointsWithHeldKarp =
        await heldKarp.calculateWithHeldKarp(pointsConverted);

    print('before heldkarp: $points');
    print('after heldkarp: $pointsWithHeldKarp');

    List<String> sortedKodeCustSupp = [];

    for (LatLng coord in pointsWithHeldKarp) {
      String coordString =
          "${coord.latitude.toStringAsFixed(15)}, ${coord.longitude.toStringAsFixed(15)}";
      print("Checking for: $coordString");

      for (var entry in custCoordinateMap.entries) {
        print("Stored: ${entry.value} -> ${entry.key}");
      }

      String? kodeCust;
      double epsilon = 0.000001; // Adjust tolerance as needed

      for (var entry in custCoordinateMap.entries) {
        List<String> storedCoords = entry.value.split(',');
        double storedLat = double.parse(storedCoords[0]);
        double storedLng = double.parse(storedCoords[1]);

        if ((storedLat - coord.latitude).abs() < epsilon &&
            (storedLng - coord.longitude).abs() < epsilon) {
          kodeCust = entry.key;
          break; // Stop once we find a match
        }
      }

      if (kodeCust != null) {
        sortedKodeCustSupp.add(kodeCust);
      }
    }

    print("Sorted KodeCustSupp after Held-Karp: $sortedKodeCustSupp");

    return sortedKodeCustSupp;
  }

  Future<void> _hapusPesanan(String noDO, String tanggalKirim) async {
    print('clicked delete and inside function');
    print('nodo: $noDO');
    print('tanggal: $tanggalKirim');
    var url = Uri.parse('$baseUrl/pengiriman/delete');

    try {
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'NoDO': noDO,
            'TanggalKirim': tanggalKirim,
          }));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        setState(() {
          listOfPesanan.removeWhere((item) => item['NoDO'] == noDO);
          isPesananExist = false;
          message = responseBody['message'];
          _showTopSnackBar(context, message, Colors.green.shade300);
        });
      } else {
        var responseBody = jsonDecode(response.body);
        setState(() {
          message = responseBody['message'];
          _showTopSnackBar(context, message, Colors.red.shade300);
        });
      }
    } catch (e) {
      print('Gagal hapus pesanan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int counter = 1;
    int counterTambah = 1;
    return Scaffold(
      body: SingleChildScrollView(
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
                          _buildInputField(
                            label: "Input No. DO",
                            controller: inputDoController,
                            isInput: true,
                          ),
                          SizedBox(height: 12),
                          _buildInputField(
                            label: "No. Urut",
                            controller: noUrutController,
                          ),
                          SizedBox(height: 12),
                          _buildInputField(
                            label: "Tanggal Kirim",
                            controller: tanggalKirimController,
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
                          _buildInputField(
                            label: "No. SO",
                            controller: noSoController,
                          ),
                          SizedBox(height: 12),
                          _buildInputField(
                            label: "Customer",
                            controller: customerController,
                          ),
                          SizedBox(height: 12),
                          _buildInputField(
                            label: "No Pesan",
                            controller: noPesanController,
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _getDbsppData();
                                  _getDbsppDetData();
                                  setState(() {
                                    counter = 1;
                                    isLihatDetail = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 23, 96, 232),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Lihat Detail',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              isLihatDetail
                  ? isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
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
                                  border:
                                      TableBorder.all(color: Colors.grey[300]!),
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200]),
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'No.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Kode Barang',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Nama Barang',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Qnt',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Satuan',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Keterangan',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                      ],
                                    ),
                                    ...details.map(
                                      (item) => TableRow(
                                        children: [
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('${counter++}'),
                                            ),
                                          ),
                                          Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child:
                                                      Text(item['KodeBrg']!))),
                                          Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child:
                                                      Text(item['NamaBrg']!))),
                                          Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child:
                                                      Text(item['Quantity']!))),
                                          Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child:
                                                      Text(item['Satuan']!))),
                                          Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                      item['Keterangan']!))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                _tambahPesanan();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 23, 96, 232),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                '+ Tambah Pesanan',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )
                  : SizedBox(),
              SizedBox(height: 24),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : isPesananExist
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
                                  border:
                                      TableBorder.all(color: Colors.grey[300]!),
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200]),
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'No.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('No. DO',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Customer',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Nama',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Hapus',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                      ],
                                    ),
                                    // Data rows
                                    ...listOfPesanan.map(
                                      (item) => TableRow(
                                        children: [
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('${counterTambah++}'),
                                            ),
                                          ),
                                          Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(item['NoDO']!))),
                                          Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                      item['KodeCustSupp']!))),
                                          Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(item['Nama']!))),
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: IconButton(
                                                  onPressed: () {
                                                    print('pressed hapus');
                                                    _hapusPesanan(
                                                        item['NoDO']!,
                                                        tanggalKirimController
                                                            .text);
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
                            ),
                            SizedBox(height: 24),
                            isCalculating
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      await _selesai();
                                      Navigator.of(context)
                                          .pushNamed('/supirProses');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 23, 96, 232),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Selesai',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ],
                        )
                      : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool isInput = false,
    bool isDate = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        TextField(
          enabled: isInput ? true : false,
          controller: controller,
          readOnly: isDate,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            hintText: isDate ? "YYYY/MM/DD" : null,
            suffixIcon: isDate
                ? IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        tanggalKirimController.text =
                            "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
                      }
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }
}
