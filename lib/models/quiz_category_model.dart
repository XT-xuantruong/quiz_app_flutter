import 'package:uuid/uuid.dart';

import 'category_model.dart';

class QuizCategory {
  final String id;
  final String title;
  final String imgUrl;

  QuizCategory({
    required this.id,
    required this.title,
    required this.imgUrl,
  });

  factory QuizCategory.fromMap(Map<String, dynamic> map) {
    return QuizCategory(
      id: map['id'] ?? Category.generateId(),
      title: map['title'] ?? '',
      imgUrl: map['img_url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'img_url': imgUrl,
    };
  }

  static String generateId() {
    return const Uuid().v4();
  }
}
