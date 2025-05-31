import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_admin_1/services/login_service.dart';

class LoginViewModel extends ChangeNotifier {
  final loginService = LoginService();
  int status = 0;
  String errorMessage = '';

  TextEditingController kodeController = TextEditingController();
  TextEditingController namaController = TextEditingController();

  Future<void> isLogin() async {
    errorMessage = '';
    notifyListeners();

    if (kodeController.text.isEmpty || namaController.text.isEmpty) {
      errorMessage = 'Semua field harus diisi.';
      notifyListeners();
      return;
    }

    try {
      status = await loginService.login(
        kodeController.text,
        namaController.text,
      );

      if (status == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('loginTime', DateTime.now().toIso8601String());
      } else {
        errorMessage = 'Nama atau Kode salah. Silakan periksa kembali.';
      }
    } catch (e) {
      errorMessage = 'Nama atau Kode salah. Silakan periksa kembali.';
    }

    notifyListeners();
  }
}
