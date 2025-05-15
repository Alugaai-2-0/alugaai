import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/core/config.dart';
import 'package:mobile/models/student_model.dart';
class StudentService {
  final String baseUrl = '${EnvironmentConfig.baseUrl}';

  Future<List<Student>> fetchStudents({
    int? maxAge,
    Set<String>? personalities,
  }) async {
    try {
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

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
          // Add any authentication headers if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Student.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching students: $e');
    }
  }
}