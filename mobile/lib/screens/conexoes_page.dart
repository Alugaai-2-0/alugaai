import 'package:flutter/material.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/services/connections_service.dart';
import 'package:mobile/models/connections_model.dart';

class ConexoesPage extends StatefulWidget {
  const ConexoesPage({Key? key}) : super(key: key);

  @override
  State<ConexoesPage> createState() => _ConexoesPageState();
}

class _ConexoesPageState extends State<ConexoesPage> {
  final ConnectionsService _connectionsService = ConnectionsService();
  List<ConnectionModel> _connections = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _retryCount = 0;
  final int _maxRetries = 2;

  @override
  void initState() {
    super.initState();
    _fetchConnections();
  }

  Future<void> _fetchConnections() async {
    if (!mounted) return;

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final connections = await _connectionsService.fetchMyConnections();

      if (!mounted) return;

      setState(() {
        _connections = connections.where((connection) =>
        connection.status == 'ACCEPTED').toList();
        _isLoading = false;
        _retryCount = 0; // Reset retry count on success
      });
    } catch (e) {
      if (!mounted) return;

      // If we've tried less than maxRetries times and got a 403 error, retry automatically
      if (_retryCount < _maxRetries && e.toString().contains('403')) {
        setState(() {
          _retryCount++;
        });

        // Wait a moment before retrying
        await Future.delayed(Duration(seconds: 1));
        return _fetchConnections();
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Falha ao carregar conexões: ${e.toString()}';
      });
    }
  }

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
      body: RefreshIndicator(
        onRefresh: _fetchConnections,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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

                // Loading, Error or Connections List
                if (_isLoading)
                  Container(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryOrangeColor),
                          ),
                          SizedBox(height: 16),
                          Text(
                            _retryCount > 0
                                ? 'Tentando novamente (${_retryCount}/${_maxRetries})...'
                                : 'Carregando conexões...',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (_errorMessage.isNotEmpty)
                  Container(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchConnections,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryOrangeColor,
                            ),
                            child: Text('Tentar novamente'),
                          )
                        ],
                      ),
                    ),
                  )
                else if (_connections.isEmpty)
                    Container(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              color: Colors.grey[400],
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Nenhuma conexão encontrada',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
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
      ),
    );
  }

  Widget _buildConnectionItem(ConnectionModel connection) {
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
                // Name
                Text(
                  connection.studentName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
                        // TODO: Navigate to profile view with studentId
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) => StudentProfilePage(studentId: connection.studentId),
                        // ));
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