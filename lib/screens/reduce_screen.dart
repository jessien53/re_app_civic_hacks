import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:confetti/confetti.dart';
import 'package:opencv_4/opencv_4.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

// Event data model
class Event {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['name']['text'] ?? 'No Title',
      description: json['description']['text'] ?? 'No Description',
      imageUrl: json['logo'] != null ? json['logo']['url'] : 'https://via.placeholder.com/150',
    );
  }
}

class SustainabilityEventsScreen extends StatefulWidget {
  @override
  _SustainabilityEventsScreenState createState() => _SustainabilityEventsScreenState();
}

class _SustainabilityEventsScreenState extends State<SustainabilityEventsScreen> {
  late Future<List<Event>> futureEvents;
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  late ConfettiController confettiController;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();
    confettiController = ConfettiController(duration: const Duration(seconds: 2));
    initializeCamera();
  }

  Future<List<Event>> fetchEvents() async {
    const String apiUrl = 'https://www.eventbriteapi.com/v3/events/search/';
    const String token = 'YOUR_EVENTBRITE_API_TOKEN'; // Replace with your Eventbrite API token
    final response = await http.get(
      Uri.parse('$apiUrl?q=sustainability&sort_by=date&location.address=Boston&location.within=50mi'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List eventsJson = data['events'];
      return eventsJson.take(3).map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras.first, ResolutionPreset.medium);
    await cameraController.initialize();
    if (!mounted) return;
    setState(() => isCameraInitialized = true);
  }

  void capturePhoto(Event event) async {
    if (!isCameraInitialized) return;
    final image = await cameraController.takePicture();
    processImage(image.path, event);
  }

  Future<void> processImage(String imagePath, Event event) async {
    try {
      // Ensure OpenCV has access to the image path
      Uint8List? processedImage = await Cv2.cvtColor(
          pathString: imagePath,
          outputType: Cv2.COLOR_BGR2GRAY // Correct OpenCV constant
      );

      if (processedImage != null) {
        bool isValid = await verifyImage(processedImage, event);
        setState(() {});
        if (isValid) {
          confettiController.play();
          showSnackBar("Event verified! 🎉", true);
        } else {
          showSnackBar("Image does not match the event 😔", false);
        }
      } else {
        showSnackBar("Error processing image 😔", false);
      }
    } catch (e) {
      showSnackBar("Error: $e", false);
    }
  }



  Future<bool> verifyImage(Uint8List imgData, Event event) async {
    // Placeholder for real image verification logic
    return imgData.isNotEmpty; // Simplified check (replace with real verification)
  }

  void showSnackBar(String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(success ? Icons.celebration : Icons.warning,
                color: success ? Colors.green : Colors.red),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sustainability Events')),
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events available.'));
          }

          return Stack(
            children: [
              ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final event = snapshot.data![index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: ListTile(
                      leading: Image.network(event.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(event.title, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(event.description),
                      trailing: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () => capturePhoto(event),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
