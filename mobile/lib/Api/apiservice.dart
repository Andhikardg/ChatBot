import 'package:http/http.dart' as http;
import 'dart:convert';

const String _baseUrl = 'http://127.0.0.1:5000/api/chatbot';

Future<String> sendMessageToApi(String message) async {
  try {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'query': message,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['response'];
    } else {
      throw Exception('Failed to send message');
    }
  } catch (error) {
    print('Error occurred: $error');
    throw Exception('Failed to send message');
  }
}
