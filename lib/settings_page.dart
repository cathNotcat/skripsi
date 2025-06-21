// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_1/main.dart';
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
  bool? isLoggedIn;
  bool? isIPSet;
  String errorMessage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadIpLoggedIn();
      print('islogged in? $isLoggedIn');
      print('isIPSet in? $isIPSet');
    });
  }

  Future<void> _setIpAddress(String ipAddress) async {
    print('inputIpController.text: ${inputIpController.text}');
    if (inputIpController.text == '' || inputIpController.text.isEmpty) {
      setState(() {
        errorMessage = 'Field harus diisi.';
      });
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ip_address', 'http://${ipAddress}/backend_api');
    await prefs.setBool('isIPSet', true);
    String? ip = prefs.getString('ip_address');
    print('done input ip: $ip');
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isIPSet', false);
    await prefs.setBool('isLoggedIn', false);
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn');
      isIPSet = prefs.getBool('isIPSet');
    });
  }

  Future<void> _loadIpLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn');
      isIPSet = prefs.getBool('isIPSet');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isIPSet == true
                ? SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IP Address',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
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
                          SizedBox(height: 8),
                          errorMessage == ''
                              ? SizedBox()
                              : Text(
                                  errorMessage,
                                  style: TextStyle(color: Colors.red),
                                ),
                          Container(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                _setIpAddress(inputIpController.text);
                                if (inputIpController.text != '' ||
                                    inputIpController.text.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                }
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
                          ),
                        ],
                      ),
                    ],
                  ),
            isLoggedIn ?? false
                ? Container(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        _logout();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()),
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
                      child: Text('Log Out'),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
