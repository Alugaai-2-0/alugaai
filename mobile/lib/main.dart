import 'package:flutter/material.dart';
import 'package:mobile/screens/adminDashboard_page.dart';
import 'package:mobile/screens/conexoes_page.dart';
import 'package:mobile/screens/home_page.dart';
import 'package:mobile/screens/login_page.dart';
import 'package:mobile/screens/profile_page.dart';
import 'package:mobile/screens/search_page.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/utils/app_bar_controller.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppBarController(), // Initialize controller
      child: const MyApp(),
    ),
  );
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
        '/profile': (context) => ProfilePage(),
        '/admin': (context) => AdminDashboard(),
        '/connections': (context) => ConexoesPage(),
        // Create a HomePage widget
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
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString('user');
    setState(() => _isLoggedIn = storedUser != null);
  }

  // In _MainScreenState
  void _onItemTapped(int index) {
    final appBarController = Provider.of<AppBarController>(context, listen: false);

    if (index == 2 && !_isLoggedIn) {
      Navigator.pushNamed(context, '/login').then((_) => _checkLoginStatus());
      return;
    }

    // Reset AppBar whenever tabs change
    appBarController.resetToDefault();

    setState(() => _selectedIndex = index);
  }

  List<Widget> get _pages => [
    const HomePage(),
    const SearchPage(),
    _isLoggedIn ? const ProfilePage() : const LoginPage(),
  ];

  // Default AppBar for the main screen
  PreferredSizeWidget _buildDefaultAppBar() {
    return AppBar(
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
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBarController = Provider.of<AppBarController>(context);

    return Scaffold(
      // Dynamic AppBar - uses controller's AppBar or falls back to default
      appBar: appBarController.currentAppBar ?? _buildDefaultAppBar(),

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Procurar',
          ),
          BottomNavigationBarItem(
            icon: _isLoggedIn
                ? Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                border: Border.all(
                  color: _selectedIndex == 2
                      ? AppColors.primaryOrangeColor
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person,
                size: 18,
                color: _selectedIndex == 2
                    ? AppColors.primaryOrangeColor
                    : Colors.grey[600],
              ),
            )
                : const Icon(Icons.person),
            label: _isLoggedIn ? 'Perfil' : 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryOrangeColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
