import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_1/main.dart';
import 'package:web_admin_1/view_models/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = LoginViewModel();
        return viewModel;
      },
      child: Scaffold(
        body: Consumer<LoginViewModel>(
          builder: (context, viewModel, _) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(36),
                height: 300,
                width: 600,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Login',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      enabled: true,
                      controller: viewModel.namaController,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        hintText: 'Nama',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      enabled: true,
                      controller: viewModel.kodeController,
                      obscureText: true,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        hintText: 'Kode',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                      ),
                    ),
                    // const SizedBox(height: 24),
                    Text(
                      viewModel.errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                    // const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      // child: ElevatedButton(
                      //   onPressed: () async {
                      //     await viewModel.isLogin();
                      //     if (viewModel.response.status == 200) {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const Navbar()),
                      //       );
                      //     } else {
                      //       print('error');
                      //     }
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor:
                      //         const Color.fromARGB(255, 23, 96, 232),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      //   child: const Text(
                      //     'Login',
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      // ),
                      child: ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () async {
                                await viewModel.isLogin();
                                if (viewModel.response.status == 200) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Navbar()),
                                  );
                                } else {
                                  print('error');
                                }
                              },
                        child: viewModel.isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : const Text('Login',
                                style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 23, 96, 232),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
