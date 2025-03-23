import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Placeholder for the profile images
              Image.asset('lib/assets/images/login/imageLogin1.png', scale: 1.2,),
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
              TextField(
                decoration: InputDecoration(
                  hintText: 'nandosoares@gmail.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              SizedBox(height: 4,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Senha',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 4),
              TextField(
                decoration: InputDecoration(
                  hintText: '********',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Continuar', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: Text('Criar conta', style: TextStyle(fontSize: 14, color: Colors.orange)),
              ),
              SizedBox(height: 12),
              Text('ou', style: TextStyle(color: Colors.grey[600])),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {},
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
                onPressed: () {},
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
    );
  }
}
