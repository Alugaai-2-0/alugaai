import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/login_response.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  LoginResponse? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // First check if userLogged.value is already available
      var user = _authService.userLogged.value;

      // If not, we'll manually try to load it from SharedPreferences
      if (user == null) {
        // Call a method to explicitly load and wait for the user data
        await _authService.debugPrintStoredUser(); // This will print debug info

        // Try to access the user again after loading
        user = _authService.userLogged.value;

        // If still null, we need to add a method to force loading

      }

      setState(() {
        _currentUser = user;
        print('User on setState: $user');
        if (user != null) {
          print('User name: ${user.userName}, Email: ${user.email}');
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Handle logout
  Future<void> _handleLogout() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      // Call logout from auth service
      await _authService.logout();

      // Close the loading dialog
      Navigator.pop(context);

      // Navigate to login screen and clear navigation stack
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } catch (e) {
      // Close the loading dialog
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu perfil'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile header with avatar and name
              Row(
                children: [
                  // Placeholder circle for profile photo
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(width: 16),
                  // User info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentUser?.userName ?? 'Usuário',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _currentUser?.email ?? 'email@example.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        // Smaller edit profile button aligned with email
                        SizedBox(
                          width: 120, // Reduced width
                          height: 32, // Reduced height
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryOrangeColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.zero, // Remove default padding
                            ),
                            child: Text(
                              'Editar perfil',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Menu items
              _buildMenuItem(Icons.favorite_outline, 'Favoritos'),
              _buildMenuItem(Icons.download_outlined, 'Downloads'),
              Divider(thickness: 2, height: 20, color: AppColors.primaryTextColor),

              _buildMenuItem(Icons.language, 'Idiomas'),
              _buildMenuItem(Icons.location_on_outlined, 'Localização'),
              _buildMenuItem(Icons.card_membership_outlined, 'Plano'),
              _buildMenuItem(Icons.desktop_windows_outlined, 'Exibir'),
              Divider(thickness: 2, height: 20, color: AppColors.primaryTextColor),

              _buildMenuItem(Icons.delete_outline, 'Limpar Cache'),
              _buildMenuItem(Icons.history, 'Limpar Histórico'),
              _buildMenuItem(
                Icons.logout,
                'Sair',
                isDestructive: true,
                onTap: _handleLogout,
              ),
              Divider(thickness: 2, height: 20, color: AppColors.primaryTextColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isDestructive = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.black,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDestructive ? Colors.red : Colors.black,
                ),
              ),
            ),
            if (!isDestructive) Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}