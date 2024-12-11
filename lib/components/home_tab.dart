import 'package:flutter/material.dart';
import 'package:quiz_app/components/quiz_card.dart';
import 'package:quiz_app/components/searchField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category_model.dart';
import '../models/quiz_model.dart';
import '../screens/search_result_screen.dart';
import '../services/category_service.dart';
import '../services/quiz_service.dart';
import '../themes/app_colors.dart';
import 'category_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final CategoryService _categoryService = CategoryService();
  final QuizService _quizService = QuizService();

  late String userId = "";
  late String userName = "";
  late String avatar = "";

  List<Category> categories = [];
  List<QuizModel> quizzes = [];
  bool isCateLoading = true;
  bool isQuizLoading = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getPref();
    await fetchCategories();
    await fetchQuizzes();
  }

  Future<void> getPref() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        userId = prefs.getString("userId")!;
        userName = prefs.getString("userName")!;
        avatar = prefs.getString("userAvatar")!;
      });
      print("object $userId");
    } catch (e) {
      print('Error get prefs: $e');
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
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isCateLoading = false;
      });
    }
  }

  Future<void> fetchQuizzes() async {
    try {
      print(userId);
      final List<QuizModel> fetchedQuizzes =
          await _quizService.getQuizzesByUser(userId);
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
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: isCateLoading && isQuizLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: SearchField()),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 120,
                    child: categories.isEmpty
                        ? Center(
                            child: Text(
                              'No categories available.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textSecondary,
                                  ),
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
                                        builder: (context) =>
                                            SearchResultScreen(
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
                  const SizedBox(height: 16.0),
                  Text(
                    'Quizzes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 300,
                    child: quizzes.isEmpty
                        ? Center(
                            child: Text(
                              'No quiz available.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: quizzes.length,
                            itemBuilder: (context, index) {
                              final quiz = quizzes[index];
                              return Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 8, top: 8),
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
            ),
    );
  }
}
