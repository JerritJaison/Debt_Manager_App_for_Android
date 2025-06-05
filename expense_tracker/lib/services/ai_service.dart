import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/debt.dart';

class AiService {
  static const String _apiKey = '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'; // Replace with your GROQ API key
  static const String _url = 'https://api.groq.com/openai/v1/chat/completions';

  static Future<List<String>> fetchAiTips(List<Debt> debts) async {
    if (debts.isEmpty) return ['No debts to analyze.'];

    final debtData = debts
        .map((d) =>
            '- ${d.title}: ₹${d.totalAmount.toStringAsFixed(2)}, Category: ${d.category}')
        .join('\n');

    final prompt = '''
You are a financial assistant. The following are the user's current debts:

$debtData

Provide 3 smart, practical financial tips to help them manage or reduce these debts effectively.
''';

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        "model": "llama3-8b-8192", // or "gpt-3.5-turbo" depending on availability
        "messages": [
          {
            "role": "system",
            "content": "You are a helpful financial assistant."
          },
          {
            "role": "user",
            "content": prompt
          }
        ],
        "temperature": 0.7,
        "max_tokens": 500,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices']?[0]?['message']?['content'];

      if (content is! String || content.trim().isEmpty) {
        return ['AI returned no suggestions.'];
      }

      return content
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();
    } else {
      print('GROQ API Error: ${response.statusCode}');
      print('Response: ${response.body}');
      return ['Failed to fetch AI suggestions. Try again later.'];
    }
  }
}
