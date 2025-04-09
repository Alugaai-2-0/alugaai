// lib/services/http_interceptor.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'auth_service.dart';

class AuthenticatedHttpClient {
  final http.Client _inner = http.Client();
  final AuthService _authService;

  AuthenticatedHttpClient(this._authService);

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return _inner.get(
      url,
      headers: _addAuthHeader(headers),
    );
  }

  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return _inner.post(
      url,
      headers: _addAuthHeader(headers),
      body: body,
      encoding: encoding,
    );
  }

  // Add other methods like put, delete as needed

  Map<String, String> _addAuthHeader(Map<String, String>? headers) {
    final Map<String, String> authHeaders = headers ?? {};
    final token = _authService.getToken();

    if (token != null) {
      authHeaders['Authorization'] = 'Bearer $token';
    }

    return authHeaders;
  }

  void close() {
    _inner.close();
  }
}