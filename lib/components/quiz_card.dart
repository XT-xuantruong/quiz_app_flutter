import 'package:flutter/material.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/themes/app_colors.dart';

class QuizCard extends StatefulWidget {
  final String id;
  final String title;
  final String img_url;
  final int question_quantity;
  final bool isComplete;

  const QuizCard(
      {super.key,
      required this.title,
      required this.img_url,
      required this.question_quantity,
      required this.isComplete,
      required this.id});

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  void _onItemTapped() {
    if (!widget.isComplete) {
      // Chỉ điều hướng đến quiz screen nếu quiz chưa hoàn thành
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(id: widget.id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onItemTapped,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 4),
              ),
            ]),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.network(
                  widget.img_url,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 16),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.title,
                      style: Theme.of(context).textTheme.bodyLarge,),
                  const SizedBox(height: 2),
                  Text("${widget.question_quantity.toString()} questions",
                      style: Theme.of(context).textTheme.bodyMedium),
                ]),
              ],
            ),
            widget.isComplete
                ? Image.network(
                    "https://res.cloudinary.com/dvzjb1o3h/image/upload/v1733551645/vpevh1c6wwd2pilvfuou.png")
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
