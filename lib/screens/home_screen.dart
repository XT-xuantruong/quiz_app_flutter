import 'package:flutter/material.dart';
import 'package:quiz_app/models/ranking_model.dart';
import 'package:quiz_app/services/ranking_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/category_tab.dart';
import '../components/home_tab.dart';
import '../components/profile_tab.dart';
import '../components/ranking_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<HomeScreen> {
  final RankingService _rankingService = RankingService();
  String userId = "";
  String userName = "";
  String avatar = "";
  RankingModel? _rankingModel; // Changed to nullable
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getPref();
    if (userId.isNotEmpty) {
      await fetchRanking();
    }
  }

  final List<Widget> _tabs = [
    HomeTab(),
    CategoryTab(),
    RankingTab(),
    ProfileTab(),
  ];

  Future<void> getPref() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        userId = prefs.getString("userId") ?? "";
        userName = prefs.getString("userName") ?? "";
        avatar = prefs.getString("userAvatar") ?? "";
      });
    } catch (e) {
      print('Error get prefs: $e');
    }
  }

  Future<void> fetchRanking() async {
    try {
      final RankingModel? user = await _rankingService.getRankingDetail(userId);
      if (user != null) {
        setState(() {
          _rankingModel = user;
        });
      }
      print("rank $user");

    } catch (e) {
      print('Error fetching user ranking: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Category'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Ranking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),

        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    switch (_currentIndex) {
      case 0:
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
                    style: const TextStyle(
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
                child: Center(
                  child: Text(
                    _rankingModel?.total_score.toString() ?? "0",
                  ),
                ),
              ),
            ],
          ),
        );
      case 1:
        return AppBar(title: const Text('Quiz App'));
      case 2:
        return AppBar(title: const Text('Leaderboard'));
      case 3:
        return AppBar(title: const Text('Quiz App'));
      default:
        return AppBar(title: const Text('Quiz App'));
    }
  }
}