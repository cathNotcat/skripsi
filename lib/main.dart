import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class HeldKarp {
  List<LatLng> points;

  HeldKarp(this.points);

// Haversine formula to calculate the distance between 2 points (lat & long)
  double calculateDistance(LatLng a, LatLng b) {
    const int earthRadius = 6371; // Earth radius in kilometers
    double lat1 = a.latitude * pi / 180;
    double lat2 = b.latitude * pi / 180;
    double dLat = (b.latitude - a.latitude) * pi / 180;
    double dLon = (b.longitude - a.longitude) * pi / 180;

    double aHaversine = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double cHaversine = 2 * atan2(sqrt(aHaversine), sqrt(1 - aHaversine));
    return earthRadius * cHaversine; // Distance in kilometers
  }

// (?)
  List<LatLng> heldKarp() {
    int n = points.length;
    List<List<double>> dist = List.generate(n, (i) => List.filled(n, 0));

    // Precompute distances between all pairs of points
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        dist[i][j] = dist[j][i] = calculateDistance(points[i], points[j]);
      }
    }

    // dp[mask][i] will hold the minimum distance to visit all points in mask ending at point i
    List<List<double>> dp =
        List.generate(1 << n, (i) => List.filled(n, double.infinity));

    // Base case: starting from the first point
    dp[1][0] = 0;

    for (int mask = 1; mask < (1 << n); mask += 2) {
      for (int u = 0; u < n; u++) {
        if ((mask & (1 << u)) == 0) continue;
        // Try to find the minimum path to u
        for (int v = 0; v < n; v++) {
          if ((mask & (1 << v)) != 0 && u != v) {
            dp[mask][u] = min(dp[mask][u], dp[mask ^ (1 << u)][v] + dist[v][u]);
          }
        }
      }
    }

    // Reconstruct the minimum path
    double minCost = double.infinity;
    int lastIndex = -1;
    List<LatLng> path = [];

    for (int i = 1; i < n; i++) {
      double cost = dp[(1 << n) - 1][i] + dist[i][0];
      if (cost < minCost) {
        minCost = cost;
        lastIndex = i;
      }
    }

    // Reconstructing the path
    int mask = (1 << n) - 1;
    int currentIndex = lastIndex;

    while (currentIndex != -1) {
      path.add(points[currentIndex]);
      mask ^= (1 << currentIndex);
      currentIndex = -1;

      for (int j = 0; j < n; j++) {
        if ((mask & (1 << j)) != 0 &&
            dp[mask][j] + dist[j][lastIndex] ==
                dp[mask | (1 << lastIndex)][lastIndex]) {
          currentIndex = j;
          break;
        }
      }
      lastIndex = currentIndex;
    }

    return path.reversed.toList(); // Reverse to get the correct order
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final List<LatLng> coordinates = [
    LatLng(-7.307720295613444, 112.73480282082548), // Royal Plaza
    LatLng(-7.29060813211877, 112.65463696034303), // Gwalk
    LatLng(-7.355477637548577, 112.6928316163), // McDonald Geluran
    LatLng(-7.280987573813579, 112.79462681150238), // Institute 10 Nov
  ];

  final Set<Polyline> _polylines = {};

  // Define markers for each destination
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    // Initialize markers
    _initializeMarkers();

    _createPolylines();
  }

// adds markers for each location on th emap
  void _initializeMarkers() {
    for (int i = 0; i < coordinates.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId('marker_$i'),
        position: coordinates[i],
        infoWindow: InfoWindow(
          title: 'Destination ${i + 1}',
          snippet: 'Location ${i + 1}',
        ),
      ));
    }
  }

  void _createPolylines() async {
    HeldKarp heldKarp = HeldKarp(coordinates);

    var optimalPathIndices = heldKarp.heldKarp();

    // Fetch polyline points from Directions API for each segment of the optimal path.
    for (int i = 0; i < optimalPathIndices.length - 1; i++) {
      LatLng startLocation = optimalPathIndices[i];
      LatLng endLocation = optimalPathIndices[i + 1];

      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyBRHdO7vAzwE15Ycu2S0GmkDGm0Hn1nq4Q', // Replace with your Google Maps API key
        PointLatLng(startLocation.latitude, startLocation.longitude),
        PointLatLng(endLocation.latitude, endLocation.longitude),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        List<LatLng> points = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        setState(() {
          _polylines.add(Polyline(
            polylineId: PolylineId('route_${i}'),
            points: points,
            color: Colors.blue,
            width: 5,
          ));
        });
      } else {
        print("No route found between ${startLocation} and ${endLocation}");
      }
    }

    _moveCameraToShowRoute();
  }

  void _moveCameraToShowRoute() {
    if (_polylines.isNotEmpty) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          coordinates.map((e) => e.latitude).reduce(min),
          coordinates.map((e) => e.longitude).reduce(min),
        ),
        northeast: LatLng(
          coordinates.map((e) => e.latitude).reduce(max),
          coordinates.map((e) => e.longitude).reduce(max),
        ),
      );

      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Optimal Route with Held-Karp')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-7.307720295613444,
              112.73480282082548), // Center around Royal Plaza initially
          zoom: 12,
        ),
        polylines: _polylines,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MapScreen()));
}
