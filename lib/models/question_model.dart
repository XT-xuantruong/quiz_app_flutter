import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class QuestionModel {
  String id;
  DocumentReference quiz_id;
  String question_text;

  QuestionModel({
    String? id,
    required this.quiz_id,
    required this.question_text,
  }) : id = id ?? const Uuid().v4();

  factory QuestionModel.fromMap(Map<String, dynamic> map, String id) {
    return QuestionModel(
      id: id,
      quiz_id: map['quiz_id'] is DocumentReference
          ? (map['quiz_id'] as DocumentReference)
          : FirebaseFirestore.instance.collection('quizzes').doc(map['quiz_id'] ?? ''),
      question_text: map['question_text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quiz_id': quiz_id,
      'question_text': question_text,
    };
  }
}