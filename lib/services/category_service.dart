import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
class CategoryService {


  // Collection reference
  final CollectionReference _categoryCollection =
  FirebaseFirestore.instance.collection('category');

  Future<void> addCategory(Category category) async {
    try {
      await _categoryCollection.doc(category.id).set(category.toMap());
    } catch (e) {
      throw Exception("Error adding category: $e");
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await _categoryCollection.doc(category.id).update(category.toMap());
    } catch (e) {
      throw Exception("Error updating category: $e");
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _categoryCollection.doc(categoryId).delete();
    } catch (e) {
      throw Exception("Error deleting category: $e");
    }
  }

  final _db = FirebaseFirestore.instance;
  Future<List<Category>> getCategories() async {
    try {

      final snapshot = await _db.collection('category').get();
      print('Số lượng document tìm thấy: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) =>
          Category.fromMap(
              doc.data(),
              documentId: doc.id
          )
      ).toList();

    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

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
