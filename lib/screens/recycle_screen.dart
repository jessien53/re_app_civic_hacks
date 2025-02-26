import 'dart:convert';
import 'package:flutter/material.dart';
import 'question_model.dart';
import 'gemini_service.dart';
import 'user.dart';
import 'primary_screen.dart';

User user = User();

class RecycleScreen extends StatefulWidget {
  const RecycleScreen({Key? key}) : super(key: key);

  @override
  RecycleScreenState createState() => RecycleScreenState();
}

class RecycleScreenState extends State<RecycleScreen> {
  final List<String> _topics = [
    'yes or no questions about recyclable products',
    'yes or no questions about recycling fun facts',
    'yes or no questions about recyclable products',
    'yes or no questions about recycling fun facts',
    'yes or no questions about recyclable products',
  ];

  late final GeminiService _geminiService;
  String? _recycleResult;
  bool _showResultPopup = false;


  Question? _currentQuestion;
  String? _selectedAnswer;
  String _feedback = '';
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _score = 0;
  int _questionCount = 0;
  final int _maxQuestions = 5;

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService();
    _loadNextQuestion();
  }

  Future<void> _loadNextQuestion() async {
    if (_questionCount >= _maxQuestions) {
      _showGameOverDialog();
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      _selectedAnswer = null;
      _feedback = '';
    });

    try {
      // Get a random topic
      final topic = _topics[_questionCount % _topics.length];
      final response = await _geminiService.generateQuestion(topic, isYesNo: true);

      // Parse the response and handle potential JSON errors
      try {
        final questionJson = jsonDecode(response);

        // Ensure the response contains the necessary fields for Question
        if (questionJson.containsKey('question') && questionJson.containsKey('options')) {
          final newQuestion = Question.fromJson(questionJson);

          setState(() {
            _currentQuestion = newQuestion;
            _isLoading = false;
            _questionCount++;
          });
        } else {
          throw FormatException("Invalid question format received.");
        }
      } catch (e) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Invalid question format received. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage =
        'Failed to load question. Please check your connection and try again.';
        _isLoading = false;
      });
    }
  }



  void _handleAnswer(String answer) {
    if (_currentQuestion == null || _selectedAnswer != null) return;

    setState(() {
      _selectedAnswer = answer;
      if (answer == _currentQuestion!.correctAnswer) {
        _feedback = 'Correct! +1 point';
        _score++;
        user.addPoints(1);
      } else {
        _feedback =
        'Incorrect. The correct answer was: ${_currentQuestion!.correctAnswer}';
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Complete!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Final Score: $_score out of $_maxQuestions'),
              const SizedBox(height: 10),
              Text('Total Points: ${user.points}'),
              const SizedBox(height: 10),
              Text('Current Level: ${user.level}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _restartQuiz();
              },
            ),
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PrimaryScreen()),
                ); // Return to previous screen
              },
            ),
          ],
        );
      },
    );
  }

  void _restartQuiz() {
    setState(() {
      _questionCount = 0;
      _score = 0;
      _currentQuestion = null;
      _selectedAnswer = null;
      _feedback = '';
    });
    _loadNextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle Trivia'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Score: $_score/$_maxQuestions',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadNextQuestion,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_currentQuestion == null) {
      return const Center(child: Text('No question available'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Question $_questionCount of $_maxQuestions',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(_currentQuestion!.text, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        ..._currentQuestion!.options.take(2).map(
              (option) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed:
              _selectedAnswer != null ? null : () => _handleAnswer(option),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getButtonColor(option),
              ),
              child: Text(
                option,
                style: TextStyle(color: _getTextColor(option)),
              ),
            ),
          ),
        ),
        if (_feedback.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            _feedback,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
              _feedback.startsWith('Correct') ? Colors.green : Colors.red,
            ),
          ),
        ],
        const Spacer(),
        if (_selectedAnswer != null)
          ElevatedButton(
            onPressed: _loadNextQuestion,
            child: Text(
              _questionCount >= _maxQuestions ? 'See Results' : 'Next Question',
            ),
          ),

        // --- START NEW CODE ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: ElevatedButton(
            onPressed: () async {
              setState(() => _showResultPopup = false);
              try {
                final result = await _geminiService.is_recyclable('IMG_6370.JPG');
                setState(() {
                  _recycleResult = result;
                  _showResultPopup = true;
                });
              } catch (e) {
                setState(() => _recycleResult = 'Error analyzing image');
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Check if Recyclable',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        // Animated result popup
        if (_recycleResult != null)
          AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: _showResultPopup ? 1.0 : 0.0,
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _recycleResult == 'Yes' ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    _recycleResult == 'Yes' ? Icons.check_circle : Icons.cancel,
                    color: _recycleResult == 'Yes' ? Colors.green : Colors.red,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'This item is ${_recycleResult == 'Yes' ? 'recyclable' : 'not recyclable'}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _recycleResult == 'Yes' ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],

    );
  }





  Color _getButtonColor(String option) {
    if (_selectedAnswer == null) return Colors.blue;
    if (option == _currentQuestion!.correctAnswer) return Colors.green;
    if (option == _selectedAnswer) return Colors.red;
    return Colors.blue;
  }

  Color _getTextColor(String option) {
    if (_selectedAnswer == null) return Colors.white;
    if (option == _currentQuestion!.correctAnswer) return Colors.white;
    if (option == _selectedAnswer) return Colors.white;
    return Colors.white;
  }
}
