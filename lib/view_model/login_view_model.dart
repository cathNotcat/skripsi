import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginViewModel extends ChangeNotifier {
  TextEditingController kodeController = TextEditingController();
  TextEditingController namaController = TextEditingController();

  bool isError = false;
  bool isLoading = false;

  Future<void> getLoginInfo() async {
    isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('ip_address');

    var url = Uri.parse('$baseUrl/user/admin');
    try {
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "kode": kodeController.text,
            "nama": namaController.text,
          }));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var data = responseBody['data'];
        if (data != null) {
          isError = false;
          notifyListeners();
        }
      } else {
        isError = true;
        notifyListeners();
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error in getLoginInfo: $e');
    }
  }
}
