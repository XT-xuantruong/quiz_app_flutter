import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imgUrl;
  final VoidCallback onTap;
  const CategoryCard(
      {super.key,
      required this.title,
      required this.imgUrl,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.network(
              imgUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
