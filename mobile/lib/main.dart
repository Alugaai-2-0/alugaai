import 'package:flutter/material.dart';
import 'package:mobile/screens/home_page.dart';
import 'package:mobile/screens/login_page.dart';
import 'package:mobile/screens/profile_page.dart';
import 'package:mobile/screens/search_page.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      routes: {
        '/': (context) => MainScreen(),  // Change this to MainScreen
        '/login': (context) => LoginPage(),
        '/search': (context) => SearchPage(),
        '/profile': (context) => ProfilePage(),// Create a HomePage widget
       // Create a RegisterPage widget if needed
      },
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
  bool _isLoggedIn = false; // Track login status

  @override
  void initState() {
    super.initState();
    // Check if user is logged in
    _checkLoginStatus();
  }

  // Function to check if user is logged in
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString('user');

    setState(() {
      _isLoggedIn = storedUser != null;
    });
  }

  void _onItemTapped(int index) {
    // If user clicks on profile/login tab but is not logged in, redirect to login page
    if (index == 2 && !_isLoggedIn) {
      Navigator.pushNamed(context, '/login').then((_) {
        // After returning from login page, check login status again
        _checkLoginStatus();
      });
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  // Get pages based on login status
  List<Widget> get _pages {
    return [
      const HomePage(),
      const SearchPage(),
      _isLoggedIn ? const ProfilePage() : const LoginPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top AppBar with logo and menu
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Image.asset(
              'lib/assets/images/alugaai_logo.jpg',
              height: 40,
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
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          // Conditionally show person icon or profile picture
          BottomNavigationBarItem(
            icon: _isLoggedIn
                ? Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                border: Border.all(
                  color: _selectedIndex == 2 ? AppColors.primaryOrangeColor : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person,
                size: 18,
                color: _selectedIndex == 2 ? AppColors.primaryOrangeColor : Colors.grey[600],
              ),
            )
                : Icon(Icons.person),
            label: _isLoggedIn ? 'Profile' : 'Login',
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