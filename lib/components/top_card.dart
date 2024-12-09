import 'package:flutter/material.dart';

class TopCard extends StatefulWidget {
  final int top;
  final String name;
  final String avatar;
  final int total;

  const TopCard({
    Key? key,
    required this.top,
    required this.name,
    required this.avatar,
    required this.total,
  }) : super(key: key);

  @override
  _TopCardState createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Top ${widget.top.toString()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 6,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  widget.avatar,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 100,
              child: Text(
                widget.name,
                maxLines: 1, // Line clamp giới hạn 1 dòng
                overflow:
                    TextOverflow.ellipsis, // Hiển thị dấu "..." khi quá dài
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              widget.total.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
