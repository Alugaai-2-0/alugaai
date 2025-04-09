// lib/services/auth_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthService {
  // Replace with your actual API URL
  final String baseUrl = 'https://your-api-url.com/api/';
  final String userKey = 'user';

  // Create a stream controller to broadcast login state changes
  final ValueNotifier<LoginResponse?> _userLogged = ValueNotifier<LoginResponse?>(null);

  AuthService() {
    _loadStoredUser();
  }

  // Load user from local storage on initialization
  Future<void> _loadStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString(userKey);

    if (storedUser != null) {
      _userLogged.value = LoginResponse.fromJson(jsonDecode(storedUser));
    }
  }

  ValueNotifier<LoginResponse?> get userLogged => _userLogged;

  // Login method
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final response = await http.post(
      Uri.parse('${baseUrl}auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginRequest.toJson()),
    );

    if (response.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));

      // Store user data in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(userKey, jsonEncode(loginResponse.toJson()));

      // Update the stream with the new user
      _userLogged.value = loginResponse;

      return loginResponse;
    } else {
      // Parse error message if available
      Map<String, dynamic> errorResponse = jsonDecode(response.body);
      String errorMessage = errorResponse['message'] ?? 'Failed to login';
      throw Exception(errorMessage);
    }
  }

  void logout() async {
    _userLogged.value = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }

  bool isLoggedIn() {
    return _userLogged.value != null;
  }

  String? getToken() {
    return _userLogged.value?.token;
  }
}