import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserListComponent extends StatelessWidget {
  final List users;
  final Function(UserModel) onDeleteUser;

  const UserListComponent({
    Key? key,
    required this.users,
    required this.onDeleteUser
  }) : super(key: key);

  // Function to generate avatar based on email
  Widget _buildAvatar(String email) {
    return CircleAvatar(
      radius: 25,
      backgroundImage: const AssetImage('assets/background.jpg'),
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return users.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 100,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            'No Users',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    )
        : ListView.separated(
      itemCount: users.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Colors.grey.shade300,
        indent: 15,
        endIndent: 15,
      ),
      itemBuilder: (context, index) {
        UserModel user = users[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: _buildAvatar(user.email),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Column(
              children: [
                Text(
                  user.full_name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                    user.email,
                    style: const TextStyle(
                      color: Colors.black87,
                    )
                ),
                const SizedBox(height: 5),
                Text(
                  user.is_admin ? 'Admin' : 'User',
                  style: TextStyle(
                    color: user.is_admin
                        ? Colors.red.shade700
                        : Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red.shade400,
              ),
              onPressed: () => onDeleteUser(user),
            ),
          ),
        );
      },
    );
  }
}