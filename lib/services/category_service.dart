import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';
class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  final CollectionReference _categoryCollection =
  FirebaseFirestore.instance.collection('category');

  /// Add a new category
  Future<void> addCategory(Category category) async {
    try {
      await _categoryCollection.doc(category.id).set(category.toMap());
    } catch (e) {
      throw Exception("Error adding category: $e");
    }
  }

  /// Update an existing category
  Future<void> updateCategory(Category category) async {
    try {
      await _categoryCollection.doc(category.id).update(category.toMap());
    } catch (e) {
      throw Exception("Error updating category: $e");
    }
  }

  /// Delete a category by ID
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _categoryCollection.doc(categoryId).delete();
    } catch (e) {
      throw Exception("Error deleting category: $e");
    }
  }

  /// Get all categories
  Future<List<Category>> getCategories() async {
    try {
      QuerySnapshot snapshot = await _categoryCollection.get();
      return snapshot.docs.map((doc) {
        return Category.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception("Error fetching categories: $e");
    }
  }

  /// Get a category by ID
  Future<Category?> getCategoryById(String categoryId) async {
    try {
      DocumentSnapshot doc = await _categoryCollection.doc(categoryId).get();
      if (doc.exists) {
        return Category.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception("Error fetching category by ID: $e");
    }
  }
}
