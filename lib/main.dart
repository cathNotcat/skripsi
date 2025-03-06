// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:web_admin_1/dashboard_page.dart';
import 'package:web_admin_1/login_page.dart';
import 'package:web_admin_1/pengiriman_page.dart';

void main() {
  runApp(const MainApp());
}

// text: Color.fromARGB(255,82, 89, 105)
// primary: Color.fromARGB(255, 23, 96, 232)
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 245, 245, 245),
        ),
        home: SafeArea(
          // child: Navbar(),
          child: LoginPage(),
        ));
  }
}

class Navbar extends StatefulWidget {
  final int? chosenIndex;
  const Navbar({super.key, this.chosenIndex});
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  // int selectedIndex = 0;
  late int selectedIndex;

  final List<Widget> pages = [
    DashboardPage(),
    PengirimanPage(),
    TambahPesananPage(),
    SupirProsesPage(),
    LoginPage(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize selectedIndex based on chosenIndex or default to 0
    selectedIndex = widget.chosenIndex ?? 0;
  }

  void onSidebarItemClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => Navbar(chosenIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Logo Section
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'LOGO',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                SizedBox(height: 40),
                // Sidebar Menu
                SidebarItem(
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  isSelected: selectedIndex == 0,
                  // onTap: () {
                  //   setState(() {
                  //     selectedIndex = 0;
                  //   });
                  // },
                  onTap: () => onSidebarItemClicked(0),
                ),
                SizedBox(height: 16),
                SidebarItem(
                  icon: Icons.local_shipping_outlined,
                  title: 'Pengiriman',
                  isSelected: selectedIndex == 1,
                  // onTap: () {
                  //   setState(() {
                  //     selectedIndex = 1;
                  //     print('selectedindex: $selectedIndex');
                  //   });
                  // },
                  onTap: () => onSidebarItemClicked(1),
                ),
                SizedBox(height: 16),
                SidebarItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  isSelected: selectedIndex == 2,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                    // setState(() {
                    //   selectedIndex = 2;
                    // });
                  },
                ),
              ],
            ),
          ),
          // Main Content
          // Expanded(
          //   child: pages[selectedIndex],
          // ),
          Expanded(
            child: Navigator(
              onGenerateRoute: (settings) {
                Widget page = pages[selectedIndex];

                if (settings.name == '/supirProses') {
                  page = SupirProsesPage();
                }

                if (settings.name == '/tambahPesanan') {
                  page = TambahPesananPage();
                }

                return MaterialPageRoute(builder: (_) => page);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        // color: isSelected ? Colors.blue.shade100 : Colors.transparent,
        color: Colors.transparent,
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isSelected ? Color.fromARGB(255, 23, 96, 232) : Colors.black,
            ),
            SizedBox(width: 30),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected
                    ? Color.fromARGB(255, 23, 96, 232)
                    : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
