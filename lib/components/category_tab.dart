import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../screens/search_result_screen.dart';
import '../services/category_service.dart';
import 'category_card.dart';
import 'category_list_card.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key});

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  final CategoryService _categoryService = CategoryService();
  List<Category> categories = [];
  bool isCateLoading = true;
  bool isGridView = false;

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
    return Padding(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                child: isGridView
                    ? IconButton(
                  key: const ValueKey('list'),
                  icon: const Icon(
                    Icons.list,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      isGridView = false;
                    });
                  },
                )
                    : IconButton(
                  key: const ValueKey('grid'),
                  icon: const Icon(
                    Icons.grid_view,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      isGridView = true;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: isGridView ?
            GridView.builder(
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CategoryCard(
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
            )
                : ListView.builder(
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
    );
  }
}
