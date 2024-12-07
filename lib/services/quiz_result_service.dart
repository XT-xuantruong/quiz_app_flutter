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
}