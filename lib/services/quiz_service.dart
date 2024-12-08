import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/services/question_service.dart';
import 'package:quiz_app/services/quiz_result_service.dart';
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

  Future<Map<String, dynamic>> getQuizDetail(String quizId) async {
    try {
      final quizDoc = await _db.collection('quizzes').doc(quizId).get();
      if (!quizDoc.exists) {
        throw Exception('Quiz not found');
      }

      final quizRef = _db.collection('quizzes').doc(quizId);

      // Lấy danh sách câu hỏi liên quan đến quiz
      final questionsSnapshot = await _db
          .collection('questions')
          .where('quiz_id', isEqualTo: quizRef)
          .get();

      // Với mỗi câu hỏi, lấy các câu trả lời liên quan
      final questions = await Future.wait(questionsSnapshot.docs.map((questionDoc) async {
        final answersSnapshot = await _db
            .collection('answers')
            .where('question_id', isEqualTo: _db.collection('questions').doc(questionDoc.id))
            .get();

        final answers = answersSnapshot.docs.map((answerDoc) {
          final data = answerDoc.data();
          return {
            'id': answerDoc.id,
            'answer_text': data['answer_text']?.toString() ?? 'No answer text',
            'is_correct': data['is_correct'] ?? false,
          };
        }).toList();

        return {
          'id': questionDoc.id,
          'text': questionDoc.data()['question_text'] ?? 'No question text',
          'answers': answers,
        };
      }).toList());

      return {
        'quiz': {
          'id': quizDoc.id,
          ...quizDoc.data()!,
        },
        'questions': questions,
      };
    } catch (e) {
      print('Error fetching quiz detail: $e');
      rethrow;
    }
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