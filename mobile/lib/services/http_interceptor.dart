// Enhanced version of AuthenticatedHttpClient
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class AuthenticatedHttpClient {
  final http.Client _inner = http.Client();
  final AuthService _authService;

  AuthenticatedHttpClient(this._authService);

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final authHeaders = _addAuthHeader(headers);

    final response = await _inner.get(url, headers: authHeaders);



    return response;
  }

  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final authHeaders = _addAuthHeader(headers);


    final response = await _inner.post(
      url,
      headers: authHeaders,
      body: body,
      encoding: encoding,
    );



    return response;
  }

  Map<String, String> _addAuthHeader(Map<String, String>? headers) {
    final Map<String, String> authHeaders = headers ?? {};
    final token = _authService.getToken();

    // Ensure content-type is set for all requests
    if (!authHeaders.containsKey('Content-Type')) {
      authHeaders['Content-Type'] = 'application/json';
    }

    if (token != null) {
      // Make sure there's no extra whitespace
      authHeaders['Authorization'] = 'Bearer ${token.trim()}';

    }

    return authHeaders;
  }

  void close() {
    _inner.close();
  }
}