import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_result_model.dart';

class QuizResultService {
  final _db = FirebaseFirestore.instance;

  Future<void> addQuizResult(QuizResultModel result) async {
    await _db.collection('quiz_results').add(result.toMap());
  }

  Future<List<QuizResultModel>> getResultsByUser(String userId) async {
    final snapshot = await _db.collection('quiz_results')
        .where('user_id', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => QuizResultModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> updateQuizResult(QuizResultModel result) async {
    await _db.collection('quiz_results').doc(result.id).update(result.toMap());
  }

  Future<void> deleteQuizResult(String id) async {
    await _db.collection('quiz_results').doc(id).delete();
  }

  Future<bool> getCompletionStatusForQuiz(String quizId,String userId) async {
    try {
      final quizRef = _db.collection('quizzes').doc(quizId);
      final userRef = _db.collection('users').doc(userId);
      final snapshot = await _db.collection('quiz_results')
          .where('quiz_id', isEqualTo: quizRef)
          .where('user_id', isEqualTo: userRef)
          .get();

      // Kiểm tra nếu người dùng đã hoàn thành quiz này
      if (snapshot.docs.isEmpty) {
        return false;
      } else {
        final doc = snapshot.docs.first;
        if (doc.data().containsKey('score') && doc['score'] != 0) {
          return true;
        }
        return false;
      }
    } catch (e) {
      print('Error fetching completion status: $e');
      return false;
    }
  }
}