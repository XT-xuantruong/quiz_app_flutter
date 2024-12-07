import 'package:uuid/uuid.dart';

class QuizResultModel {
  String id;
  String user_id;
  String quiz_id;
  int score;

  QuizResultModel({
    String? id,
    required this.user_id,
    required this.quiz_id,
    required this.score,
  }) : id = id ?? const Uuid().v4();

  factory QuizResultModel.fromMap(Map<String, dynamic> map) {
    return QuizResultModel(
      id: map['id'],
      user_id: map['user_id'],
      quiz_id: map['quiz_id'],
      score: map['score'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'quiz_id': quiz_id,
      'score': score,
    };
  }
}