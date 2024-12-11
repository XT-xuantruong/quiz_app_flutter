import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question_model.dart';
import '../models/answer_model.dart';
import '../models/quiz_model.dart';
import '../services/answer_service.dart';
import '../services/question_service.dart';
import '../services/quiz_service.dart';
import '../themes/app_colors.dart';

class CreateEditQuestionScreen extends StatefulWidget {
  final QuestionModel? question;
  final QuizModel? initialQuiz;
  final AnswerModel? answer;
  final QuestionModel? initialQuestion; // Add this line

  const CreateEditQuestionScreen({
    Key? key,
    this.question,
    this.initialQuiz,
    this.answer,
    this.initialQuestion,
  }) : super(key: key);

  @override
  _CreateEditQuestionScreenState createState() => _CreateEditQuestionScreenState();
}

class _CreateEditQuestionScreenState extends State<CreateEditQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final QuestionsService _questionsService = QuestionsService();
  final QuizService _quizService = QuizService();
  final AnswersService _answersService = AnswersService();

  late TextEditingController _questionTextController;
  List<QuizModel> _quizzes = [];
  QuizModel? _currentQuiz;

  // Answer-related variables
  List<TextEditingController> _optionControllers = [];
  List<bool> _isCorrectOptions = [];
  List<AnswerModel?> _existingAnswers = [];

  @override
  void initState() {
    super.initState();
    _questionTextController = TextEditingController(
        text: widget.question?.question_text ?? ''
    );

    // Initialize with at least two option fields
    _addOptionField();
    _addOptionField();

    // Load existing answers if editing an existing question
    if (widget.question != null) {
      _loadExistingAnswers();
    }

    // Set initial quiz reference
    if (widget.question != null) {
    } else if (widget.initialQuiz != null) {
    }

    _loadQuizzes();


  }

  void _loadQuizzes() async {
    try {
      List<QuizModel> quizzes = await _quizService.getQuizzes();
      setState(() {
        _quizzes = quizzes;
      });
    } catch (e) {
      _showErrorSnackBar('Lỗi tải danh sách quiz: $e', );
    }
  }


  void _loadExistingAnswers() async {
    try {

      final answers = await _answersService.getAnswersByQuestion(
          FirebaseFirestore.instance.collection('questions').doc(widget.question!.id)
      );

      // Clear existing controllers
      _optionControllers.clear();
      _isCorrectOptions.clear();
      _existingAnswers.clear();

      // Populate with existing answers
      for (var answer in answers) {
        _addOptionField(
          optionText: answer.option_text,
          isCorrect: answer.is_correct,
          existingAnswer: answer,
        );
      }

      setState(() {});
    } catch (e) {
      _showErrorSnackBar('Lỗi tải câu trả lời: $e');
    }
  }
  void _addOptionField({
    String optionText = '',
    bool isCorrect = false,
    AnswerModel? existingAnswer,
  }) {
    setState(() {
      _optionControllers.add(
          TextEditingController(text: optionText)
      );
      _isCorrectOptions.add(isCorrect);
      _existingAnswers.add(existingAnswer);
    });
  }

  void _removeOptionField(int index) {
    setState(() {
      _optionControllers.removeAt(index);
      _isCorrectOptions.removeAt(index);
      _existingAnswers.removeAt(index);
    });
  }

  void _saveQuestion() async {
    if (_formKey.currentState!.validate()) {
      try {
        final questionText = _questionTextController.text.trim();

        // Validate at least one correct answer
        if (!_isCorrectOptions.contains(true)) {
          _showErrorSnackBar('Phải có ít nhất một câu trả lời đúng');
          return;
        }

        // Validate option texts
        for (var controller in _optionControllers) {
          if (controller.text.trim().isEmpty) {
            _showErrorSnackBar('Không được để trống câu trả lời');
            return;
          }
        }

        // Tạo hoặc cập nhật câu hỏi
        final question = QuestionModel(
          id: widget.question?.id,
          quiz_id: FirebaseFirestore.instance
              .collection('quizzes')
              .doc(_currentQuiz!.id),
          question_text: questionText,
        );

        // Save or update the question
        DocumentReference questionRef;
        final _db = FirebaseFirestore.instance;

        if (widget.question == null) {
          // Thêm mới
          await _questionsService.addQuestion(question);
          questionRef = (await _db.collection('questions')
              .where('quiz_id', isEqualTo: question.quiz_id)
              .where('question_text', isEqualTo: question.question_text)
              .get())
              .docs
              .first
              .reference;
        } else {
          // Cập nhật
          await _questionsService.updateQuestion(question);
          questionRef = _db.collection('questions').doc(widget.question!.id);
        }

        // Save or update answers
        for (int i = 0; i < _optionControllers.length; i++) {
          final optionText = _optionControllers[i].text.trim();
          final isCorrect = _isCorrectOptions[i];
          final existingAnswer = _existingAnswers[i];

          final answer = AnswerModel(
            id: existingAnswer?.id,
            question_id: questionRef,
            option_text: optionText,
            is_correct: isCorrect,
          );

          if (existingAnswer == null) {
            // Add new answer
            await _answersService.addAnswer(answer);
          } else {
            // Update existing answer
            await _answersService.updateAnswer(answer);
          }
        }

        _showSuccessSnackBar(
            widget.question == null
                ? 'Thêm câu hỏi thành công'
                : 'Cập nhật câu hỏi thành công'
        );

        Navigator.of(context).pop(true);
      } catch (e) {
        _showErrorSnackBar('Lỗi lưu câu hỏi: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.question == null
              ? 'Tạo Câu Hỏi Mới'
              : 'Chỉnh Sửa Câu Hỏi',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Quiz Dropdown
              DropdownButtonFormField<QuizModel>(
                decoration: InputDecoration(
                  labelText: 'Chọn Quiz',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: _currentQuiz,
                items: _quizzes.map((quiz) {
                  return DropdownMenuItem<QuizModel>(
                    value: quiz,
                    child: Text(quiz.title),
                  );
                }).toList(),
                onChanged: (QuizModel? newValue) {
                  setState(() {
                    _currentQuiz = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn quiz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Question Text Field
              TextFormField(
                controller: _questionTextController,
                decoration: InputDecoration(
                  labelText: 'Nội Dung Câu Hỏi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập nội dung câu hỏi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Options Section
              Text(
                'Câu Trả Lời',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              // Dynamic Option Fields
              ...List.generate(_optionControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _optionControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Câu Trả Lời ${index + 1}',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Checkbox(
                        value: _isCorrectOptions[index],
                        onChanged: (bool? value) {
                          setState(() {
                            _isCorrectOptions[index] = value ?? false;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: _optionControllers.length > 2
                            ? () => _removeOptionField(index)
                            : null,
                      ),
                    ],
                  ),
                );
              }),

              // Add Option Button
              ElevatedButton.icon(
                onPressed: () => _addOptionField(),
                icon: const Icon(Icons.add),
                label: const Text('Thêm Câu Trả Lời'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
              const SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: _saveQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  widget.question == null
                      ? 'Tạo Câu Hỏi'
                      : 'Cập Nhật Câu Hỏi',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
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
  void dispose() {
    _questionTextController.dispose();
    // Dispose all option controllers
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}