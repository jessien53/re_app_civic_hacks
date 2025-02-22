import 'package:flutter/material.dart';

class QuestionnaireScreen extends StatelessWidget {
  const QuestionnaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Questionnaire')),
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'What is your favorite color?'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {}, // Placeholder for submission functionality
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
