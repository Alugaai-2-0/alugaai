import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchChatbotReply(String message) async {
  const endpoint = 'http://10.0.2.2:5000/chat'; // For Android emulator
  // const endpoint = 'http://127.0.0.1:5000/chat'; // For iOS simulator
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

      if (data != null && data['reply'] != null) {
        return data['reply'];
      } else {

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

    throw e;
  }
}