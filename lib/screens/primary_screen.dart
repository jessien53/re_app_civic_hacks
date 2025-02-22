// primary_screen.dart
import 'package:flutter/material.dart';
import 'global_variables.dart' as globals;

class PrimaryScreen extends StatelessWidget {
   PrimaryScreen({Key? key}) : super(key: key);

  //defining current level
  int currentLevel = globals.currentLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Optional AppBar, uncomment if you want a top bar
      // appBar: AppBar(
      //   title: const Text('Primary Screen'),
      // ),
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
              const Text(
                'Level:', //---> Need to add currentLevel global variable --Sam.
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 40),

              // Button 1
              ElevatedButton(
                onPressed: () {
                  // TODO: Handle button 1 press
                },
                style: ElevatedButton.styleFrom(
                  // Use CircleBorder to make the shape circular
                  shape: const CircleBorder(),
                  // Use padding instead of minimumSize for sizing
                  padding: const EdgeInsets.all(80),
                  // Optionally adjust background color, text style, etc. here
                ),
                child: const Text('Reduce',
                    style: TextStyle(fontSize: 25)),
              ),
              const SizedBox(height: 20),

              // Button 2
              ElevatedButton(
                onPressed: () {
                  // TODO: Handle button 2 press
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(80),
                ),
                child: const Text('Recycle',
                    style: TextStyle(fontSize: 25)),
              ),
              const SizedBox(height: 20),

              // Button 3
              ElevatedButton(
                onPressed: () {
                  // TODO: Handle button 3 press
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(80),
                ),
                child: const Text('Reuse',
                  style: TextStyle(fontSize: 25)),
              ),
              const SizedBox(height: 40),
              // Add more widgets here. As you add more, the screen will scroll.
            ],
          ),
        ),
      ),
    );
  }
}
