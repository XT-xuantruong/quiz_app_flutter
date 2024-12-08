import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/login_screen.dart';
import 'package:quiz_app/screens/quiz_management_screen.dart';
import 'package:quiz_app/screens/user_management_screen.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';

Future<void> initializeApp() async {
  try {
    // 1. Initialize Flutter bindings
    WidgetsFlutterBinding.ensureInitialized();

    // 2. Load environment variables first, with a fallback
    try {
      await dotenv.load(fileName: "assets/.env");
    } catch (e) {
      debugPrint('Warning: .env file not found. Using default configuration.');
      // Create an empty env to prevent null errors
      dotenv.env.addAll({
        'DEFAULT_KEY': 'default_value',
        // Add any required env variables here
      });
    }

    // 3. Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 4. Initialize Cloudinary
    CloudinaryContext.cloudinary =
        Cloudinary.fromCloudName(cloudName: 'diia1p9ou');

  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}

void main() async {
  runApp(const LoadingApp());  // Show loading initially

  try {
    await initializeApp();
    runApp(const MyApp());
  } catch (e) {
    runApp(ErrorApp(error: e.toString()));
  }
}

// Loading screen widget
class LoadingApp extends StatelessWidget {
  const LoadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

// Error screen widget
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error initializing app: $error',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Add this class to wrap your HomeScreen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: QuizManagementScreen(),
    );
  }
}