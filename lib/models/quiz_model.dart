import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class QuizModel {
  String id;
  String title;
  DocumentReference category_id;
  String img_url;
  String description;
  final int questionCount;
  final bool isCompleted;

  QuizModel({
    String? id,
    required this.title,
    required this.category_id,
    required this.img_url,
    required this.description,
    this.questionCount = 0,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();

  // Hàm tạo từ Map, sử dụng DocumentReference cho category_id
  factory QuizModel.fromMap(Map<String, dynamic> map, String id) {
    return QuizModel(
      id: id ?? '',
      title: map['title'] ?? '',
      // Trường category_id là một DocumentReference
      category_id: map['category_id'] is DocumentReference
          ? map['category_id'] as DocumentReference
          : FirebaseFirestore.instance.collection('categories').doc(map['category_id'] ?? ''),
      img_url: map['img_url'] ?? '',
      description: map['description'] ?? '',
    );
  }

  QuizModel copyWith({
    int? questionCount,
    bool? isCompleted,
  }) {
    return QuizModel(
      id: id,
      title: title,
      img_url: img_url,
      questionCount: questionCount ?? this.questionCount,
      isCompleted: isCompleted ?? this.isCompleted,
      category_id: category_id,
      description: description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      // Lưu trữ category_id như một DocumentReference
      'category_id': category_id,
      'img_url': img_url,
      'description': description,
      'questionCount': questionCount,
      'isCompleted': isCompleted,
    };
  }
}
