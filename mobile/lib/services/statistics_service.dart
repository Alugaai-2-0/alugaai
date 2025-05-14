// lib/services/statistics_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class StatisticsService {
  final String baseUrl;

  StatisticsService({required this.baseUrl});

  Future<Map<String, dynamic>> fetchAllStatistics() async {
    try {
      // Fetch all statistics in parallel
      final responses = await Future.wait([
        _fetchStatistic('/statistics/getAllStudents'),
        _fetchStatistic('/statistics/getAllProperties'),
        _fetchStatistic('/statistics/getAllOwners'),
        _fetchStatistic('/statistics/getAllMonthlyRent'),
      ]);

      return {
        'totalStudents': responses[0],
        'totalProperties': responses[1],
        'totalOwners': responses[2],
        'monthlyRent': responses[3],
      };
    } catch (e) {
      throw Exception('Failed to load statistics: $e');
    }
  }

  Future<int> _fetchStatistic(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode == 200) {
      // Parse the response body which should be a Long value
      final dynamic data = json.decode(response.body);
      if (data is int) {
        return data;
      } else if (data is String) {
        return int.tryParse(data) ?? 0;
      }
      return 0;
    } else {
      throw Exception('Failed to load $endpoint');
    }
  }
}