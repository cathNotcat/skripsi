// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_1/main.dart';
import 'package:aplikasi_1/models/sopir_model.dart';
import 'package:aplikasi_1/services/sopir_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math';

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

  // var baseUrl = dotenv.env['BASE_URL'];
  DateTime now = DateTime.now();

  String detNoDO = '';
  String detAlamat = '';
  String detCust = '';
  String detJumlahBrg = '';
  String detStatus = '';
  String detNoPeng = '';
  String detNoUrut = '';

  List<String> detKodeBrg = [];
  List<String> detQty = [];

  int pilihan_widget = 0;
  int index_selected = 0;

  bool isDataAvailable = false;
  bool isPesananSelesai = false;

  List<Map<String, dynamic>> details = [];
  List<Map<String, dynamic>> detDetails = [];

  int pesanan = 0;

  late GoogleMapController mapController;
  LatLng _initialPosition = LatLng(0, 0);
  List<LatLng> points = [];
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getLatLong();
    print('is data available: $isDataAvailable');
    print('pilihan widget: $pilihan_widget');
  }

  Future<void> _getLatLong() async {
    final prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble('latitude');
    double? lng = prefs.getDouble('longitude');
    if (lat != null && lng != null) {
      setState(() {
        _initialPosition = LatLng(lat, lng);
        points.clear();
        points.add(_initialPosition);
      });
    }
    print('initial position: $_initialPosition');
  }

  Future<void> _initializeWithAsync() async {
    await _getPengirimanSupirData();

    setMarkersFromDetails();
    _moveCameraToShowRoute();
  }

  // void _initializeMarkers() {
  //   for (int i = 0; i < points.length; i++) {
  //     _markers.add(
  //       Marker(
  //         markerId: MarkerId('marker_$i'),
  //         position: points[i],
  //         infoWindow: InfoWindow(
  //           title: '${i + 1} $detNoDO',
  //           snippet: '${i + 1} $detAlamat',
  //         ),
  //       ),
  //     );
  //   }
  // }

  void setMarkersFromDetails() {
    for (int i = 0; i < details.length; i++) {
      // for (var detail in details) {
      final detail = details[i];
      String? noDo = detail['NoDO'];
      String? alamat = detail['Alamat'];
      String? koordinat = detail['Koordinat'];

      if (koordinat != null && koordinat.isNotEmpty) {
        var parts = koordinat.split(',');
        if (parts.length == 2) {
          double? lat = double.tryParse(parts[0].trim());
          double? lng = double.tryParse(parts[1].trim());

          if (lat != null && lng != null) {
            _markers.add(
              Marker(
                markerId: MarkerId(noDo ?? UniqueKey().toString()),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                  title: '${i + 1}. $noDo' ?? 'NoDO Not Available',
                  snippet: alamat ?? 'Location Not Available',
                ),
              ),
            );
          }
        }
      }
    }
  }

  void _moveCameraToShowRoute() {
    if (_polylines.isNotEmpty) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          points.map((e) => e.latitude).reduce(min),
          points.map((e) => e.longitude).reduce(min),
        ),
        northeast: LatLng(
          points.map((e) => e.latitude).reduce(max),
          points.map((e) => e.longitude).reduce(max),
        ),
      );

      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  Future<List<LatLng>> getPolylinePoints(LatLng start, LatLng end) async {
    final origin = '${start.latitude},${start.longitude}';
    final destination = '${end.latitude},${end.longitude}';
    final apiKey =
        dotenv.env['GOOGLEMAPS_API_KEY']; // Replace with your real key

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['routes'].isNotEmpty) {
        final points = data['routes'][0]['overview_polyline']['points'];
        final polylinePoints = PolylinePoints().decodePolyline(points);

        return polylinePoints
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList();
      }
    }

    return [];
  }

  Future<void> _getPengirimanSupirData() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('ip_address');
    String? selectedSopir = prefs.getString('selected_sopir');
    var url = Uri.parse(
        '$baseUrl/pengiriman/tanggal/sopir/$formattedDate/$selectedSopir');

    print('url in getPengirimanSupirData: $url');

    try {
      var response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      print('status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var data = responseBody['data'];
        if (data != null) {
          setState(() {
            details = List<Map<String, dynamic>>.from(
              data.map((item) => item as Map<String, dynamic>),
            );

            for (var det in details) {
              if (det['Status'] == "2") {
                isPesananSelesai = true;
              }

              String? koordinat = det['Koordinat'];
              if (koordinat != null || koordinat!.isNotEmpty) {
                var parts = koordinat.split(',');
                if (parts.length == 2) {
                  double? lat = double.tryParse(parts[0].trim());
                  double? lng = double.tryParse(parts[1].trim());

                  if (lat != null && lng != null) {
                    points.add(LatLng(lat, lng));
                  }
                }
              }
            }
            pesanan = data.length;

            if (responseBody['message'] != 'Tidak ada pesanan') {
              isDataAvailable = true;
            }
          });

          for (int i = 0; i < points.length - 1; i++) {
            final start = points[i];
            final end = points[i + 1];

            List<LatLng> routeSegment = await getPolylinePoints(start, end);

            setState(() {
              _polylines.add(
                Polyline(
                  polylineId: PolylineId('route_$i'),
                  points: routeSegment,
                  color: Colors.blue,
                  width: 5,
                ),
              );
            });
          }
        } else {
          print(
            'Unexpected response structure in _getPengirimanSupirData() in PesananPage',
          );
        }
      } else {
        print(
          'Gagal load user data di _getPengirimanSupirData di PesananPage: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error occurred in getPengirimanSopirData: $e');
    }
  }

  Future<void> _confirmModal(
    BuildContext context,
    String noPeng,
    String noUrut,
  ) {
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
                    _changeStatus(noPeng, noUrut, 2);
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

  Future<void> _changeStatus(
    String noPeng,
    String noUrut,
    int statusChange,
  ) async {
    print('no bukti: $noPeng');
    print('status change: $statusChange');

    final prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('ip_address');
    var url = Uri.parse('$baseUrl/pengiriman/update/$noPeng/$noUrut');

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permission permanently denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double latitude = position.latitude;
      double longitude = position.longitude;

      var response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Status': statusChange,
          'Latitude': latitude,
          'Longitude': longitude,
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
      print('Error occurred in changeStatus: $e');
    }
  }

  Future<void> _getDbsppDetData(String nobukti) async {
    final prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('ip_address');
    var url = Uri.parse('$baseUrl/dbsppdet/nobukti');

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'NOBUKTI': nobukti}),
      );
      print('status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var data = responseBody['data'];
        if (data != null) {
          setState(() {
            detDetails = List<Map<String, dynamic>>.from(
              data.map((item) => item as Map<String, dynamic>),
            );
          });
          print(detDetails[0]['KodeBrg']);
        } else {
          print('Unexpected response structure.');
        }
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred in getDbsppDetData: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 150,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        body:
            (_initialPosition.latitude == 0 && _initialPosition.longitude == 0)
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 12,
                    ),
                    polylines: _polylines,
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                      _initializeWithAsync();
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
              pilihan_widget == 0
                  ? isDataAvailable == true
                      ? _listPesananPage()
                      : Center(child: Text('Tidak ada pesanan'))
                  : _detailPesananPage()
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
                            item['NoDO']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              left: 12,
                              right: 12,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor(item['Status']),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              getStatusString(item['Status']),
                              style: TextStyle(
                                color: getStatusTextColor(item['Status']),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 20),
                          SizedBox(width: 8),
                          Text(
                            item['Alamat']!, // Access Alamat from the item
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.person_outline, size: 20),
                          SizedBox(width: 8),
                          Text(
                            item['Nama']!,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.inbox_outlined, size: 20),
                          SizedBox(width: 8),
                          Text(
                            '${item['JumlahBarang']} jenis barang',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 24),
                        child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                23,
                                96,
                                232,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              textStyle: const TextStyle(fontSize: 16.0),
                            ),
                            onPressed: () {
                              print(
                                'no pengiriman: ${item['NoPengiriman']}',
                              );
                              setState(() {
                                pilihan_widget = 1;
                                index_selected = index;
                                if (item['Status'] != "2") {
                                  _changeStatus(
                                    item['NoPengiriman'],
                                    item['NoUrut'],
                                    1,
                                  );
                                  detStatus = '1';
                                }
                                detNoDO = item['NoDO'];
                                detAlamat = item['Alamat'];
                                detCust = item['Nama'];
                                detJumlahBrg = item['JumlahBarang'];
                                detNoPeng = item['NoPengiriman'];
                                detNoUrut = item['NoUrut'];
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
                ),
              );
            })
            .values
            .toList(),
      ),
    );
    // return Center(
    //     child: Text('Tidak ada pesanan', style: TextStyle(fontSize: 18)));
  }

  Widget _detailPesananPage() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          padding: EdgeInsets.only(left: 16, right: 16),
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
                      style: TextStyle(
                        color: Color.fromARGB(255, 152, 162, 179),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    detNoDO,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 12,
                      right: 12,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(detStatus),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text(
                      getStatusString(detStatus),
                      style: TextStyle(
                        color: getStatusTextColor(detStatus),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 20),
                  SizedBox(width: 8),
                  Text(
                    // 'Jl. Pasar Turi no. 19-21',
                    detAlamat,
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 20),
                  SizedBox(width: 8),
                  Text(
                    // 'Sastroijo Pungli',
                    detCust,
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.inbox_outlined, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '$detJumlahBrg jenis barang',
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Barang',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kode Barang',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Jumlah',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      // height: (40 * detDetails.length).toDouble(),
                      height: 80,
                      // constraints: BoxConstraints(
                      //     // maxHeight: 80,
                      //     ),
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
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  // '${detQty[index]}',
                                  detDetails[index]['Quantity'],
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
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
                      textStyle: const TextStyle(fontSize: 16.0),
                    ),
                    onPressed: () {
                      if (detStatus != '2') {
                        _confirmModal(context, detNoPeng, detNoUrut);
                        getStatusColor(detStatus);
                        getStatusString(detStatus);
                        getStatusTextColor(detStatus);
                      }
                    },
                    child: Text(
                      detStatus == '2'
                          ? 'Pesanan Selesai'
                          : 'Selesaikan Pesanan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class SelesaiPage extends StatefulWidget {
//   const SelesaiPage({super.key});

//   @override
//   State<SelesaiPage> createState() => _SelesaiPageState();
// }

// class _SelesaiPageState extends State<SelesaiPage> {
//   // var baseUrl = dotenv.env['BASE_URL'];

//   List<Map<String, dynamic>> filteredOrdersData = [];

//   Color buttonColor = Color.fromARGB(255, 23, 96, 232);
//   Color containerColor = Color.fromARGB(255, 255, 255, 255);
//   Color textColor = Color.fromARGB(255, 82, 89, 105);

//   @override
//   void initState() {
//     super.initState();
//     _getHistory();
//     filteredOrdersData = ordersData;
//   }

//   Map<String, bool> selectedMonths = {
//     "January": false,
//     "February": false,
//     "March": false,
//     "April": false,
//     "May": false,
//     "June": false,
//     "July": false,
//     "August": false,
//     "September": false,
//     "October": false,
//     "November": false,
//     "December": false,
//   };

//   Map<String, bool> selectedYears = {"2023": false, "2024": false};

//   List<Map<String, dynamic>> ordersData = [];
//   void applyFilters() {
//     setState(() {
//       filteredOrdersData = ordersData.where((order) {
//         DateTime date = DateTime.parse(order["TANGGAL"]);
//         String month = DateFormat(
//           'MMMM',
//         ).format(date); // Month in full text
//         String year = date.year.toString();

//         // Match the selected months and years
//         return (selectedMonths[month] ?? false) ||
//             (selectedYears[year] ?? false);
//       }).toList();
//     });
//   }

//   Future<void> _getHistory() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? baseUrl = prefs.getString('ip_address');
//     var url = Uri.parse('$baseUrl/dbso/tanggal');

//     try {
//       var response = await http.get(url);

//       if (response.statusCode == 200) {
//         var responseBody = jsonDecode(response.body);
//         var data = responseBody['data'];
//         if (data != null) {
//           for (var orders in data) {
//             setState(() {
//               ordersData.add(orders);
//             });
//           }
//           // print(ordersData);
//         } else {
//           print('Unexpected response structure.');
//         }
//       } else {
//         print('Failed to load user data(gethistory): ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error occurred in getHistory: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all(24),
//         margin: EdgeInsets.only(top: 40),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Pesanan Selesai',
//               style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//             ),
//             // Container(
//             //   padding: EdgeInsets.all(16),
//             //   color: Colors.grey[200],
//             //   child: Column(
//             //     crossAxisAlignment: CrossAxisAlignment.start,
//             //     children: [
//             //       // Filter by Month
//             //       Text(
//             //         "Filter by Month",
//             //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //       ),
//             //       Wrap(
//             //         spacing: 8.0,
//             //         children: selectedMonths.keys.map((month) {
//             //           return FilterChip(
//             //             label: Text(month),
//             //             selected: selectedMonths[month] ?? false,
//             //             onSelected: (selected) {
//             //               setState(() {
//             //                 selectedMonths[month] = selected;
//             //               });
//             //               applyFilters();
//             //             },
//             //           );
//             //         }).toList(),
//             //       ),
//             //       SizedBox(height: 16),
//             //       // Filter by Year
//             //       Text(
//             //         "Filter by Year",
//             //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //       ),
//             //       Wrap(
//             //         spacing: 8.0,
//             //         children: selectedYears.keys.map((year) {
//             //           return FilterChip(
//             //             label: Text(year),
//             //             selected: selectedYears[year] ?? false,
//             //             onSelected: (selected) {
//             //               setState(() {
//             //                 selectedYears[year] = selected;
//             //               });
//             //               applyFilters();
//             //             },
//             //           );
//             //         }).toList(),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             Expanded(
//               child: Scrollbar(
//                 thumbVisibility: true,
//                 interactive: true,
//                 thickness: 8.0,
//                 radius: Radius.circular(8.0),
//                 child: ListView.builder(
//                   itemCount: ordersData.length,
//                   itemBuilder: (context, index) {
//                     var dateData = ordersData[index];
//                     String rawDate = dateData["TANGGAL"];
//                     List<String> orders = List<String>.from(
//                       dateData["NOBUKTI"],
//                     );
//                     DateTime dateTime = DateTime.parse(rawDate);
//                     String formattedDate = DateFormat(
//                       'd MMMM yyyy',
//                     ).format(dateTime);
//                     return Container(
//                       margin: EdgeInsets.all(8),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               formattedDate,
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemCount: orders.length,
//                             itemBuilder: (context, orderIndex) {
//                               return Container(
//                                 padding: EdgeInsets.all(16),
//                                 margin: EdgeInsets.only(bottom: 8),
//                                 decoration: BoxDecoration(
//                                   color: containerColor,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Icon(Icons.assignment_outlined),
//                                         SizedBox(width: 16),
//                                         Text(
//                                           orders[orderIndex],
//                                           style: TextStyle(color: textColor),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
