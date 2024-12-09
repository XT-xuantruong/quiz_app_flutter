import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final String imgUrl;
  const CategoryCard({super.key, required this.title, required this.imgUrl});

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
            widget.imgUrl,
          ),
        ),
        SizedBox(height: 8),
        Text(widget.title, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
