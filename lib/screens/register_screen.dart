import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:quiz_app/models/ranking_model.dart';
import 'package:quiz_app/services/ranking_service.dart';
import '../themes/app_colors.dart';
import 'login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Function to hash password using SHA-256
  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert password to UTF-8 bytes
    var digest = sha256.convert(bytes); // Hash the bytes using SHA-256
    return digest.toString();
  }

  void _registerUser() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please enter full information'),
            backgroundColor: AppColors.wrongAnswer
        ),
      );
      return;
    }

    try {
      String hashedPassword = _hashPassword(_passwordController.text);

      DocumentReference userRef =
          await FirebaseFirestore.instance.collection('users').add({
        'email': _emailController.text,
        'full_name': _nameController.text,
        'password': hashedPassword,
        'is_admin': false,
        'profile_picture': '',
      });

      print(userRef.id);
      // Convert to DocumentReference

      RankingModel newRanking = RankingModel(
          user_name: _nameController.text,
          user_id: userRef.path,
          total_score: 0,
          avatar: '');

      await RankingService().addRanking(newRanking);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Register successfully'),
          backgroundColor: AppColors.correctAnswer
        )
      );

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Register failed: ${e.toString()}'),
            backgroundColor: AppColors.wrongAnswer
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Text(
                      'QUIZ',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4D6B7A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    hintStyle: const TextStyle(color: Colors.blueGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white54),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.blueGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white54),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.blueGrey),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.blueGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white54),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: screenWidth,
                  child: ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[400],
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Container(
                //   width: screenWidth,
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.amber[400]!, width: 2),
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: TextButton(
                //     style: TextButton.styleFrom(
                //       backgroundColor: Colors.white,
                //     ),
                //     onPressed: () {
                //       // Quay lại màn hình đăng nhập
                //       Navigator.pop(context);
                //     },
                //     child: Text(
                //       'Already have an account',
                //       style: TextStyle(
                //         fontSize: 16.0,
                //         color: Colors.orange,
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
