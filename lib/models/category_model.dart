import 'package:uuid/uuid.dart';

class Category {
  final String id;
  final String title;
  final String imgUrl;

  Category({
    required this.id,
    required this.title,
    required this.imgUrl,
  });

  factory Category.fromMap(Map<String, dynamic> map, {String? documentId}) {
    final id = documentId ?? map['id'] ?? Category.generateId();

    return Category(
      id: id,
      title: map['name'] ?? map['title'] ?? '',
      imgUrl: map['img_url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': title,
      'img_url': imgUrl,
    };
  }

  static String generateId() {
    return const Uuid().v4();
  }

  // Optional: Create a copy with method for easy modification
  Category copyWith({
    String? id,
    String? title,
    String? imgUrl,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }
}