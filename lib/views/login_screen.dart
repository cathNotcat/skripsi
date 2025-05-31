// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_1/main.dart';
import 'package:aplikasi_1/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        body: Consumer<LoginViewModel>(builder: (context, viewModel, _) {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: viewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'LOGO',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 40),
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text(
                                    'Nama',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  inputField(
                                      viewModel.namaController, 'Nama', false),
                                  SizedBox(height: 16),
                                  Text(
                                    'Kode',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  inputField(
                                      viewModel.kodeController, 'Kode', true),
                                  SizedBox(height: 8),
                                  viewModel.isError
                                      ? Text(
                                          'Nama atau Kode salah!',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : SizedBox(),
                                  Container(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 23, 96, 232),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          textStyle: const TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        onPressed: () async {
                                          await viewModel.getLoginInfo();
                                          if (!viewModel.isError) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Navbar()),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          'LOGIN',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }

  Widget inputField(
      TextEditingController controller, String value, bool secure) {
    return TextFormField(
      controller: controller,
      obscureText: secure ? true : false,
      cursorColor: const Color.fromARGB(500, 24, 41, 78),
      style: const TextStyle(color: Color.fromARGB(500, 24, 41, 78)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(255, 245, 245, 245),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(80, 212, 212, 212),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 212, 212, 212),
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$value harus diisi';
        }
        return null;
      },
    );
  }
}
