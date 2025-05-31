// import 'package:flutter/material.dart';
// import 'package:web_admin_1/main.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController userameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   Future<void> _login() async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => Navbar()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           padding: EdgeInsets.all(36),
//           height: 300,
//           width: 600,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.shade300,
//                 blurRadius: 10,
//                 offset: Offset(0, 5),
//               ),
//             ],
//             borderRadius: BorderRadius.all(Radius.circular(20)),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'Login',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 enabled: true,
//                 controller: userameController,
//                 cursorColor: Colors.grey,
//                 decoration: InputDecoration(
//                   hintText: 'Username',
//                   filled: true,
//                   fillColor: Colors.grey[200],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 enabled: true,
//                 controller: passwordController,
//                 obscureText: true,
//                 cursorColor: Colors.grey,
//                 decoration: InputDecoration(
//                   hintText: 'Password',
//                   filled: true,
//                   fillColor: Colors.grey[200],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//                 ),
//               ),
//               SizedBox(height: 24),
//               Container(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     _login();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color.fromARGB(255, 23, 96, 232),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     'Login',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
