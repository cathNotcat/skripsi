import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class PolylineService {
  Future<List<LatLng>> getPolylinePoints(LatLng start, LatLng end) async {
    final origin = '${start.latitude},${start.longitude}';
    final destination = '${end.latitude},${end.longitude}';
    final apiKey = dotenv.env['GOOGLEMAPS_API_KEY'];

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
}
