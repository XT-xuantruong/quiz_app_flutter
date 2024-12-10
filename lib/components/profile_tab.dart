import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/edit_profile_screen.dart';
import '../screens/login_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late String userName="";
  late String avatar = "";
  late String email = "";
  late String id = "";

  @override
  void initState() {
    super.initState();
    getPref();
  }
  Future<void> getPref() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        userName =  prefs.getString("userName")!;
        avatar = prefs.getString("userAvatar")!;
        email = prefs.getString("userEmail")!;
        id =  prefs.getString("userId")!;
      });

    } catch (e) {
      print('Error get prefs: $e');

    }
  }
  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (mounted) {
        // Navigate to login screen and remove all previous routes
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child:ClipOval(
            child: Image.network(
              avatar.isNotEmpty  ? avatar :
              "https://res.cloudinary.com/dvzjb1o3h/image/upload/v1727704410/x6xaehqt16rjvnvhofv3.jpg",
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          userName,
          style: const TextStyle(
            // color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            // color: Colors.white.withOpacity(0.1),
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.settings, ),
            title: const Text(
              'Update profile',
              // style: TextStyle(color: Colors.white),
            ),
            trailing: const Icon(Icons.chevron_right,),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    currentName: userName,
                    currentAvatar: avatar,
                    currentEmail: email,
                    currentId: id,
                  ),
                ),
              );


              if (result == true) {
                getPref();
              }
            },
          ),
        ),

        const SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            // color: Colors.white.withOpacity(0.1),
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.logout, ),
            title: const Text(
              'Logout',
              // style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(), // Close dialog
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          _logout(); // Perform logout
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
