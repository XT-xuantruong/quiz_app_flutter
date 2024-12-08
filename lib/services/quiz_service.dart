import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

class QuizService {
  final _db = FirebaseFirestore.instance;

  Future<void> addQuiz(QuizModel quiz) async {
    try {
      final categoryRef = quiz.category_id;
      final categoryDoc = await categoryRef.get();

      if (!categoryDoc.exists) {
        throw Exception('Invalid category reference');
      }

      await _db.collection('quizzes').add(quiz.toMap());
    } catch (e) {
      print('Error adding quiz: $e');
      rethrow;  // Ném lại lỗi nếu cần
    }
  }


  Future<List<QuizModel>> getQuizzes() async {
    final snapshot = await _db.collection('quizzes').get();
    return snapshot.docs.map((doc) => QuizModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> updateQuiz(QuizModel quiz) async {
    final categoryRef = quiz.category_id;
    final categoryDoc = await categoryRef.get();

    if (!categoryDoc.exists) {
      throw Exception('Invalid category reference');
    }
    await _db.collection('quizzes').doc(quiz.id).update(quiz.toMap());
  }

  Future<void> deleteQuiz(String id) async {
    await _db.collection('quizzes').doc(id).delete();
  }
}