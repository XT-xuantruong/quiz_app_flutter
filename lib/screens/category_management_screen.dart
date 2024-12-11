import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../services/category_service.dart';
import 'create_category_screen.dart';
import 'package:quiz_app/themes/app_colors.dart';

// Category Management Screen
class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({Key? key}) : super(key: key);

  @override
  _CategoryManagementScreenState createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error fetching categories: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
          backgroundColor: AppColors.wrongAnswer      ),
    );
  }

  void _navigateToCreateEditCategory({Category? category}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditCategoryScreen(
          category: category,
          onCategoryAdded: (newCategory) {
            _fetchCategories();
            return newCategory;
          },
        ),
      ),
    );
  }

  Future<void> _deleteCategory(Category category) async {
    try {
      await _categoryService.deleteCategory(category.id);
      _fetchCategories();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category "${category.title}" deleted successfully'),
          backgroundColor: AppColors.wrongAnswer,
        ),
      );
    } catch (e) {
      _showErrorSnackBar('$e');
    }
  }

  void _confirmDeleteCategory(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete the category "${category.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteCategory(category);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.wrongAnswer),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản Lý Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.category_outlined,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'No categories yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _navigateToCreateEditCategory(),
              child: const Text('Create First Category'),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: Card(
              elevation: 2,
              child: ListTile(
                leading: category.imgUrl.isNotEmpty
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(category.imgUrl),
                )
                    : const CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.category, color: Colors.white),
                ),
                title: Text(
                  category.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _navigateToCreateEditCategory(
                        category: category,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteCategory(category),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateEditCategory(),
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
