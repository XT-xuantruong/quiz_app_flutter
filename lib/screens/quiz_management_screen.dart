import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/quiz_list.dart';
import '../models/quiz_model.dart';
import '../services/quiz_service.dart';
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
    } else {
      _showUnauthorizedAccess();
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
            'Lỗi tải danh sách quiz: : $e',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }

  void _showUnauthorizedAccess() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Từ chối truy cập'),
            content: Text('Bạn không có quyền truy cập trang quản trị.'),
            actions: [
              TextButton(
                child: Text('Quay lại'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          );
        },
      );
    });
  }

  void _deleteQuiz(QuizModel quiz) async {
    final prefs = await SharedPreferences.getInstance();
    bool? isAdmin = prefs.getBool('isAdmin');

    if (!(isAdmin ?? false)) return;

    try {
      await _quizService.deleteQuiz(quiz.id);
      setState(() {
        _quizzes.remove(quiz);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã xóa quiz',
            style: TextStyle(color: Colors.green),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lỗi xóa quiz',
            style: TextStyle(color: Colors.red),
          ),
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
        appBar: AppBar(title: Text('Từ chối truy cập')),
        body: Center(
          child: Text(
            'Bạn không có quyền truy cập trang này.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản Lý Quiz',
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
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
