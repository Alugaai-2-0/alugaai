import 'package:flutter/material.dart';
import 'package:mobile/screens/home_page.dart';
import 'package:mobile/screens/login_page.dart';
import 'package:mobile/screens/profile_page.dart';
import 'package:mobile/screens/search_page.dart';
import 'package:mobile/utils/Colors.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryOrangeColor, // Your primary color
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // This list holds the widgets for each tab
  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const LoginPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top AppBar with logo and menu
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title:  Row(
          children: [
            Image.asset(
              'lib/assets/images/alugaai_logo.jpg',
              height: 40, // Adjust height as needed
              fit: BoxFit.contain,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Handle menu button press
            },
          ),
        ],
      ),

      // Main content area
      body: _pages[_selectedIndex],

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryOrangeColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

//HOME PAGE