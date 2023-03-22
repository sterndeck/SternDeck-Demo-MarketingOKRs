import 'package:http/http.dart' as http;
import 'dart:convert';
import './api_keys.dart';
import './api.dart';

class APIService {
  APIService(this.api);
  final API api;

  String sterndeckKey = APIKeys.sterndeckKey;
  Future<String> getCompletion(String prompt, String model) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $sterndeckKey',
      },
      body: jsonEncode(<String, dynamic>{
        'prompt': prompt + '##>>',
        'model': model,
        'max_tokens': 60,
        'temperature': 1,
        'frequency_penalty': 1.4,
        'presence_penalty': 1.4,
        'stop': '<<##'
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final completion = data['choices'];
      if (completion[0] != null) {
        return completion[0]['text'];
      }
    }
    throw Exception('Failed to fetch bottom completion');
  }
}
