import 'package:flutter/material.dart';
import 'package:quiz_app/components/bottom_nav_bar.dart';
import 'package:quiz_app/components/category_card.dart';
import 'package:quiz_app/components/category_list_card.dart';
import 'package:quiz_app/screens/profile_screen.dart';
import 'package:quiz_app/screens/search_result_screen.dart';

import '../models/category_model.dart';
import '../services/category_service.dart';
import 'home_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final CategoryService _categoryService = CategoryService();
  List<Category> categories = [];
  bool isCateLoading = true;
  bool isGridView = false;
  int _selectedIndex = 2;

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
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
      // Navigator.pushReplacementNamed(context, '/search');
        break;
      case 2:
        // Navigator.pushReplacementNamed(context, '/categories');
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Quiz App')),
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
            SizedBox(height: 10,),
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
      ),
      bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped
      ),
    );
  }
}