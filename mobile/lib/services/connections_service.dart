import 'dart:convert';
import 'package:mobile/core/config.dart';
import 'package:mobile/models/connections_model.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/http_interceptor.dart';

class ConnectionsService {
  final String baseUrl = '${EnvironmentConfig.baseUrl}';
  final AuthService _authService = AuthService();
  late final AuthenticatedHttpClient _client;

  // Flag to track if initialization has completed
  bool _isInitialized = false;

  ConnectionsService() {
    _client = AuthenticatedHttpClient(_authService);
    _initialize();
  }

  // Initialize the service asynchronously
  Future<void> _initialize() async {
    try {
      // Ensure the auth token is loaded/refreshed
      await _authService.getToken();
      _isInitialized = true;
    } catch (e) {
      print('Failed to initialize ConnectionsService: $e');
    }
  }

  Future<List<ConnectionModel>> fetchMyConnections() async {
    try {
      // If not initialized, wait for initialization to complete
      if (!_isInitialized) {
        await _initialize();
      }

      final uri = Uri.parse('$baseUrl/connections/my-connections');

      // Using authenticated client to handle the request
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ConnectionModel.fromJson(json)).toList();
      } else {
        // If we get a 403, try to refresh the token and try again
        if (response.statusCode == 403) {
          //await _authService.refreshToken();

          // Try the request again after refreshing the token
          final retryResponse = await _client.get(uri);

          if (retryResponse.statusCode == 200) {
            final List<dynamic> data = json.decode(retryResponse.body);
            return data.map((json) => ConnectionModel.fromJson(json)).toList();
          } else {
            throw Exception('Failed to load connections even after token refresh: ${retryResponse.statusCode}');
          }
        }

        throw Exception('Failed to load connections: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching connections: $e');
    }
  }
}