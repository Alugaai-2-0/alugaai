import 'dart:convert';
import 'package:http/http.dart' as http;

/// Sends a message to the Python Flask chatbot server and returns the response
Future<String> fetchChatbotReply(String message) async {
  // For Android emulator, use 10.0.2.2 to access the host machine
  const endpoint = 'http://10.0.2.2:5000/chat'; // For Android emulator
  // const endpoint = 'http://127.0.0.1:5000/chat'; // For iOS simulator
  // If running on a physical device, use your computer's local IP address
  // const endpoint = 'http://192.168.1.XXX:5000/chat'; // Replace with your actual IP

  final headers = {
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'message': message,
  });

  try {
    final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: body
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Check if 'reply' exists in the response and is not null
      if (data != null && data['reply'] != null) {
        return data['reply']; // Changed from 'response' to 'reply' to match Flask API
      } else {
        // Return a default message if the server response doesn't contain a reply
        print('Warning: Server response is missing "reply" field: ${response.body}');
        return "Desculpe, ocorreu um erro na comunicação com o servidor.";
      }
    } else if (response.statusCode == 503 || response.statusCode == 502) {
      throw Exception('service_unavailable');
    } else {
      print('Failed to fetch chatbot reply: ${response.statusCode} - ${response.body}');
      throw Exception('server_error_${response.statusCode}');
    }
  } catch (e) {
    print('Error connecting to chatbot server: $e');
    // Always throw an exception, don't return null
    throw e;
  }
}