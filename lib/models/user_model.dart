import 'package:uuid/uuid.dart';

class UserModel {
  String id;
  String email;
  String full_name;
  String password;
  bool is_admin;
  String profile_picture;

  UserModel({
    String? id,
    required this.email,
    required this.full_name,
    required this.password,
    required this.is_admin,
    required this.profile_picture
  }) : id = id ?? Uuid().v4();

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      full_name: map['full_name'] ?? '',
      password: map['password'] ?? '',
      is_admin: map['is_admin'] ?? false,
      profile_picture: map['profile_picture'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'full_name': full_name,
      'password': password,
      'is_admin': is_admin,
      'profile_picture': profile_picture,
    };
  }
}