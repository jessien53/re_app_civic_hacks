import 'package:flutter/material.dart';
import 'questionnaire_screen.dart';
// need to implement animation for opening app
// path to mp4: app/src/main/res/Re.mp4
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Re')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
                );
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
