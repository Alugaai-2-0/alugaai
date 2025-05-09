import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/student_model.dart';
class StudentService{
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<List<Student>> fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student/get-all'),
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