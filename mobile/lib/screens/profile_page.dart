import 'package:flutter/material.dart';
import 'package:mobile/models/login_response.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/utils/Colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  LoginResponse? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _authService.userLogged.value;
    setState(() {
      _currentUser = user;
    });
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
      body: SingleChildScrollView(
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
                          _currentUser?.userName ?? 'Loading...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _currentUser?.email ?? 'loading...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        // Smaller edit profile button aligned with email
                        SizedBox(
                          width: 120, // Reduced width
                          height: 32,  // Reduced height
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
              Divider(thickness: 2, height: 20, color: AppColors.primaryTextColor,), // Divider after Downloads

              _buildMenuItem(Icons.language, 'Idiomasa'),
              _buildMenuItem(Icons.location_on_outlined, 'Localização'),
              _buildMenuItem(Icons.card_membership_outlined, 'Plano'),
              _buildMenuItem(Icons.desktop_windows_outlined, 'Exibir'),
              Divider(thickness: 2, height: 20, color: AppColors.primaryTextColor,), // Divider after Display

              _buildMenuItem(Icons.delete_outline, 'Limpar Cache'),
              _buildMenuItem(Icons.history, 'Limpar Histórico'),
              _buildMenuItem(Icons.logout, 'Sair', isDestructive: true),
              Divider(thickness: 2, height: 20, color: AppColors.primaryTextColor,), // Divider after Log Out
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: () {},
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

          ],
        ),
      ),
    );
  }
}