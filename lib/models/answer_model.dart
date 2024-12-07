import 'package:uuid/uuid.dart';

class AnswerModel {
  String id;
  String question_id;
  String option_text;
  bool is_correct;

  AnswerModel({
    String? id,
    required this.question_id,
    required this.option_text,
    required this.is_correct,
  }) : id = id ?? const Uuid().v4();

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    return AnswerModel(
      id: map['id'],
      question_id: map['question_id'],
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