// property_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/core/config.dart';
import 'package:mobile/models/property_model.dart';

class PropertyService {
  // Replace with your actual API base URL
  final String baseUrl = '${EnvironmentConfig.baseUrl}';

  // Fetch all properties
  Future<List<Property>> fetchProperties() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/property'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
          // Add any authentication headers if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Property.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load properties: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching properties: $e');
    }
  }

  // Fetch a specific property by ID
  Future<Property> fetchPropertyById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/properties/$id'),
        headers: {
          'Content-Type': 'application/json',
          // Add any authentication headers if needed
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Property.fromJson(data);
      } else {
        throw Exception('Failed to load property with ID $id: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching property with ID $id: $e');
    }
  }




  // Fetch properties by owner ID
  Future<List<Property>> fetchPropertiesByOwnerId(int ownerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/properties/owner/$ownerId'),
        headers: {
          'Content-Type': 'application/json',
          // Add any authentication headers if needed
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Property.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load properties for owner $ownerId: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching properties for owner $ownerId: $e');
    }
  }



}