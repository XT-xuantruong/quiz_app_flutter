import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
              'https://res.cloudinary.com/dvzjb1o3h/image/upload/v1733540025/n8thkelgktelveumowpd.jpg',
          ),
        ),
        SizedBox(height: 8),
        Text("Python", style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
