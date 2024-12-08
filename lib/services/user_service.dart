import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  Future<void> addUser(UserModel user) async {
    await _db.collection('users').add(user.toMap());
  }

  Future<List<UserModel>> getUsers() async {
    final snapshot = await _db.collection('users').get();
    return snapshot.docs.map((doc) => UserModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> updateUser(Map<String, dynamic> fields,String id) async {
    await _db.collection('users').doc(id).update(fields);
  }

  Future<void> deleteUser(String id) async {
    await _db.collection('users').doc(id).delete();
  }
}
