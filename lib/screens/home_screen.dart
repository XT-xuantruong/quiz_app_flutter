import 'package:flutter/material.dart';

import 'package:quiz_app/components/category_card.dart';
import 'package:quiz_app/components/quiz_card.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/services/quiz_service.dart';

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
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // You can add navigation logic based on the selected index here.
  }

  Future<void> fetchCategories() async {
    try {
      final List<Category> fetchedCategories = await _categoryService.getCategories();
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
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ]),
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
                  "https://res.cloudinary.com/dvzjb1o3h/image/upload/v1727704410/x6xaehqt16rjvnvhofv3.jpg",
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                ),
              ),
              const SizedBox(width: 8.0),
              const Text('Truong'),
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
                style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
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
                style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
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
                  )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
