import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/services/ranking_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/quiz_options.dart';
import '../components/quiz_timer.dart';
import '../models/quiz_result_model.dart';
import '../models/ranking_model.dart';
import '../services/quiz_result_service.dart';
import '../services/quiz_service.dart';

class QuizScreen extends StatefulWidget {
  final String id;
  const QuizScreen({super.key, required this.id});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? selectedAnswer;
  int currentQuestion = 0;
  bool isLocked = false;
  bool isTimeUp = false;
  final int timePerQuestion = 30;


  bool isLoading = true;
  String? error;
  Map<String, dynamic>? quizData;
  List<Map<String, dynamic>> questions = [];
  int score = 0;
  late String userId = "";
  @override
  void initState() {
    super.initState();
    initializeData();
  }
  Future<void> initializeData() async {
    await getPref();
    await _fetchQuizDetail();
  }
  Future<void> getPref() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        userId = prefs.getString("userId")!;
      });
      print("object $userId");
    } catch (e) {
      print('Error get prefs: $e');
    }
  }

  Future<void> _fetchQuizDetail() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final QuizService quizService = QuizService();
      final data = await quizService.getQuizDetail(widget.id);
      print('Fetched Quiz Data: $data');

      // Transform questions data format
      final List<Map<String, dynamic>> formattedQuestions =
      (data['questions'] as List).map((question) {
        final answers = question['answers'] as List;
        return {
          'id': question['id'],
          'question': question['text'],
          'options': answers.map((a) => a['option_text'].toString()).toList(),
          'correctAnswer': answers
              .firstWhere((a) => a['is_correct'] == true)['option_text'],
        };
      }).toList();
      print('Formatted Questions: $formattedQuestions');
      setState(() {
        quizData = data['quiz'];
        questions = formattedQuestions;
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> saveQuizResult() async {
    final QuizResultService quizResultService = QuizResultService();
    final RankingService rankingService = RankingService();
    // Tham chiếu đến tài liệu người dùng và quiz
    final DocumentReference userRef =
    FirebaseFirestore.instance.collection('users').doc(userId);
    final DocumentReference quizRef =
    FirebaseFirestore.instance.collection('quizzes').doc(widget.id);

    final QuizResultModel result = QuizResultModel(
      user_id: userRef,
      quiz_id: quizRef,
      score: score,
    );
    final ranking = RankingModel(
      total_score: score,
      user_id: userRef.path,
    );

    try {
      await quizResultService.addQuizResult(result);
      await rankingService.updateRanking(ranking);
      print('Quiz result saved successfully');
    } catch (e) {
      print('Error saving quiz result: $e');
    }
  }

  // Tính toán tổng số câu hỏi từ danh sách
  int get totalQuestions => questions.length;

  void onAnswerSelected(String answer) {
    if (!isLocked && !isTimeUp) {
      setState(() {
        selectedAnswer = answer;
        isLocked = true; // Khóa không cho chọn tiếp
        isTimeUp = true; // Dừng đồng hồ
        if (answer == questions[currentQuestion]['correctAnswer']) {
          score += 1; // Tăng điểm
        }
      });

    }
  }

  void nextQuestion() {
    if (currentQuestion < totalQuestions - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        isLocked = false;
        isTimeUp = false;
      });
    } else {
      saveQuizResult();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Hoàn thành'),
          content: Text('Bạn đã hoàn thành tất cả câu hỏi!\nĐiểm của bạn: $score/$totalQuestions'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Đóng dialog
                Navigator.pop(context);  // Quay về màn hình trước
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void onTimerComplete() {
    setState(() {
      isTimeUp = true;
      isLocked = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hết thời gian!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: _fetchQuizDetail,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    // Kiểm tra an toàn để tránh lỗi index out of range
    if (currentQuestion >= questions.length) {
      return const Scaffold(
        body: Center(
          child: Text('Có lỗi xảy ra với câu hỏi'),
        ),
      );
    }

    final currentQuestionData = questions[currentQuestion];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'Previous',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${currentQuestion + 1}/$totalQuestions',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              QuizTimer(
                key: ValueKey(currentQuestion),
                timeRemaining: timePerQuestion,
                onTimerComplete: onTimerComplete,
              ),

              const SizedBox(height: 30),

              Text(
                currentQuestionData['question'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 40),

              QuizOptions(
                options: currentQuestionData['options'],
                selectedAnswer: selectedAnswer,
                correctAnswer: currentQuestionData['correctAnswer'],
                onAnswerSelected: onAnswerSelected,
                isLocked: isLocked,
                isTimeUp: isTimeUp,
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: (selectedAnswer != null || isTimeUp) ? nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D6156),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}