import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/services/question_service.dart';
import 'package:quiz_app/services/quiz_result_service.dart';
import '../models/quiz_model.dart';

class QuizService {
  final _db = FirebaseFirestore.instance;

  Future<void> addQuiz(QuizModel quiz) async {
    await _db.collection('quizzes').add(quiz.toMap());
  }

  Future<List<QuizModel>> getQuizzes() async {
    try {
      final snapshot = await _db.collection('quizzes').get();
      if (snapshot.docs.isEmpty) {
        print('No quizzes found in Firestore');
      }
      final quizzes = snapshot.docs.map((doc) {
        print('Document Data: ${doc.data()}');
        return QuizModel.fromMap(doc.data(), doc.id);
      }).toList();
      final quizMoreInfo = await Future.wait(quizzes.map((quiz) async {
        final questionCount = await QuestionsService().getQuestionCountForQuiz(quiz.id);
        final isCompleted = await QuizResultService().getCompletionStatusForQuiz(quiz.id, "eXEy7er4I1f8yKkp5WSO");

        return quiz.copyWith(
          questionCount: questionCount,
          isCompleted: isCompleted,
        );
      }));
      return quizMoreInfo;
    } catch (e) {
      print('Error fetching quizzes: $e');
      rethrow;
    }
  }

  Future<void> updateQuiz(QuizModel quiz) async {
    await _db.collection('quizzes').doc(quiz.id).update(quiz.toMap());
  }

  Future<void> deleteQuiz(String id) async {
    await _db.collection('quizzes').doc(id).delete();
  }
}