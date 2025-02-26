import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class GeminiService {
  final String _apiKey;
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/';
  final String _model = 'gemini-2.0-flash';

  GeminiService() : _apiKey = dotenv.get('GEMINI_API_KEY');

  Future<String> generateQuestion(String topic, {bool isYesNo = false}) async {
    final url = '$_baseUrl$_model:generateContent?key=$_apiKey';

    final headers = {'Content-Type': 'application/json'};

    // Define the prompts for reuse and recycle questions
    final reuse_prompt =
    '''Generate a trivia question about $topic with 4 multiple choice options and the correct answer. 
    Format the response EXACTLY like this example, including the curly braces:
    {
      "question": "Which of these is a common reusable alternative to plastic bags?",
      "options": ["Canvas tote bag", "Paper airplane", "Plastic wrapper", "Disposable container"],
      "correctAnswer": "Canvas tote bag"
    }''';

    final recycle_prompt =
    '''Generate a trivia question about $topic with 2 options for a Yes/No or True/False question, and the correct answer. 
    Format the response EXACTLY like this example, including the curly braces:
    {
      "question": "Is recycling paper better for the environment than throwing it away?",
      "options": ["Yes", "No"],
      "correctAnswer": "Yes"
    }''';

    // Choose the appropriate prompt
    final prompt = isYesNo ? recycle_prompt : reuse_prompt;

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
      "generationConfig": {
        "temperature": 0.7,
        "topK": 40,
        "topP": 0.8,
        "maxOutputTokens": 1024,
      },
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String generatedText =
        data['candidates'][0]['content']['parts'][0]['text'];

        // Clean up the response to ensure valid JSON
        generatedText = generatedText.trim();

        // If the response contains multiple JSON objects or extra text, extract just the JSON object
        final startBrace = generatedText.indexOf('{');
        final endBrace = generatedText.lastIndexOf('}');
        if (startBrace >= 0 && endBrace >= 0) {
          generatedText = generatedText.substring(startBrace, endBrace + 1);
        }

        // Verify the JSON is valid
        try {
          final jsonObject = jsonDecode(generatedText);
          if (jsonObject['question'] != null &&
              jsonObject['options'] != null &&
              jsonObject['correctAnswer'] != null) {
            return generatedText;
          } else {
            throw FormatException('Missing required fields in JSON response');
          }
        } catch (e) {
          throw FormatException('Invalid JSON format in response');
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
        throw Exception('Failed to generate question');
      }
    } catch (e) {
      print('Error generating question: $e');
      throw Exception('Failed to generate question: $e');
    }
  }


  Future<String> imageToBase64(String assetPath) async {
    // Read the bytes directly from the asset
    final bytes = await rootBundle.load(assetPath);
    final Uint8List uint8List = bytes.buffer.asUint8List();
    // Convert to base64
    return base64Encode(uint8List);
  }

  Future<String> is_recyclable(String assetPath, {bool isYesNo = false}) async {
    final url = '$_baseUrl$_model:generateContent?key=$_apiKey';
    final headers = {'Content-Type': 'application/json'};

    // Convert asset image to base64
    final String base64Image = await imageToBase64(assetPath);

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": "Is this item recyclable? Please respond with only Yes or No."},
            {
              "inlineData": {
                "mimeType": "image/jpeg",
                "data": base64Image
              }
            }
          ],
        },
      ],
      "generationConfig": {
        "temperature": 0.7,
        "topK": 40,
        "topP": 0.8,
        "maxOutputTokens": 1024,
      },
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String generatedText = data['candidates'][0]['content']['parts'][0]['text'].trim().toLowerCase();

        // Return simple Yes/No response
        if (generatedText.contains('yes')) {
          return 'Yes';
        } else if (generatedText.contains('no')) {
          return 'No';
        } else {
          return 'Unclear';
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
        throw Exception('Failed to analyze image');
      }
    } catch (e) {
      print('Error analyzing image: $e');
      throw Exception('Failed to analyze image: $e');
    }
  }
}
