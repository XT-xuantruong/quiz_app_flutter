import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserService _userService = UserService();

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter email and password',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      return;
    }

    try {
      List<UserModel> users = await _userService.getUsers();

      String hashedPassword = _hashPassword(_passwordController.text);

      UserModel? authenticatedUser = users.firstWhere(
            (user) =>
        user.email == _emailController.text &&
            user.password == hashedPassword,
        orElse: () => throw Exception('Invalid credentials'),
      );

      print('Email: ${authenticatedUser.email}');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setBool('isAdmin', authenticatedUser.is_admin);
      await prefs.setString('userEmail', authenticatedUser.email);
      await prefs.setString('userName', authenticatedUser.full_name);
      await prefs.setString('userId', authenticatedUser.id);
      await prefs.setString('userAvatar', authenticatedUser.profile_picture);


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login successful',
            style: TextStyle(color: Colors.green),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login fail',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
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
                SizedBox(height: 32.0),
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.blueGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.blueGrey),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.blueGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  ),
                ),
                SizedBox(height: 24.0),
                SizedBox(
                  width: screenWidth,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[400],
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: screenWidth,
                  // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 32.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber[400]!, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      // side: BorderSide.none,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text(
                      'Create a account',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}