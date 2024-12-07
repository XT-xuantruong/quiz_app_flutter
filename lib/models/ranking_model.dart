import 'package:uuid/uuid.dart';

class RankingModel {
  String id;
  String user_id;
  int total_score;

  RankingModel({
    String? id,
    required this.user_id,
    required this.total_score,
  }) : id = id ?? const Uuid().v4();

  factory RankingModel.fromMap(Map<String, dynamic> map) {
    return RankingModel(
      id: map['id'],
      user_id: map['user_id'],
      total_score: map['total_score'],
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