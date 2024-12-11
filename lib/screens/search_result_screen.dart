import 'package:flutter/material.dart';
import 'package:quiz_app/models/category_model.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/services/category_service.dart';
import '../components/quiz_card.dart';
import '../services/quiz_service.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchTerm;
  final bool isCategory;
  const SearchResultScreen(
      {super.key,
        required this.searchTerm,
        this.isCategory = false, }
      );

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  bool isLoading = true;
  String? error;
  List<QuizModel> searchResults = [];
  Category? cate;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      if (widget.isCategory){
        final CategoryService categoryService = CategoryService();
        final Category? category = await categoryService.getCategoryById(widget.searchTerm);
        setState(() {
          cate = category;
        });
      }


      // Gọi API search
      final QuizService quizService = QuizService();
      final List<QuizModel> results = widget.isCategory
          ? await quizService.searchByCategory(widget.searchTerm)
          : await quizService.searchQuizzes(widget.searchTerm);

      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
            widget.isCategory ?
              cate?.title ?? 'Đang tải...'
                : 'Kết quả tìm kiếm: ${widget.searchTerm}'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchSearchResults,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (searchResults.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy kết quả nào'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final quiz = searchResults[index];
        return Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 8),
            child: QuizCard(
              title: quiz.title,
              img_url: quiz.img_url,
              question_quantity: quiz.questionCount,
              isComplete: quiz.isCompleted,
              id: quiz.id,
            )
        );
      },
    );
  }
}