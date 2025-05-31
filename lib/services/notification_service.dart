import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<void> sendNotification(
    String deviceToken,
    String title,
    String body,
  ) async {
    var url = Uri.parse('$baseUrl/notification/send');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'device_token': deviceToken,
        'title': title,
        'body': body,
      }),
    );
  }

  Future<void> sendNotifications(
    List<Map<String, dynamic>> sortedPesanan,
  ) async {
    var url = Uri.parse('$baseUrl/notification/send');

    for (var pesanan in sortedPesanan) {
      String nodo = pesanan['NoDO'];
      try {
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'device_token':
                'fv4_XOOxQdinQoaxh_AhAg:APA91bF2iyb19P6LfiXDFdzLtEd_lTQ05N6ZwVM27nFSWSOa6pTtZ0as_x81cEE_QEMoBg909Sen3nvupXRSdlBstppNLpZSSlGXKknz2oZXFifxN2zmMM4',
            'title': 'Pesanan Baru!',
            'body': 'Terdapat pesanan $nodo',
          }),
        );

        print('Status: ${response.statusCode} for NoDO: ${pesanan['NoDO']}');

        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          print('Success in notification service: ${responseBody['message']}');
        } else {
          print(
            'Failed to send notification ${pesanan['NoDO']}: ${response.body}',
          );
        }
      } catch (e) {
        print('Error sending notification ${pesanan['NoDO']}: $e');
      }
    }
  }
}
