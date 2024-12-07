import 'package:flutter/material.dart';

class QuizCard extends StatefulWidget {
  const QuizCard({super.key});

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  @override
  Widget build(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ]
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.network(
                    "https://res.cloudinary.com/dvzjb1o3h/image/upload/v1733540025/n8thkelgktelveumowpd.jpg",
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 16),
                const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Math Quiz", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text("30 Question", style: TextStyle(fontSize: 18)),
                    ]
                ),
              ],
            ),
            Image.network("https://res.cloudinary.com/dvzjb1o3h/image/upload/v1733551645/vpevh1c6wwd2pilvfuou.png")
          ],
        ),
      );
    }
  }
