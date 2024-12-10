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
      print("user id: $userId");
      // Validate input parameters
      if (quizId.isEmpty || userId.isEmpty) {
        throw ArgumentError('quizId and userId must not be empty');
      }

      // Tạo references đúng cách
      final quizRef = _db.collection('quizzes').doc(quizId);
      final userRef = _db.collection('users').doc(userId);

      final querySnapshot = await _db.collection('quiz_results')
          .where('quiz_id', isEqualTo: quizRef)  // Sử dụng reference object
          .where('user_id', isEqualTo: userRef)  // Sử dụng reference object
          .limit(1)
          .get();

      if (!querySnapshot.docs.isNotEmpty) {
        return false;
      }

      final score = querySnapshot.docs.first.data()['score'];
      return score != null && score > 0;

    } catch (e) {
      print('Error fetching completion status for Quiz: $quizId, User: $userId');
      print('Error details: $e');
      return false;  // Return false on error instead of rethrowing
    }
  }
}