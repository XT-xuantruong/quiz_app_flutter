import 'package:uuid/uuid.dart';

class Category{
  final String id;
  final String title;
  final String imgUrl;

  Category({
    required this.id,
    required this.title,
    required this.imgUrl,
  });
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      title: map['title'] as String,
      imgUrl: map['img_url'] as String,
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