import 'package:uuid/uuid.dart';

class QuizzModel {
  String id;
  String title;
  String category_id;
  String description;

  QuizzModel({
    String? id,
    required this.title,
    required this.category_id,
    required this.description,
  }) : id = id ?? const Uuid().v4();

  factory QuizzModel.fromMap(Map<String, dynamic> map) {
    return QuizzModel(
      id: map['id'],
      title: map['title'],
      category_id: map['category_id'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category_id': category_id,
      'description': description,
    };
  }
}