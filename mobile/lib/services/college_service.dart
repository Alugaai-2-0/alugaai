// college_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/models/college_model.dart';


class CollegeService {
  // Replace with your actual API base URL
  final String baseUrl = 'http://10.0.2.2:8080';

  // Fetch all colleges
  Future<List<College>> fetchColleges() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/college'),
        headers: {
          'Content-Type': 'application/json',
          // Add any authentication headers if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => College.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load colleges: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching colleges: $e');
    }
  }

  // Fetch a specific college by ID
  Future<College> fetchCollegeById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/college/$id'),
        headers: {
          'Content-Type': 'application/json',
          // Add any authentication headers if needed
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return College.fromJson(data);
      } else {
        throw Exception('Failed to load college with ID $id: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching college with ID $id: $e');
    }
  }

  // Fetch colleges within a certain radius of a location
  Future<List<College>> fetchCollegesByLocation(double latitude, double longitude, double radiusKm) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/colleges/nearby?lat=$latitude&lng=$longitude&radius=$radiusKm'),
        headers: {
          'Content-Type': 'application/json',
          // Add any authentication headers if needed
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => College.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load nearby colleges: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching nearby colleges: $e');
    }
  }
}