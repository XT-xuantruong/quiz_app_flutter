import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AnswerModel {
  String id;
  DocumentReference question_id;
  String option_text;
  bool is_correct;

  AnswerModel({
    String? id,
    required this.question_id,
    required this.option_text,
    required this.is_correct,
  }) : id = id ?? const Uuid().v4();

  factory AnswerModel.fromMap(Map<String, dynamic> map, String id) {
    return AnswerModel(
      id: id,
      question_id: map['question_id'] is DocumentReference
          ? (map['question_id'] as DocumentReference)
          : FirebaseFirestore.instance.collection('questions').doc(map['question_id'] ?? ''),
      option_text: map['option_text'],
      is_correct: map['is_correct'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question_id': question_id,
      'option_text': option_text,
      'is_correct': is_correct,
    };
  }
}