// main.dart
import 'package:flutter/material.dart';
import 'screens/start_screen.dart';
import 'screens/primary_screen.dart';


void main() {
  runApp(const ReApp());
}

class ReApp extends StatelessWidget {
  const ReApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Re',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
     // home: const StartScreen(),--Original
        home:  PrimaryScreen()
    );
  }
}
