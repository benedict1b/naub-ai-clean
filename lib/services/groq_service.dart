import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqService {
  static const String _apiKey = String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> sendMessage(String message) async {
    if (_apiKey.isEmpty) {
      return "⚠️ API key not configured. Please set GROQ_API_KEY.";
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {'role': 'system', 'content': 'You are NAUB AI, a helpful assistant.'},
            {'role': 'user', 'content': message}
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices']?[0]?['message']?['content'] ?? "No response.";
      }
      return "⚠️ Error ${response.statusCode}.";
    } catch (e) {
      return "⚠️ Connection error.";
    }
  }

  static String getOfflineResponse(String query) {
    final q = query.toLowerCase();
    if (q.contains('gpa')) return 'GPA = Σ(Grade Points × Credit Units) / Σ(Credit Units)';
    if (q.contains('library')) return 'The library is in Block A.';
    if (q.contains('hostel')) return 'No visitors after 10PM.';
    if (q.contains('fee') || q.contains('school')) return 'Science: ₦84,500 | Arts: ₦64,500';
    return "I'm offline. Connect to internet for full answers.";
  }
}
