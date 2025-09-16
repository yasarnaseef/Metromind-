
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import 'dashboard_screen.dart';
import 'order_list_screen.dart';
import 'product_list_screen.dart';
import 'stock_list_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  ThemeMode _themeMode = ThemeMode.system;
  final List<Widget> _screens = [
    const DashboardScreen(),
    const ProductListScreen(),
    const OrderListScreen(),
    const StockListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
      dashboardProvider.loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: _themeMode == ThemeMode.dark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title:  Text('Product Management',style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          )),
          actions: [
            IconButton(
              icon: Icon(_themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => Provider.of<AuthProvider>(context, listen: false).signOut(),
            ),
          ],
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            if (index == 0) {
              final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
              dashboardProvider.loadDashboardData();
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xff2C3F9D).withOpacity(1),
          unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          selectedLabelStyle: GoogleFonts.workSans(
            color: blue2C3F,
            fontSize: width / 34.25,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.workSans(
            color: blue2C3F,
            fontSize: width / 34.25,
            fontWeight: FontWeight.w600,
          ),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard,), label: 'Dashboard',),
            BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Products'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart), label: 'Stock'),
          ],
        ),
      ),
    );
  }
}