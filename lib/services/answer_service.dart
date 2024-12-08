import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/answer_model.dart';

class AnswersService {
  final _db = FirebaseFirestore.instance;

  Future<void> addAnswer(AnswerModel answer) async {
    await _db.collection('answers').add(answer.toMap());
  }

  Future<List<AnswerModel>> getAnswersByQuestion(DocumentReference questionRef) async {
    final snapshot = await _db.collection('answers')
        .where('question_id', isEqualTo: questionRef)
        .get();
    return snapshot.docs.map((doc) => AnswerModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> updateAnswer(AnswerModel answer) async {
    await _db.collection('answers').doc(answer.id).update(answer.toMap());
  }

  Future<void> deleteAnswer(String id) async {
    await _db.collection('answers').doc(id).delete();
  }
}