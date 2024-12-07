import 'package:uuid/uuid.dart';

class Category{
  final String id;
  final String title;
  final String imgUrl;

  // Constructor
  Category({
    required this.id,
    required this.title,
    required this.imgUrl,
  });
  // Factory constructor for creating a Category from a Map (e.g., from JSON)
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      title: map['title'] as String,
      imgUrl: map['img_url'] as String,
    );
  }
  // Method to convert a Category to a Map (e.g., for saving to JSON or database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'img_url': imgUrl,
    };
  }
  // Static method to generate a new UUID for id
  static String generateId() {
    return const Uuid().v4();
  }

}