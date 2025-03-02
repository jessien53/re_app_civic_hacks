# Re: A Sustainability Education App

## Overview
Re is a gamified sustainability education application built with Flutter that teaches users about the three R's of environmental consciousness: Reduce, Reuse, and Recycle. The app combines interactive quizzes, real-world event participation, and a level-based progression system to make learning about sustainability engaging and fun.

## Features

### 1. Educational Quizzes
- **Reuse Quiz**: Multiple-choice questions about sustainable lifestyle choices and eco-friendly alternatives.
- **Recycle Quiz**: Yes/No questions testing knowledge about recyclable products and recycling facts.
- **Dynamic Content**: Questions are generated using the Gemini AI API to ensure variety and freshness.
- **Real-time Image Analysis**: Users can upload an image of an item to check if it is recyclable using AI-powered image recognition.

### 2. Sustainability Events
- Integration with Gemini AI API to generate sustainability event listings.
- Users can confirm participation in an event to earn points.
- Clean UI with a list of events including event title, description, and date.
- Confirmation system to verify participation.

### 3. Progress System
- Point-based progression.
- Level advancement system.
- Progress tracking across all activities.
- Visual progress indicators.

### 4. User Experience
- Clean, earth-toned UI design.
- Engaging video introduction.
- Smooth navigation between different activities.
- Responsive layout design.

## Technical Stack

- **Framework**: Flutter
- **State Management**: Built-in setState
- **APIs**:
  - Gemini AI API for question generation and sustainability event listing.
- **Packages**:
  - `camera` for photo capture.
  - `opencv_4` for image processing.
  - `confetti` for celebrations.
  - `video_player` and `chewie` for video playback.
  - `http` for API communications.
  - `flutter_dotenv` for environment configuration.
  - `google_fonts` for UI customization.

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/re.git
   cd re
   ```
2. Create a `.env` file in the root directory with:
   ```
   GEMINI_API_KEY=your_gemini_api_key
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

- `lib/`
  - `screens/`
    - `primary_screen.dart`: Main navigation hub.
    - `reduce_screen.dart`: Displays sustainability events and allows participation confirmation.
    - `reuse_screen.dart`: Multiple-choice quiz implementation.
    - `recycle_screen.dart`: Yes/No quiz implementation and image-based recycling detection.
    - `start_screen.dart`: Introduction and authentication.
    - `questionnaire_screen.dart`: Initial user assessment.
  - `services/`
    - `gemini_service.dart`: AI question and event generation service.
  - `models/`
    - `question_model.dart`: Question data structures.
    - `user.dart`: User state management.

## Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  camera: ^0.10.5+5
  opencv_4: ^1.0.0
  confetti: ^0.7.0
  video_player: ^2.7.2
  chewie: ^1.7.1
  flutter_dotenv: ^5.1.0
  google_fonts: ^6.1.0
```

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push to the branch.
5. Create a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

