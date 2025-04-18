// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_1/home_page.dart';
// import 'package:aplikasi_1/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermission();
  await dotenv.load();
  runApp(const MainApp());
}

Future<void> requestLocationPermission() async {
  // Using permission_handler
  if (await Permission.location.request().isGranted) {
    print("Location permission granted.");
  } else {
    print("Location permission denied.");
  }

  // Optionally check service enabled too
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print("Location services are disabled.");
  }
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  print(position.latitude);
  print(position.longitude);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('latitude', position.latitude);
  await prefs.setDouble('longitude', position.longitude);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 245, 245, 245),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Color.fromARGB(255, 255, 255, 255)),
          // primaryColor: Color.fromARGB(255, 23, 96, 232),
          // colorScheme: ColorScheme.fromSwatch().copyWith(
          //   secondary: Color.fromARGB(255, 255, 255, 255),
          //   tertiary: Color.fromARGB(255, 82, 89, 105),
          // ),

          // textTheme: GoogleFonts.aBeeZeeTextTheme(),
          textTheme: TextTheme(
            bodyMedium: TextStyle(fontSize: 16),
          )),
      debugShowCheckedModeBanner: false,
      // home: SafeArea(child: LoginPage()),
      // home: SafeArea(child: HomePage()),
      home: SafeArea(child: Navbar()),
    );
  }
}

class Navbar extends StatefulWidget {
  final chosenIndex;
  const Navbar({super.key, this.chosenIndex});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  Color buttonColor = Color.fromARGB(255, 23, 96, 232);

  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    PesananPage(),
    SelesaiPage(),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.chosenIndex != null) {
      _selectedIndex = widget.chosenIndex;
    } else {
      _selectedIndex = 0;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 32,
            ),
            label: 'Utama',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.fire_truck_outlined,
              size: 32,
            ),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history_rounded,
              size: 32,
            ),
            label: 'Selesai',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: buttonColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
