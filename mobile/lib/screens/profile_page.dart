import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile/models/login_response.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/app_bar_controller.dart';
import 'package:provider/provider.dart';
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
    _setCustomAppBar();
  }

  void _setCustomAppBar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppBarController>(context, listen: false).setAppBar(
        AppBar(
          title: Text('Meu perfil', style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ), ),
        ),
      );
    });
  }

  Future<void> _loadUserData() async {
    try {
      setState(() => _isLoading = true);

      var user = _authService.userLogged.value;
      if (user == null) {
        await _authService.debugPrintStoredUser();
        user = _authService.userLogged.value;
      }

      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error loading user data: $e');
    }
  }

  Future<void> _handleLogout() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await _authService.logout();
      Navigator.pop(context);
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer logout: $e')),
      );
    }
  }

  @override
  void dispose() {
    Provider.of<AppBarController>(context, listen: false).resetToDefault();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isCurrentPage = ModalRoute.of(context)?.isCurrent ?? false;
    if (isCurrentPage) {
      _setCustomAppBar();
    } else {
      Provider.of<AppBarController>(context, listen: false).resetToDefault();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // REMOVED THE DUPLICATE APP BAR DECLARATION HERE
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile header
              Row(
                children: [
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentUser?.userName ?? 'Usuário',
                          style: const TextStyle(
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
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 120,
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryOrangeColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
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
              const SizedBox(height: 24),

              // Menu items - ADMIN ITEM SHOWS ONLY FOR ADMIN
              if (_currentUser?.email == "admin@alugaai.com")
                _buildMenuItem(Icons.admin_panel_settings, 'Admin Panel', onTap: () {
                  // Para fechar o drawer/menu antes de navegar (se aplicável)

                  // Navegar para a tela admin
                  Navigator.pushNamed(context, '/admin');

                  // Alternativa: se quiser substituir a tela atual pela tela admin
                  // Navigator.pushReplacementNamed(context, '/admin');
                }),
              _buildMenuItem(Icons.supervised_user_circle_rounded, 'Conexões', onTap: (){
                Navigator.pushNamed(context, '/connections');
              }),
              _buildMenuItem(Icons.privacy_tip_rounded, 'Privacidade'),
              const Divider(thickness: 2, height: 20, color: AppColors.primaryTextColor),

              _buildMenuItem(Icons.notifications_rounded, 'Notificações'),
              _buildMenuItem(Icons.account_circle_rounded, 'Preferências'),
              _buildMenuItem(Icons.visibility_rounded, 'Visibilidade'),
              _buildMenuItem(Icons.settings_rounded, 'Configurações'),
              const Divider(thickness: 2, height: 20, color: AppColors.primaryTextColor),

              _buildMenuItem(Icons.delete_outline, 'Placeholder'),
              _buildMenuItem(Icons.history, 'Placeholder'),
              _buildMenuItem(
                Icons.logout,
                'Sair',
                isDestructive: true,
                onTap: _handleLogout,
              ),
              const Divider(thickness: 2, height: 20, color: AppColors.primaryTextColor),
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
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDestructive ? Colors.red : Colors.black,
                ),
              ),
            ),
            if (!isDestructive) const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}