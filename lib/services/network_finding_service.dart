// import 'package:network_info_plus/network_info_plus.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class NetworkFindingService {
//   Future<String?> findLocalBackend({int port = 8000}) async {
//     final info = NetworkInfo();
//     final ip = await info.getWifiIP();

//     print('info in NetworkFinding: $info');
//     print('ip in NetworkFinding: $ip');

//     if (ip == null) return null;

//     final subnet = ip.substring(0, ip.lastIndexOf('.'));

//     for (int i = 1; i < 255; i++) {
//       final testIp = '$subnet.$i';
//       print('subnet: $subnet');
//       print('i: $i');
//       final url = Uri.parse('http://$testIp:$port/ping');
//       try {
//         final response =
//             await http.get(url).timeout(Duration(milliseconds: 500));
//         if (response.statusCode == 200) {
//           final url = 'http://$testIp:$port';

//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('ip_address', url);

//           return url;
//         }
//       } catch (e) {
//         print('Error in NetworkFindingService: $e');
//       }
//     }

//     return null;
//   }

//   // Future<String?> findLocalBackend({int port = 8000}) async {
//   //   final info = NetworkInfo();
//   //   final ip = await info.getWifiIP();

//   //   if (ip == null) return null;

//   //   final subnet = ip.substring(0, ip.lastIndexOf('.'));
//   //   final ipsToCheck = List.generate(254, (i) => '$subnet.${i + 1}');

//   //   final futures = ipsToCheck.map((testIp) async {
//   //     final url = Uri.parse('http://$testIp:$port/ping');
//   //     try {
//   //       final response =
//   //           await http.get(url).timeout(Duration(milliseconds: 500));
//   //       if (response.statusCode == 200) {
//   //         return 'http://$testIp:$port';
//   //       }
//   //     } catch (_) {}
//   //     return null;
//   //   });

//   //   final results = await Future.wait(futures);
//   //   final foundUrl =
//   //       results.firstWhere((url) => url != null, orElse: () => null);

//   //   if (foundUrl != null) {
//   //     final prefs = await SharedPreferences.getInstance();
//   //     await prefs.setString('ip_address', foundUrl);
//   //   }

//   //   return foundUrl;
//   // }

//   Future<String?> getUrlFromBackend() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('ip_address');
//   }
// }
