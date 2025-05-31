// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_1/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController inputIpController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _setIpAddress(String ipAddress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ip_address', 'http://${ipAddress}/backend_api');
    String? ip = prefs.getString('ip_address');
    print('done input ip: $ip');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'IP Address',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            TextField(
              controller: inputIpController,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                _setIpAddress(inputIpController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Color.fromARGB(255, 23, 96, 232),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: FittedBox(
                // 🔹 Ensures text scales correctly
                fit: BoxFit.scaleDown,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
