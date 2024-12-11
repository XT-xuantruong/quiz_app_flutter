import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/quiz_list.dart';
import '../models/quiz_model.dart';
import '../services/quiz_service.dart';
import '../themes/app_colors.dart';
import 'login_screen.dart';
import 'create_quiz_screen.dart';

class QuizManagementScreen extends StatefulWidget {
  @override
  _QuizManagementScreenState createState() => _QuizManagementScreenState();
}

class _QuizManagementScreenState extends State<QuizManagementScreen> {
  final QuizService _quizService = QuizService();
  List<QuizModel> _quizzes = [];
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future _checkAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isAdmin = prefs.getBool('isAdmin');

    setState(() {
      _isAdmin = isAdmin ?? false;
    });

    if (_isAdmin) {
      _loadQuizzes();
    }
  }

  void _loadQuizzes() async {
    try {
      List<QuizModel> quizzes = await _quizService.getQuizzes();
      setState(() {
        _quizzes = quizzes;
      });
      print(quizzes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              'Error loading quiz list: $e',
            ),
            backgroundColor: AppColors.wrongAnswer
        ),
      );
    }
  }

  void _deleteQuiz(QuizModel quiz) async {
    final prefs = await SharedPreferences.getInstance();
    bool? isAdmin = prefs.getBool('isAdmin');

    if (!(isAdmin ?? false)) return;

    try {
      print(quiz.id);
      await _quizService.deleteQuiz(quiz.id);
      setState(() {
        _quizzes.remove(quiz);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              'Quiz deleted',
            ),
            backgroundColor: AppColors.wrongAnswer
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              'Error deleting quiz',
            ),
            backgroundColor: AppColors.wrongAnswer
        ),
      );
    }
  }

  void _editQuiz(QuizModel quiz) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateQuizScreen(quiz: quiz),
      ),
    ).then((_) => _loadQuizzes());
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdmin) {
      return Scaffold(
        appBar: AppBar(title: Text('Access Denied')),
        body: Center(
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
          'Quiz Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/manage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: QuizListComponent(
          quizzes: _quizzes,
          onDeleteQuiz: _deleteQuiz,
          onEditQuiz: _editQuiz,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateQuizScreen(),
            ),
          ).then((_) => _loadQuizzes());
        },
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}