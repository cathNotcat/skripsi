import 'dart:math';

import 'package:aplikasi_1/models/pengiriman_model.dart';
import 'package:aplikasi_1/services/pengiriman_service.dart';
import 'package:aplikasi_1/services/polyline_service.dart';
import 'package:aplikasi_1/widget/colors_widget.dart';
import 'package:aplikasi_1/widget/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PengirimanViewModel extends ChangeNotifier {
  final pengirimanService = PengirimanService();
  final polylineService = PolylineService();
  final Set<Marker> _markers = {};

  bool isLoading = false;
  String errorMessage = '';

  late GoogleMapController mapController;
  LatLng _initialPosition = LatLng(0, 0);

  List<LatLng> points = [];
  List<LatLng> polylinePoints = [];

  List<Map<String, dynamic>> details = [];
  Set<Polyline> polylines = {};

  int pesanan = 0;
  String detStatus = '';

  bool isDataAvailable = false;
  bool isPesananSelesai = false;

  Future<void> fetchLatLong() async {
    final prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble('latitude');
    double? lng = prefs.getDouble('longitude');
    if (lat != null && lng != null) {
      _initialPosition = LatLng(lat, lng);
      points.clear();
      points.add(_initialPosition);
      notifyListeners();
    }
  }

  Future<void> _initializeWithAsync() async {
    await fetchPengirimanSopirData();

    initializeMarkers();
    moveCameraToShowRoute();
  }

  void initializeMarkers() {
    for (int i = 0; i < points.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: points[i],
          infoWindow: InfoWindow(
            title: 'Destination ${i + 1}',
            snippet: 'Location ${i + 1}',
          ),
        ),
      );
      notifyListeners();
    }
  }

  void moveCameraToShowRoute() {
    if (polylines.isNotEmpty) {
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

  Future<void> fetchPolyline(LatLng start, LatLng end) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      polylinePoints = await polylineService.getPolylinePoints(start, end);

      if (polylinePoints.isEmpty) {
        errorMessage = 'No route found';
      }
    } catch (e) {
      errorMessage = 'Failed to fetch polyline: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPengirimanSopirData() async {
    try {
      final List<PengirimanModel> dataList = await pengirimanService
          .getPengirimanByDate(DateFormatter.formatDateToday());

      details = [];
      points = [];
      polylines.clear();
      pesanan = 0;
      isPesananSelesai = false;
      isDataAvailable = false;

      for (var item in dataList) {
        final mapItem = {
          'NoDO': item.noDO,
          'Status': item.status,
          'Koordinat': item.koordinat,
        };
        details.add(mapItem);

        if (item.status == "2") {
          isPesananSelesai = true;
        }

        if (item.koordinat != null && item.koordinat!.isNotEmpty) {
          var parts = item.koordinat!.split(',');
          if (parts.length == 2) {
            double? lat = double.tryParse(parts[0].trim());
            double? lng = double.tryParse(parts[1].trim());

            if (lat != null && lng != null) {
              points.add(LatLng(lat, lng));
            }
          }
        }
      }

      pesanan = dataList.length;
      isDataAvailable = dataList.isNotEmpty;
      notifyListeners();

      for (int i = 0; i < points.length - 1; i++) {
        final start = points[i];
        final end = points[i + 1];

        List<LatLng> routeSegment =
            await polylineService.getPolylinePoints(start, end);

        polylines.add(
          Polyline(
            polylineId: PolylineId('route_$i'),
            points: routeSegment,
            color: Colors.blue,
            width: 5,
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      print('Error in pengiriman view model: $e');
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
          backgroundColor: ColorsWidget.containerColor,
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
                    backgroundColor: ColorsWidget.buttonColor,
                  ),
                  child: const Text(
                    'Selesai',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _changeStatus(noPeng, noUrut, 2);
                    fetchPengirimanSopirData();
                    detStatus = '2';
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
      var response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'Status': statusChange}),
      );

      if (response.statusCode == 200) {
        fetchPengirimanSopirData();

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
}
