import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);

  @override
  String toString() => "($latitude, $longitude)";
}

class HeldKarp {
  String apiKey = dotenv.env['OPENROUTESERVICE_API_KEY'] ?? '';

  // Future<double> getDistance(
  //   double startLong,
  //   double startLat,
  //   double endLong,
  //   double endLat,
  // ) async {
  //   String urlAB =
  //       "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=$startLong,$startLat&end=$endLong,$endLat";
  //   String urlBA =
  //       "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=$endLong,$endLat&end=$startLong,$startLat";

  //   try {
  //     final responseAB = await http.get(Uri.parse(urlAB));
  //     final responseBA = await http.get(Uri.parse(urlBA));

  //     if (responseAB.statusCode == 200 && responseBA.statusCode == 200) {
  //       final dataAB = json.decode(responseAB.body);
  //       final dataBA = json.decode(responseBA.body);

  //       double distanceAB = extractDistance(dataAB);
  //       double distanceBA = extractDistance(dataBA);

  //       print(
  //           'Distance $startLong → $endLong: $distanceAB km, Distance $endLong → $startLong: $distanceBA km');

  //       return (distanceAB + distanceBA) / 2; // Store them separately if needed
  //     } else {
  //       print(
  //           "Failed to fetch data: ${responseAB.statusCode} | ${responseBA.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  //   return double.infinity;
  // }

  Future<double> getDistance(
    double startLong,
    double startLat,
    double endLong,
    double endLat,
  ) async {
    String url =
        "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=$startLong,$startLat&end=$endLong,$endLat";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double distance = extractDistance(data);
        print('Distance $startLong → $endLong: $distance km');
        return distance;
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return double.infinity;
  }

  double extractDistance(Map<String, dynamic> data) {
    if (data.containsKey("features") &&
        data["features"] is List &&
        data["features"].isNotEmpty) {
      var feature = data["features"][0];
      if (feature.containsKey("properties") &&
          feature["properties"].containsKey("segments") &&
          feature["properties"]["segments"] is List &&
          feature["properties"]["segments"].isNotEmpty) {
        double distanceInMeters =
            feature["properties"]["segments"][0]["distance"];
        return distanceInMeters / 1000;
      }
    }
    return double.infinity;
  }

  Future<List<LatLng>> calculateWithHeldKarp(List<LatLng> points) async {
    int n = points.length;

    // Set the matrix, default is 0
    List<List<double>> dist = List.generate(n, (i) => List.filled(n, 0));

    // Insert the 2d matrix with distance of each pair of locations
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        await Future.delayed(Duration(seconds: 1));
        // dist[i][j] = dist[j][i] = await getDistance(points[i].longitude,
        //     points[i].latitude, points[j].longitude, points[j].latitude);

        dist[i][j] = await getDistance(points[i].longitude, points[i].latitude,
            points[j].longitude, points[j].latitude);
        dist[j][i] = await getDistance(points[j].longitude, points[j].latitude,
            points[i].longitude, points[i].latitude);
      }
    }

    // Dynamic programming table, set the default to infinite (2^n karena akan pakai bitmask / binary)
    List<List<double>> dp =
        List.generate(1 << n, (i) => List.filled(n, double.infinity));

    // First city to first city has 0 km distance
    dp[1][0] = 0;

    // mask = 1 or 1 (city A), mask = 11 or 3 (city A,B), mask = 111 or 7 (city A,B,C)
    // loop through all possible subsets (A, B, or C)
    // mask+=2 so that in binary, city A always included (1, 101, 111, 1001)
    for (int mask = 1; mask < (1 << n); mask += 2) {
      // itereates through each city in the current subset
      for (int u = 0; u < n; u++) {
        // check if the city is not in the subset, next
        if ((mask & (1 << u)) == 0) continue;
        // iterate through all the cities
        for (int v = 0; v < n; v++) {
          // ensure the v != u so that it won't visit the same city
          if ((mask & (1 << v)) != 0 && u != v) {
            // find the minimum distance to reach u by considering all possible preious cities (v)
            // (?)
            dp[mask][u] = min(dp[mask][u], dp[mask ^ (1 << u)][v] + dist[v][u]);
            print(
                "Updating dp[$mask][$u] = min(${dp[mask][u]}, ${dp[mask ^ (1 << u)][v]} + ${dist[v][u]})");
          }
        }
      }
    }

    // Reconstruct the minimum path
    double minCost = double.infinity;
    int lastIndex = -1;
    List<LatLng> path = [];

    // Find the last city in the optimal path
    // loops through all cities except city A
    for (int i = 1; i < n; i++) {
      // cost from last city to initial city
      double cost = dp[(1 << n) - 1][i] + dist[i][0];
      // find the minimum
      if (cost < minCost) {
        minCost = cost;
        // stores visited city before return to A
        lastIndex = i;
      }
    }

    // Reconstructing the path
    int mask = (1 << n) - 1;
    int currentIndex = lastIndex;

    // Backtrace from last city to starting city
    while (currentIndex != -1) {
      // Adds the current city to the path
      path.add(points[currentIndex]);
      // Removes the current city from the visited set
      mask ^= (1 << currentIndex);
      currentIndex = -1;

      // Find which city was visited before lastIndex
      for (int j = 0; j < n; j++) {
        // if j is still in the visited set &&
        // check if the cost of traverlling from j to lastIndex matches the stored minimum cost
        // if it's true, then j was the previous city in the optimal path
        if ((mask & (1 << j)) != 0 &&
            dp[mask][j] + dist[j][lastIndex] ==
                dp[mask | (1 << lastIndex)][lastIndex]) {
          currentIndex = j;
          break;
        }
      }
      lastIndex = currentIndex;
    }
    print('min cost: $minCost km');
    return path.reversed.toList();
  }
}
