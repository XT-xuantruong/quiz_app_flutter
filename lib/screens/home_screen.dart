import 'package:flutter/material.dart';
import 'package:quiz_app/components/bottom_nav_bar.dart';

import 'package:quiz_app/components/category_card.dart';
import 'package:quiz_app/components/quiz_card.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/screens/category_list_screen.dart';
import 'package:quiz_app/screens/profile_screen.dart';
import 'package:quiz_app/screens/ranking.dart';
import 'package:quiz_app/screens/search_result_screen.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/searchField.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<HomeScreen> {
  final CategoryService _categoryService = CategoryService();
  late String userName = "";
  late String avatar = "";
  final QuizService _quizService = QuizService();
  List<Category> categories = [];
  List<QuizModel> quizzes = [];
  bool isCateLoading = true;
  bool isQuizLoading = true;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchQuizzes();
    getPref();
  }

  Future<void> getPref() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        userName = prefs.getString("userName")!;
        avatar = prefs.getString("userAvatar")!;
      });
      print(categories.map((category) => category.toMap()).toList());
    } catch (e) {
      print('Error get prefs: $e');
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Ranking()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CategoryListScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final List<Category> fetchedCategories =
          await _categoryService.getCategories();
      setState(() {
        categories = fetchedCategories;
        isCateLoading = false;
      });
      print(categories.map((category) => category.toMap()).toList());
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isCateLoading = false;
      });
    }
  }

  Future<void> fetchQuizzes() async {
    try {
      final List<QuizModel> fetchedQuizzes = await _quizService.getQuizzes();
      setState(() {
        quizzes = fetchedQuizzes;
        isQuizLoading = false;
      });
      print(quizzes.map((quizz) => quizz.toMap()).toList());
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isQuizLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: isCateLoading && isQuizLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildBody(),
      ),
      bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  avatar.isNotEmpty
                      ? avatar
                      : "https://res.cloudinary.com/dvzjb1o3h/image/upload/v1727704410/x6xaehqt16rjvnvhofv3.jpg",
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Container(
            width: 80,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(child: Text('1000')),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: SearchField()),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Categories',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            height: 120,
            child: categories.isEmpty
                ? const Center(
                    child: Text(
                      'No categories available.',
                      style: TextStyle(
                          fontSize: 16.0, fontStyle: FontStyle.italic),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryCard(
                          title: category.title,
                          imgUrl: category.imgUrl,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchResultScreen(
                                  searchTerm: category.id,
                                  isCategory: true, // Add this parameter
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Quizzes',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            height: 300,
            child: quizzes.isEmpty
                ? const Center(
                    child: Text(
                      'No quiz available.',
                      style: TextStyle(
                          fontSize: 16.0, fontStyle: FontStyle.italic),
                    ),
                  )
                : ListView.builder(
                    itemCount: quizzes.length,
                    itemBuilder: (context, index) {
                      final quiz = quizzes[index];
                      return Padding(
                          padding: const EdgeInsets.only(bottom: 8, top: 8),
                          child: QuizCard(
                            title: quiz.title,
                            img_url: quiz.img_url,
                            question_quantity: quiz.questionCount,
                            isComplete: quiz.isCompleted,
                            id: quiz.id,
                          ));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
