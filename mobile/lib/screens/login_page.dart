import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Add this package for toast notifications
import '../models/login_request.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEntrarClick() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final loginRequest = LoginRequest(
          identifier: _emailController.text,
          password: _passwordController.text,
        );

        final response = await _authService.login(loginRequest);

        // Show success message
        Fluttertoast.showToast(
          msg: "Logado com sucesso: ${response.userName}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
      } catch (error) {
        // Show error message
        Fluttertoast.showToast(
          msg: "Erro ao fazer login: ${error.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Placeholder for the profile images
                  Image.asset('lib/assets/images/login/imageLogin1.png', scale: 1.2),
                  Text(
                    'Bem-vindo ao Aluga.ai',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explore a plataforma e encontre o colega de quarto ideal para você!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'E-mail',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 4),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'nandosoares@gmail.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor insira seu e-mail';
                      }
                      // Basic email validation
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Insira um e-mail válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Senha',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 4),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: '********',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor insira sua senha';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.orange)
                      : ElevatedButton(
                    onPressed: _onEntrarClick,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Continuar', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // Navigate to registration page
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text('Criar conta', style: TextStyle(fontSize: 14, color: Colors.orange)),
                  ),
                  SizedBox(height: 12),
                  Text('ou', style: TextStyle(color: Colors.grey[600])),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Google login
                    },
                    icon: Icon(Icons.g_mobiledata_sharp, color: Colors.red, size: 50),
                    label: Text('Continuar com o Google', style: TextStyle(fontSize: 16, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Facebook login
                    },
                    icon: Icon(Icons.facebook, color: Colors.blue, size: 30),
                    label: Text('Continuar com o Facebook', style: TextStyle(fontSize: 16, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}