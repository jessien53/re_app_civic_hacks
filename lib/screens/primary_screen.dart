import 'package:flutter/material.dart';
import 'user.dart';

User user = User();

class PrimaryScreen extends StatefulWidget {
  const PrimaryScreen({super.key});

  @override
  State<PrimaryScreen> createState() => _PrimaryScreenState();
}

class _PrimaryScreenState extends State<PrimaryScreen> {
  final int pointsNeededForNextLevel = 10; // Points required per level

  @override
  Widget build(BuildContext context) {
    double progress = (user.points % pointsNeededForNextLevel) / pointsNeededForNextLevel;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                'some text here',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),

              // Display current level
              Text(
                'Level: ${user.level}',
                style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
              ),

              // Progress bar
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  LinearProgressIndicator(
                    value: progress, // Normalized value between 0.0 and 1.0
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    minHeight: 15,
                  ),
                  Text(
                    '${user.points % pointsNeededForNextLevel} / $pointsNeededForNextLevel points',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Buttons to add points
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    user.addPoints(1);
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(80),
                ),
                child: const Text('Reduce', style: TextStyle(fontSize: 25)),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    user.addPoints(2);
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(80),
                ),
                child: const Text('Recycle', style: TextStyle(fontSize: 25)),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    user.addPoints(3);
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(80),
                ),
                child: const Text('Reuse', style: TextStyle(fontSize: 25)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
