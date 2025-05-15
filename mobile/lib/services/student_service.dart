import 'dart:convert';

import 'package:mobile/core/config.dart';
import 'package:mobile/models/student_model.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/http_interceptor.dart';

class StudentService {
  final String baseUrl = '${EnvironmentConfig.baseUrl}';
  final AuthService _authService = AuthService();
  late final AuthenticatedHttpClient _client;
  bool _isInitialized = false;

  StudentService() {
    _client = AuthenticatedHttpClient(_authService);
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Ensure the auth token is loaded/refreshed
      await _authService.getToken();
      _isInitialized = true;
    } catch (e) {
      print('Failed to initialize ConnectionsService: $e');
    }
  }

  Future<List<Student>> fetchStudents({
    int? maxAge,
    Set<String>? personalities,
  }) async {
    try {
      if (!_isInitialized) {
        await _initialize();
      }

      // Construct query parameters
      final queryParams = <String, dynamic>{};

      // Add maxAge to query parameters if provided
      if (maxAge != null) {
        queryParams['maxAge'] = maxAge.toString();
      }

      // Add personalities to query parameters if provided
      if (personalities != null && personalities.isNotEmpty) {
        queryParams['personalities'] = personalities.toList();
      }

      // Construct the URI with query parameters
      final uri = Uri.parse('$baseUrl/student/get-all').replace(
        queryParameters: queryParams.map((key, value) => MapEntry(key,
            value is List ? value.map((e) => e.toString()).toList() : [value.toString()]
        )),
      );

      // Use the authenticated client instead of the regular http client
      final response = await _client.get(
        uri,
        headers: {'Accept-Charset': 'utf-8'},
      );

      if (response.statusCode == 200) {
        // Explicitly decode the body as UTF-8
        final String responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(responseBody);
        return data.map((json) => Student.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching students: $e');
    }
  }
}