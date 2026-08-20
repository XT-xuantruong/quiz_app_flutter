# Quiz App — Flutter

A quiz application built with **Flutter and Dart**, featuring interactive quizzes, scoring, rankings, user management, and quiz content management.

The project was developed to practice mobile application development with Flutter, Firebase integration, reusable UI components, and service-based application structure.

## Features

### Quiz Experience

* Browse and search available quizzes
* Answer multiple quiz questions
* Countdown timer during quizzes
* Automatic score calculation
* Quiz results and ranking system

### User Features

* User registration and login
* User profile management
* Local session persistence
* Profile image support

### Management Features

* Create and manage quizzes
* Create and edit questions
* Manage quiz categories
* Manage users
* Manage questions and answers

## Tech Stack

| Technology                     | Usage                          |
| ------------------------------ | ------------------------------ |
| **Flutter**                    | Mobile application development |
| **Dart**                       | Programming language           |
| **Firebase Core**              | Firebase integration           |
| **Cloud Firestore**            | Application data storage       |
| **SharedPreferences**          | Local session storage          |
| **Cloudinary**                 | Image and media storage        |
| **Image Picker / File Picker** | Media selection                |
| **Flutter Dotenv**             | Environment configuration      |

## Project Structure

```text
lib/
├── components/      # Reusable UI components
├── models/          # Application data models
├── screens/         # Application screens
├── services/        # Data access and business services
├── themes/          # Colors and application themes
├── firebase_options.dart
└── main.dart
```

The project separates UI, models, services, and themes to keep the codebase easier to maintain and extend.

## Main Screens

```text
Login
Register
Home
Profile / Edit Profile
Search Results
Quiz
Quiz Management
Question Management
Category Management
User Management
```

## Getting Started

### Prerequisites

Make sure you have installed:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android Emulator or a physical Android device
* Firebase CLI / FlutterFire CLI for Firebase configuration

### 1. Clone the repository

```bash
git clone [<repository-url>](https://github.com/XT-xuantruong/quiz_app_flutter.git)
cd quiz_app_flutter
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Configure your own Firebase project and generate the Flutter configuration:

```bash
flutterfire configure
```

Make sure Cloud Firestore is enabled for your Firebase project.

### 4. Configure environment variables

Create:

```text
assets/.env
```

Add the environment variables required by your local configuration.

> Do not commit private API keys or secrets to Git.

### 5. Run the application

```bash
flutter run
```

To check available devices:

```bash
flutter devices
```

## Key Dependencies

```yaml
firebase_core
cloud_firestore
shared_preferences
cloudinary_flutter
cloudinary_url_gen
image_picker
file_picker
flutter_dotenv
crypto
uuid
```

## What I Learned

Through this project, I gained hands-on experience with:

* Building mobile interfaces with Flutter
* Structuring a Flutter application into reusable modules
* Managing application state with StatefulWidget
* Working with asynchronous Dart code
* Integrating Cloud Firestore
* Persisting local user sessions
* Handling images and file uploads
* Implementing quiz logic, scoring, and rankings
* Building CRUD-style management features

## Future Improvements

* Migrate authentication to Firebase Authentication
* Introduce a dedicated state management solution such as Riverpod or BLoC
* Improve responsive UI across different screen sizes
* Add unit and widget tests
* Improve error handling and form validation
* Add CI/CD for automated testing and builds

## License

This project is available under the [MIT License](LICENSE).
