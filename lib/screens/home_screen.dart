import 'package:flutter/material.dart';
import 'package:quiz_app/models/ranking_model.dart';
import 'package:quiz_app/services/ranking_service.dart';
import 'package:quiz_app/themes/app_colors.dart';
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
  Key _homeKey = UniqueKey();
  Key _categoryKey = UniqueKey();
  Key _profileKey = UniqueKey();
  Key _rankingKey = UniqueKey();

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
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeTab(key: _homeKey,),
          CategoryTab(key: _categoryKey,),
          RankingTab(key: _rankingKey,),
          ProfileTab(key: _profileKey,),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.cardColor,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            _homeKey = UniqueKey(); // Force rebuild home tab
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined),
            activeIcon: Icon(Icons.leaderboard),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    switch (_currentIndex) {
      case 0:
        return AppBar(
          backgroundColor: AppColors.backgroundColor,
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
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Container(
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _rankingModel?.total_score.toString() ?? "0",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        );
      case 2:
        return AppBar(
            backgroundColor: AppColors.secondaryColor,
            title: const Center(
                child: Text(
              'Leaderboard',
              style: TextStyle(color: Colors.white),
            )));
      default:
        return AppBar(
            backgroundColor: AppColors.backgroundColor,
            title: Center(
                child: Text(
              'Quiz App',
              style: TextStyle(fontWeight: FontWeight.bold ,color: AppColors.primaryColor),
            )));
    }
  }
}
