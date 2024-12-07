import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

class QuizService {
  final _db = FirebaseFirestore.instance;

  Future<void> addQuiz(QuizModel quiz) async {
    await _db.collection('quizzes').add(quiz.toMap());
  }

  Future<List<QuizModel>> getQuizzes() async {
    final snapshot = await _db.collection('quizzes').get();
    return snapshot.docs.map((doc) => QuizModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> updateQuiz(QuizModel quiz) async {
    await _db.collection('quizzes').doc(quiz.id).update(quiz.toMap());
  }

  Future<void> deleteQuiz(String id) async {
    await _db.collection('quizzes').doc(id).delete();
  }
}