import 'package:flutter/material.dart';
import 'package:quiz_app/components/category_list_card.dart';
import 'package:quiz_app/screens/search_result_screen.dart';

import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final CategoryService _categoryService = CategoryService();
  List<Category> categories = [];
  bool isCateLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final List<Category> fetchedCategories =
      await _categoryService.getCategories();
      setState(() {
        categories = fetchedCategories;
        isCateLoading = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isCateLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isCateLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : categories.isEmpty
            ? const Center(
          child: Text(
            'No categories available.',
            style: TextStyle(
              fontSize: 16.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CategoryListCard(
                      title: category.title,
                      imgUrl: category.imgUrl,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultScreen(
                              searchTerm: category.id,
                              isCategory: true,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}