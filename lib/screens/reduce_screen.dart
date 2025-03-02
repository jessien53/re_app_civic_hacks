import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:re/screens/primary_screen.dart';
import 'user.dart';

User user = User();

class Event {
  final String id;
  final String title;
  final String description;
  final String startDate;
  bool isConfirmed;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    this.isConfirmed = false,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description Available',
      startDate: json['date'] ?? 'Unknown Date',
    );
  }
}

class ReduceScreen extends StatefulWidget {
  const ReduceScreen({super.key});

  @override
  _ReduceScreenState createState() => _ReduceScreenState();
}

class _ReduceScreenState extends State<ReduceScreen> {
  late Future<List<Event>> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = fetchSustainabilityEvents();
  }

  Future<List<Event>> fetchSustainabilityEvents() async {
    final String apiKey = dotenv.get('GEMINI_API_KEY');
    final String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/';
    final String model = 'gemini-2.0-flash';
    final String url = '$baseUrl$model:generateContent?key=$apiKey';

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": "Provide a valid JSON array of 15 upcoming sustainability events in 2025. "
                  "Ensure the response is a valid JSON array without markdown formatting. Each event must include 'id', 'title', 'description', and 'date'."
            }
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.7,
        "topK": 40,
        "topP": 0.8,
        "maxOutputTokens": 1024
      }
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['candidates'] == null || data['candidates'].isEmpty) {
          throw Exception("No candidates returned from API.");
        }

        String generatedText = data['candidates'][0]['content']['parts'][0]['text'].trim();
        generatedText = generatedText.replaceAll(RegExp(r'```json|```'), '').trim();

        // Extract only valid JSON array
        final startIndex = generatedText.indexOf('[');
        final endIndex = generatedText.lastIndexOf(']');
        if (startIndex != -1 && endIndex != -1) {
          generatedText = generatedText.substring(startIndex, endIndex + 1);
        } else {
          throw Exception("Invalid JSON structure in AI response. Could not extract valid array.");
        }

        try {
          final jsonObject = jsonDecode(generatedText);
          if (jsonObject is List) {
            return jsonObject.map((event) => Event.fromJson(event)).toList();
          } else {
            throw Exception("Unexpected JSON format. Expected an array but received a different structure.");
          }
        } catch (e) {
          throw Exception("Invalid JSON format from AI response: $e \nRaw Response: $generatedText");
        }
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sustainability Events'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events available.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final event = snapshot.data![index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  leading: Icon(
                    Icons.circle,
                    color: event.isConfirmed ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  title: Text(
                    event.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    event.startDate,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      user.addPoints(10);
                      setState(() {
                        event.isConfirmed = !event.isConfirmed;
                      });
                    },
                    child: Text(event.isConfirmed ? "Confirmed" : "Confirm"),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        color: Colors.green,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PrimaryScreen()),
            ); // Return to previous screen
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "Home",
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
