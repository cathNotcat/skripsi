import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<void> sendNotification(
      String deviceToken, String title, String body) async {
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
      List<Map<String, dynamic>> sortedPesanan) async {
    var url = Uri.parse('$baseUrl/notification/send');

    for (var pesanan in sortedPesanan) {
      String nodo = pesanan['NoDO'];
      try {
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'device_token':
                'cyYGMRV-RySWEzvuKg5nOS:APA91bEQEk_jP8N2aVLe4oMhS9kF3d-PGy6kk1-sUmC3BN9r-Z536MpQe50bKMzgSPgbpKRYhjseMTmNRu1KeEoKHhOENBGS7SS97b2vUuO87Q5_-At3Rqo',
            'title': 'Pesanan Baru!',
            'body': 'Terdapat pesanan $nodo'
          }),
        );

        print('Status: ${response.statusCode} for NoDO: ${pesanan['NoDO']}');

        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          print('Success in notification service: ${responseBody['message']}');
        } else {
          print(
              'Failed to send notification ${pesanan['NoDO']}: ${response.body}');
        }
      } catch (e) {
        print('Error sending notification ${pesanan['NoDO']}: $e');
      }
    }
  }
}
