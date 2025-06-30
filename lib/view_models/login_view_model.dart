import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_admin_1/models/login_response_model.dart';
import 'package:web_admin_1/services/login_service.dart';

class LoginViewModel extends ChangeNotifier {
  final loginService = LoginService();
  late LoginResponseModel response;
  String errorMessage = '';
  bool isLoading = false;

  TextEditingController kodeController = TextEditingController();
  TextEditingController namaController = TextEditingController();

  Future<void> isLogin() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    if (kodeController.text.isEmpty || namaController.text.isEmpty) {
      errorMessage = 'Semua field harus diisi.';
      notifyListeners();
      return;
    }

    try {
      response = await loginService.login(
        kodeController.text,
        namaController.text,
      );

      if (response.status == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('loginTime', DateTime.now().toIso8601String());
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = 'Tidak ada koneksi. Silakan periksa kembali.';
    }
    isLoading = false;
    notifyListeners();
  }
}
