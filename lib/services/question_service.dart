import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/question_model.dart';

class QuestionsService {
  final _db = FirebaseFirestore.instance;

  Future<void> addQuestion(QuestionModel question) async {
    await _db.collection('questions').add(question.toMap());
  }

  Future<List<QuestionModel>> getQuestionsByQuiz(String quizId) async {
    final quizRef = _db.collection('quizzes').doc(quizId);

    final snapshot = await _db.collection('questions')
        .where('quiz_id', isEqualTo: quizRef)
        .get();

    return snapshot.docs.map((doc) => QuestionModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> updateQuestion(QuestionModel question) async {
    await _db.collection('questions').doc(question.id).update(question.toMap());
  }

  Future<void> deleteQuestion(String id) async {
    await _db.collection('questions').doc(id).delete();
  }

  Future<int> getQuestionCountForQuiz(String quizId) async {
    try {
      final quizRef = _db.collection('quizzes').doc(quizId);
      final snapshot = await _db.collection('questions')
          .where('quiz_id', isEqualTo: quizRef).get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error fetching question count: $e');
      return 0;
    }
  }
}