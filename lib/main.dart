import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

import 'package:quiz_app/screens/login_screen.dart';

import 'firebase_options.dart';

Future<void> initializeApp() async {
  try {

    WidgetsFlutterBinding.ensureInitialized();

    try {
      await dotenv.load(fileName: "assets/.env");
    } catch (e) {
      debugPrint('Warning: .env file not found. Using default configuration.');
      dotenv.env.addAll({
        'DEFAULT_KEY': 'default_value',
      });
    }

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    CloudinaryContext.cloudinary =
        Cloudinary.fromCloudName(cloudName: 'diia1p9ou');
  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}

void main() async {
  runApp(const LoadingApp());
  try {
    await initializeApp();
    runApp(const MyApp());
  } catch (e) {
    runApp(ErrorApp(error: e.toString()));
  }
}

class LoadingApp extends StatelessWidget {
  const LoadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
