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
}
