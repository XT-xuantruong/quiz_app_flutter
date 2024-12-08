import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

class QuizListComponent extends StatelessWidget {
  final List<QuizModel> quizzes;
  final Function(QuizModel) onDeleteQuiz;
  final Function(QuizModel) onEditQuiz;

  const QuizListComponent({
    Key? key,
    required this.quizzes,
    required this.onDeleteQuiz,
    required this.onEditQuiz,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: quizzes[index].img_url.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                quizzes[index].img_url,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )
                : SizedBox(width: 50, height: 50),
            title: Text(quizzes[index].title),
            subtitle: Text(quizzes[index].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => onEditQuiz(quizzes[index]),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDeleteQuiz(quizzes[index]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}