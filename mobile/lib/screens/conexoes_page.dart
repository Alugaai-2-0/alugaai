import 'package:flutter/material.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/app_bar_controller.dart';
import 'package:provider/provider.dart';

// Mock connection data model
class ConnectionData {
  final String name;
  final int age;
  final String college;
  final String description;
  final String photoUrl;

  ConnectionData({
    required this.name,
    required this.age,
    required this.college,
    required this.description,
    required this.photoUrl,
  });
}

class ConexoesPage extends StatefulWidget {
  const ConexoesPage({Key? key}) : super(key: key);

  @override
  State<ConexoesPage> createState() => _ConexoesPageState();
}

class _ConexoesPageState extends State<ConexoesPage> {
  // Mock list of connections
  final List<ConnectionData> _connections = [
    ConnectionData(
      name: 'Abdiel Athayde',
      age: 28,
      college: 'Universidade Federal de São Carlos',
      description: 'Desenvolvedor Backend apaixonado por tecnologia e soluções inovadoras.',
      photoUrl: '',
    ),
    ConnectionData(
      name: 'Gabriel Lima da Silva',
      age: 32,
      college: 'Instituto Tecnológico de Computação',
      description: 'Especialista em Cloud e Python, buscando sempre aprender e crescer.',
      photoUrl: '',
    ),
    ConnectionData(
      name: 'Gabriel Alberto de Oliveira',
      age: 25,
      college: 'Centro Universitário de Tecnologia',
      description: 'Auxiliar de sistemas com foco em análise e desenvolvimento.',
      photoUrl: '',
    ),
    ConnectionData(
      name: 'Raphael Okuyama',
      age: 30,
      college: 'Universidade de São Paulo',
      description: 'Desenvolvedor Full-Stack com experiência em múltiplas tecnologias.',
      photoUrl: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryOrangeColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Conexões',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search and Filter Section
              TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar conexões',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),

              // Connections Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_connections.length} Conexões',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement sorting
                    },
                    child: const Text('Classificar por'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Connections List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _connections.length,
                itemBuilder: (context, index) {
                  return _buildConnectionItem(_connections[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionItem(ConnectionData connection) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
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

          // Connection Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Age
                Text(
                  '${connection.name} - ${connection.age}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // College
                Text(
                  connection.college,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),

                // Description
                Text(
                  connection.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),

                // Action Buttons
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement message functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrangeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text(
                        'Mensagem',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Implement profile view functionality
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: AppColors.primaryOrangeColor),
                      ),
                      child: Text(
                        'Ver Perfil',
                        style: TextStyle(
                          color: AppColors.primaryOrangeColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}