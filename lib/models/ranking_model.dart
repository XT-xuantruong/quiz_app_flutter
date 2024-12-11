import 'package:uuid/uuid.dart';

class RankingModel {
  final String id;
  final String user_id;
  final int total_score;
  final String user_name;
  final String avatar;

  RankingModel({
    String? id,
    this.user_name ="",
    required this.user_id,
    required this.total_score,
    this.avatar ="",
  }) : id = id ?? const Uuid().v4();

  factory RankingModel.fromMap(Map<String, dynamic> map, String id) {
    return RankingModel(
      id: map['id'],
      user_id: map['user_id'] ?? "",
      total_score: map['total_score'] ?? 0,
      user_name: map['user_name'] ?? '',
      avatar: map['avatar'] ??'',
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
