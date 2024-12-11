import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import services
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/services/question_service.dart';

// Import models
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../models/answer_model.dart';

// Import screens
import '../services/answer_service.dart';
import '../themes/app_colors.dart';
import 'create_edit_question_screen.dart';
import 'login_screen.dart';

class QAManagementScreen extends StatefulWidget {
  const QAManagementScreen({Key? key}) : super(key: key);

  @override
  _QAManagementScreenState createState() => _QAManagementScreenState();
}

class _QAManagementScreenState extends State<QAManagementScreen> {
  // Service instances
  final QuizService _quizService = QuizService();
  final QuestionsService _questionService = QuestionsService();
  final AnswersService _answersService = AnswersService();

  // Data lists
  List<QuizModel> _quizzes = [];
  List<QuestionModel> _questions = [];
  Map<String, List<AnswerModel>> _questionAnswers = {};

  // State variables
  QuizModel? _selectedQuiz;
  bool _isAdmin = false;
  bool _isQuizView = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isAdmin = prefs.getBool('isAdmin');

    setState(() {
      _isAdmin = isAdmin ?? false;
    });

    if (_isAdmin) {
      _loadData();
    }
  }

  void _loadData() {
    _loadQuizzes();
  }

  void _loadQuizzes() async {
    try {
      List<QuizModel> quizzes = await _quizService.getQuizzes();
      setState(() {
        _quizzes = quizzes;
      });
    } catch (e) {
      _showErrorSnackBar('Error loading quiz list: $e');
    }
  }

  void _loadQuestionsByQuiz(QuizModel quiz) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<QuestionModel> questions = await _questionService.getQuestionsByQuiz(quiz.id);

      Map<String, List<AnswerModel>> questionAnswers = {};
      for (var question in questions) {
        List<AnswerModel> answers = await _answersService.getAnswersByQuestion(
            FirebaseFirestore.instance.collection('questions').doc(question.id)
        );

        print(answers);
        questionAnswers[question.id] = answers;
      }

      setState(() {
        _questions = questions;
        _questionAnswers = questionAnswers;
        _selectedQuiz = quiz;
        _isQuizView = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error loading question list: $e');
    }
  }

  void _navigateToCreateEditQuestion({QuestionModel? question, QuizModel? selectedQuiz}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditQuestionScreen(
          question: question,
          initialQuiz: selectedQuiz,
        ),
      ),
    );

    if (result == true) {
      if (selectedQuiz != null) {
        _loadQuestionsByQuiz(selectedQuiz);
      } else {
        _loadQuizzes();
      }
    }
  }

  void _deleteQuestion(QuestionModel question) async {
    try {
      await _questionService.deleteQuestion(question.id);
      setState(() {
        _questions.remove(question);
      });
      _showSuccessSnackBar('Question deleted');
    } catch (e) {
      _showErrorSnackBar('Error deleting question');
    }
  }

  void _deleteAnswer(AnswerModel answer, QuestionModel question) async {
    try {
      await _answersService.deleteAnswer(answer.id);
      setState(() {
        _questionAnswers[question.id]?.remove(answer);
      });
      _showSuccessSnackBar('Answer deleted');
    } catch (e) {
      _showErrorSnackBar('Error deleting answer');
    }
  }

  void _confirmDelete(BuildContext context, dynamic item, {QuestionModel? question}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (item is QuestionModel) {
                _deleteQuestion(item);
              } else if (item is AnswerModel && question != null) {
                _deleteAnswer(item, question);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            message,
          ),
          backgroundColor: AppColors.wrongAnswer
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            message,
          ),
          backgroundColor: AppColors.correctAnswer
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: const Center(
          child: Text(
            'You do not have permission to access this page.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isQuizView
              ? 'Q&A Management'
              : 'Questions of Quiz: ${_selectedQuiz?.title ?? ''}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        leading: _isQuizView
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        )
            : IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              _isQuizView = true;
              _selectedQuiz = null;
            });
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/manage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: _isQuizView ? _buildQuizList() : _buildQuestionList(),
      ),
      floatingActionButton: _isQuizView
          ? null
          : FloatingActionButton(
        onPressed: () => _navigateToCreateEditQuestion(
          selectedQuiz: _selectedQuiz,
        ),
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Widget _buildQuizList() {
    return ListView.builder(
      itemCount: _quizzes.length,
      itemBuilder: (context, index) {
        final quiz = _quizzes[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text("QUIZ: " + quiz.title),
            subtitle: Text('Number of questions: ${quiz.questionCount}'),
            onTap: () => _loadQuestionsByQuiz(quiz),
          ),
        );
      },
    );
  }

  Widget _buildQuestionList() {
    if (_questions.isEmpty) {
      return Center(
        child: Text(
          'No questions in this quiz',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        final question = _questions[index];
        final answers = _questionAnswers[question.id] ?? [];

        return Card(
          child: ExpansionTile(
            title: Text(
              question.question_text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              answers.isNotEmpty
                  ? '${answers.length} answers'
                  : 'No answers yet',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _navigateToCreateEditQuestion(
                    question: question,
                    selectedQuiz: _selectedQuiz,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, question),
                ),
              ],
            ),
            children: [
              // Display all answers for this question
              ...answers.map((answer) => ListTile(
                title: Text(answer.option_text),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (answer.is_correct)
                      const Text(
                        'This is the correct answer',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              )).toList(),

              // Add answer button

            ],
          ),
        );
      },
    );
  }
}