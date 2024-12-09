import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankingModel {
  final String id;
  final DocumentReference user_id;
  final int total_score;
  final String user_name;
  final String avatar;

  RankingModel({
    String? id,
    required this.user_name,
    required this.user_id,
    required this.total_score,
    required this.avatar,
  }) : id = id ?? const Uuid().v4();

  factory RankingModel.fromMap(Map<String, dynamic> map, String id) {
    return RankingModel(
      id: map['id'],
      user_id: map['user_id'] ?? "",
      total_score: map['total_score'] ?? 0,
      user_name: map['user_name'] ?? 'Unknown',
      avatar: map['avatar'] ??
          'https://res.cloudinary.com/dvzjb1o3h/image/upload/v1727704410/x6xaehqt16rjvnvhofv3.jpg',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'total_score': total_score,
    };
  }
}
