import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'questionnaire_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  StartScreenState createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _videoEnded = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset('assets/Re.mp4')
      ..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
          showControls: false,
        );
        _videoPlayerController.addListener(_checkVideoEnd);
        setState(() {});
      });
  }

  void _checkVideoEnd() {
    if (_videoPlayerController.value.position >= _videoPlayerController.value.duration) {
      setState(() {
        _videoEnded = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_checkVideoEnd);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF778866), // Earth-tone background
      body: Center(
        child: _videoEnded
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add logo assets/Re.
            Image.asset(
              'assets/Re.png',
              height: 100,
              fit: BoxFit.contain,
            ),
            // Sign-in area
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFE8DECE),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Sign On",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Continue button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF556B2F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuestionnaireScreen(),
                  ),
                );
              },
              child: const Text('Continue', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        )
            : _videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
