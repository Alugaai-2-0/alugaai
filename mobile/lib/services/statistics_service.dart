import 'dart:convert';
import 'package:mobile/core/config.dart';
import 'package:mobile/models/dashboard_stats.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/http_interceptor.dart';// Import your authenticated client

class StatisticsService {
  final String baseUrl = '${EnvironmentConfig.baseUrl}';
  final AuthService _authService = AuthService();
  late final AuthenticatedHttpClient _client;

  // Constructor that initializes the authenticated client
  StatisticsService() {
    _client = AuthenticatedHttpClient(_authService);
  }

  // Get total students
  Future<int> getTotalStudents() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/statistics/getAllStudents'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['totalStudents'] ?? 0;
      } else {
        print('Failed to load total students. Status code: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error fetching total students: $e');
      return 0;
    }
  }

  // Get total properties
  Future<int> getTotalProperties() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/statistics/getAllProperties'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['totalProperties'] ?? 0;
      } else {
        print('Failed to load total properties. Status code: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error fetching total properties: $e');
      return 0;
    }
  }

  // Get total owners
  Future<int> getTotalOwners() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/statistics/getAllOwners'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['totalOwners'] ?? 0;
      } else {
        print('Failed to load total owners. Status code: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error fetching total owners: $e');
      return 0;
    }
  }

  // Get monthly rent
  Future<double> getMonthlyRent() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/statistics/getAllMonthlyRent'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['totalMonthlyRent'] ?? 0).toDouble();
      } else {
        print('Failed to load monthly rent. Status code: ${response.statusCode}');
        return 0.0;
      }
    } catch (e) {
      print('Error fetching monthly rent: $e');
      return 0.0;
    }
  }

  // Get all dashboard statistics at once
  Future<DashboardStats> getAllDashboardStats() async {
    try {
      final students = await getTotalStudents();
      final properties = await getTotalProperties();
      final owners = await getTotalOwners();
      final monthlyRent = await getMonthlyRent();

      return DashboardStats(
        totalStudents: students,
        totalProperties: properties,
        totalOwners: owners,
        monthlyRent: monthlyRent,
      );
    } catch (e) {
      print('Error fetching all dashboard statistics: $e');
      return DashboardStats.empty();
    }
  }

  // Don't forget to close the client when done
  void dispose() {
    _client.close();
  }
}