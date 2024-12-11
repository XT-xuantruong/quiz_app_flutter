import 'package:flutter/material.dart';

class CategoryListCard extends StatelessWidget {
  final String title;
  final String imgUrl;
  final VoidCallback onTap;
  const CategoryListCard(
      {super.key,
        required this.title,
        required this.imgUrl,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.network(
                  imgUrl,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 16),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      // const SizedBox(height: 2),
                      // Text("${widget.question_quantity.toString()} questions", style: TextStyle(fontSize: 18)),
                    ]
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

