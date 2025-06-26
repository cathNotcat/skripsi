import 'dart:math';

import 'package:web_admin_1/models/latlng_model.dart';

class KMeans {
  /// Cluster LatLng points into `k` clusters
  static Map<int, List<LatLng>> clusterPoints(List<LatLng> points, int k,
      {int maxIterations = 100}) {
    if (points.length <= k) {
      // One cluster per point
      return {
        for (int i = 0; i < points.length; i++) i: [points[i]]
      };
    }

    final rand = Random();
    List<LatLng> centroids = List.generate(
      k,
      (_) => points[rand.nextInt(points.length)],
    );

    Map<int, List<LatLng>> clusters = {};
    for (int iter = 0; iter < maxIterations; iter++) {
      // Assign points to closest centroid
      clusters = {for (int i = 0; i < k; i++) i: []};

      for (var point in points) {
        int closest = 0;
        double minDist = _distance(point, centroids[0]);

        for (int i = 1; i < k; i++) {
          final dist = _distance(point, centroids[i]);
          if (dist < minDist) {
            closest = i;
            minDist = dist;
          }
        }

        clusters[closest]!.add(point);
      }

      // Recompute centroids
      List<LatLng> newCentroids = [];
      for (int i = 0; i < k; i++) {
        final cluster = clusters[i]!;
        if (cluster.isEmpty) {
          newCentroids.add(centroids[i]);
          continue;
        }

        double avgLat = cluster.map((p) => p.latitude).reduce((a, b) => a + b) /
            cluster.length;
        double avgLng =
            cluster.map((p) => p.longitude).reduce((a, b) => a + b) /
                cluster.length;

        newCentroids.add(LatLng(avgLat, avgLng));
      }

      if (_centroidsEqual(centroids, newCentroids)) break;
      centroids = newCentroids;
    }

    return clusters;
  }

  static double _distance(LatLng a, LatLng b) {
    // Euclidean distance; acceptable if distances are small
    return sqrt(
        pow(a.latitude - b.latitude, 2) + pow(a.longitude - b.longitude, 2));
  }

  static bool _centroidsEqual(List<LatLng> a, List<LatLng> b) {
    for (int i = 0; i < a.length; i++) {
      if ((a[i].latitude - b[i].latitude).abs() > 1e-6 ||
          (a[i].longitude - b[i].longitude).abs() > 1e-6) {
        return false;
      }
    }
    return true;
  }
}
