import 'package:flutter/material.dart';

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

  int calculateScore() {
    int score = 0;
    answers.forEach((index, value) {
      if (value == 'Sometimes') {
        score += 1;
      } else if (value == 'Always') {
        score += 2;
      }
    });
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Questionnaire')),
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questions[index],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 'Never',
                            groupValue: answers[index],
                            onChanged: (value) {
                              setState(() {
                                answers[index] = value.toString();
                              });
                            },
                          ),
                          const Text('Never'),
                          Radio(
                            value: 'Sometimes',
                            groupValue: answers[index],
                            onChanged: (value) {
                              setState(() {
                                answers[index] = value.toString();
                              });
                            },
                          ),
                          const Text('Sometimes'),
                          Radio(
                            value: 'Always',
                            groupValue: answers[index],
                            onChanged: (value) {
                              setState(() {
                                answers[index] = value.toString();
                              });
                            },
                          ),
                          const Text('Always'),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                int finalScore = calculateScore();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Your Score'),
                    content: Text('You have earned $finalScore points!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
