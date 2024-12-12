import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/user_card.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'login_screen.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State {
  final UserService _userService = UserService();
  List _users = [];
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future _checkAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isAdmin = prefs.getBool('isAdmin');

    setState(() {
      _isAdmin = isAdmin ?? false;
    });

    if (_isAdmin) {
      _loadUsers();
    }
  }

  void _loadUsers() async {
    try {
      List users = await _userService.getUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(style: TextStyle(color: Colors.red), 'Error loading user')),
      );
    }
  }


  void _deleteUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    bool? isAdmin = prefs.getBool('isAdmin');

    if (!(isAdmin ?? false)) return;

    try {
      await _userService.deleteUser(user.id);
      setState(() {
        _users.remove(user);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(style: TextStyle(color: Colors.red), 'User deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(style: TextStyle(color: Colors.red), 'Error deleting user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Recheck admin permissions
    if (!_isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: const Center(
          child: Text( style: TextStyle(color: Colors.red), 'You do not have permission to access this page.'),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'User Management',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/manage.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: UserListComponent(
            users: _users,
            onDeleteUser: _deleteUser,
          ),
        )
    );
  }
}