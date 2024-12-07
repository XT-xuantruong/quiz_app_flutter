import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class QuizModel {
  String id;
  String title;
  String category_id;
  String img_url;
  String description;

  QuizModel({
    String? id,
    required this.title,
    required this.category_id,
    required this.img_url,
    required this.description,
  }) : id = id ?? const Uuid().v4();

  factory QuizModel.fromMap(Map<String, dynamic> map, String id) {
    return QuizModel(
      id: id ?? '',
      title: map['title'] ?? '',
      category_id: map['category_id'] is DocumentReference
          ? (map['category_id'] as DocumentReference).id
          : map['category_id'] ?? '',
      img_url: map['img_url'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category_id': category_id,
      'img_url': img_url,
      'description': description,
    };
  }
}