import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String _apiKey = 'AIzaSyBI0We1YJCfqYOXV_jukqu2CEVG98m2f2I'; // Replace with your real key
  final String _url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  Future<String> suggestCategory(String description) async {
    final uri = Uri.parse('$_url?key=$_apiKey');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text":
                    "Suggest a category for this expense description: \"$description\". Return only the category like Food, Travel, Entertainment, etc."
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'].trim();
    } else {
      throw Exception("Failed to get response from Gemini API: ${response.body}");
    }
  }
}
