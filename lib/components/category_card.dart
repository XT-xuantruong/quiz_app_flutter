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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xABABC2E3),
            ),
            child: Image.network(
              imgUrl,
            ),
          ),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

}

