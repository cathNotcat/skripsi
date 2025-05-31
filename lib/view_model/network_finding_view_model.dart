// import 'package:aplikasi_1/services/network_finding_service.dart';
// import 'package:flutter/material.dart';

// class NetworkFindingViewModel extends ChangeNotifier {
//   final discoveryService = NetworkFindingService();

//   bool isLoading = true;
//   bool isError = false;

//   Future<void> initializeBackendUrl() async {
//     final baseUrl = await discoveryService.findLocalBackend();
//     if (baseUrl != null) {
//       isLoading = false;
//       notifyListeners();
//       print('✅ Backend found at: $baseUrl');
//     } else {
//       print('❌ Backend not found on LAN');
//       isError = true;
//       notifyListeners();
//     }
//   }
// }
