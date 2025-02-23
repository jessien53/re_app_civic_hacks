import 'package:flutter/material.dart';
import 'user.dart';
import 'primary_screen.dart';

User user = User();

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final List<String> questions = [
    'How often do you bring a reusable bag when shopping?',
    'Do you use a reusable water bottle instead of buying plastic ones?',
    'How frequently do you turn off lights when leaving a room?',
    'Do you unplug electronics when they’re not in use?',
    'How often do you take short (under 5 minutes) showers?',
    'Do you recycle paper, plastic, and metal properly?',
    'How often do you avoid single-use plastics like straws and utensils?',
    'Do you choose locally grown or organic food when possible?',
    'How often do you eat plant-based meals instead of meat?',
    'Do you use energy-efficient appliances or LED bulbs in your home?'
  ];

  final Map<int, String> answers = {};

  void calculateScore() {
    answers.forEach((index, value) {
      if (value == 'Sometimes') {
        user.addPoints(1);
      } else if (value == 'Always') {
        user.addPoints(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DECE), // Light earth tone background
      appBar: AppBar(
        title: const Text('Questionnaire'),
        backgroundColor: const Color(0xFF556B2F), // Earth-tone app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0xFFD4C8A8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questions[index],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildOptionButton(index, 'Never'),
                              _buildOptionButton(index, 'Sometimes'),
                              _buildOptionButton(index, 'Always'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF556B2F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                calculateScore();
                int finalScore = user.points;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFFD4C8A8),
                    title: const Text('Your Score'),
                    content: Text('You have earned $finalScore points!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => PrimaryScreen()),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Submit', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(int index, String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: answers[index] == text ? const Color(0xFF778866) : Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        setState(() {
          answers[index] = text;
        });
      },
      child: Text(text),
    );
  }
}
