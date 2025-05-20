import 'dart:convert';
import 'package:http/http.dart' as http;

/// Sends a message to the Python Flask chatbot server and returns the response
Future<String> fetchChatbotReply(String message) async {
  // Your Flask server URL - change this to match your server's address
  // If running on the same device during development, use your local IP instead of localhost
  const endpoint = 'http://10.0.2.2:5000/chat'; // For Android emulator
  // const endpoint = 'http://localhost:5000/chat'; // For iOS simulator or web

  final headers = {
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'message': message,
  });

  try {
    // Note: We're not setting a timeout here, we'll handle it in the calling method
    final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: body
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'];
    } else if (response.statusCode == 503 || response.statusCode == 502) {
      throw Exception('service_unavailable');
    } else {
      print('Failed to fetch chatbot reply: ${response.statusCode} - ${response.body}');
      throw Exception('server_error_${response.statusCode}');
    }
  } catch (e) {
    print('Error connecting to chatbot server: $e');
    // Let the calling code handle the specific error
    throw e;
  }
}