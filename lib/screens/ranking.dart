import 'package:flutter/material.dart';
import 'package:quiz_app/components/bottom_nav_bar.dart';
import 'package:quiz_app/components/top_card.dart';
import 'package:quiz_app/screens/profile_screen.dart';
import '../services/ranking_service.dart';
import '../models/ranking_model.dart';
import '../components/rarking_card.dart';
import 'category_list_screen.dart';
import 'home_screen.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  final RankingService _rankingService = RankingService();
  List<RankingModel> _rankings = [];
  bool _isLoading = true;
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    _fetchRankings();
  }

  Future<void> _fetchRankings() async {
    try {
      final rankings = await _rankingService.getRankings();
      setState(() {
        _rankings = rankings;
        _isLoading = false;
      });
      print(_rankings);
    } catch (e) {
      print('Error fetching rankings: $e');
      setState(() {
        _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Leaderboard',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.green,
                        ),
                      ),
                      Positioned(
                          top: 25,
                          child: TopCard(
                            top: 2,
                            name: _rankings[0].user_name,
                            avatar: _rankings[0].avatar,
                            total: _rankings[0].total_score,
                          )),
                      Positioned(
                          top: 0,
                          left: MediaQuery.of(context).size.width / 2 - 50,
                          child: TopCard(
                            top: 2,
                            name: _rankings[0].user_name,
                            avatar: _rankings[0].avatar,
                            total: _rankings[0].total_score,
                          )),
                      Positioned(
                          top: 25,
                          right: 0,
                          child: TopCard(
                            top: 2,
                            name: _rankings[0].user_name,
                            avatar: _rankings[0].avatar,
                            total: _rankings[0].total_score,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _rankings.length,
                      itemBuilder: (context, index) {
                        final rank = _rankings[index];
                        return RankingCard(
                          user_name: rank.user_name,
                          total_score: rank.total_score,
                          rank: index,
                        );
                      }),
                )
              ],
            ),
      bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
