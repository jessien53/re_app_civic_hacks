import 'package:flutter/material.dart';
import 'package:re/screens/reduce_screen.dart';
import 'user.dart';
import 'reuse_screen.dart';
import 'recycle_screen.dart';

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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReduceScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero, // Remove extra padding
                  backgroundColor: Colors.transparent, // Make background transparent
                  shadowColor: Colors.transparent, // Remove shadow
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/1.png',
                    width: 160,  // Adjust size as needed
                    height: 160,
                    fit: BoxFit.cover, // Ensures the image fills the button properly
                  ),
                ),
              ),


              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReuseScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero, // Remove extra padding
                  backgroundColor: Colors.transparent, // Make background transparent
                  shadowColor: Colors.transparent, // Remove shadow
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/2.png',
                    width: 160,  // Adjust size as needed
                    height: 160,
                    fit: BoxFit.cover, // Ensures the image fills the button properly
                  ),
                ),
              ),


              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RecycleScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero, // Remove extra padding
                  backgroundColor: Colors.transparent, // Make background transparent
                  shadowColor: Colors.transparent, // Remove shadow
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/3.png',
                    width: 160,  // Adjust size as needed
                    height: 160,
                    fit: BoxFit.cover, // Ensures the image fills the button properly
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
