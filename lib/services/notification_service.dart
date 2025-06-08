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
                'eqpDf1kvSLexfUVlLWSPuD:APA91bF0Ne3KmslPSjLihRxuqV6yF7CFI-hGuAxifwxB1Tk4X0pqllJRhuHxD_9t3Agz_YCzVRMiTgMCOE3PjdpWycfCwUp5HqvYLxnwwdpdcOYiFZ9NRLQ',
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
