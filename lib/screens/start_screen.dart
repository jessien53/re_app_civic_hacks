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
      body: Center(
        child: _videoEnded
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuestionnaireScreen(),
                  ),
                );
              },
              child: const Text('Continue'),
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
