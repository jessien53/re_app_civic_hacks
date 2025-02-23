import 'package:flutter/material.dart';
import 'user.dart';

User user = User();

class PrimaryScreen extends StatefulWidget {
  const PrimaryScreen({super.key});

  @override
  State<PrimaryScreen> createState() => _PrimaryScreenState();
}

class _PrimaryScreenState extends State<PrimaryScreen> {
  @override
  Widget build(BuildContext context) {
    double progress =
        (user.points % user.pointsNeededForNextLevel) /
        user.pointsNeededForNextLevel;

    return Scaffold(
      backgroundColor: const Color(0xFF778866),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Display current level
              Text(
                'Level: ${user.level}',
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE8DECE),
                  fontFamily: "Marker Felt",
                ),
              ),

              // Rounded Progress Bar with Cream Border
              const SizedBox(height: 10),
              Container(
                height: 20,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFE8DECE),
                    width: 3,
                  ), // Cream color border
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: LinearProgressIndicator(
                    value: progress, // Normalized value between 0.0 and 1.0
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF819171),
                    ), // Custom progress color
                    minHeight: 20,
                  ),
                ),
              ),

              // Points Text Overlay
              const SizedBox(height: 5),
              Text(
                '${user.points % user.pointsNeededForNextLevel} / ${user.pointsNeededForNextLevel} points',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE8DECE),
                ),
              ),

              const SizedBox(height: 40),

              // Buttons with doubled size
              GestureDetector(
                onTap: () {
                  setState(() {
                    user.addPoints(1);
                  });
                },
                child: SizedBox(
                  width: 160, // Doubled size
                  height: 160,
                  child: Image.asset('assets/1.png', fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  setState(() {
                    user.addPoints(2);
                  });
                },
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: Image.asset('assets/2.png', fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  setState(() {
                    user.addPoints(3);
                  });
                },
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: Image.asset('assets/3.png', fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
