import 'package:flutter/material.dart';
import 'package:quiz_app/components/rarking_card.dart';
import 'package:quiz_app/components/top_card.dart';
import 'package:quiz_app/themes/app_colors.dart';

import '../models/ranking_model.dart';
import '../services/ranking_service.dart';

class RankingTab extends StatefulWidget {
  const RankingTab({super.key});

  @override
  State<RankingTab> createState() => _RankingTabState();
}

class _RankingTabState extends State<RankingTab> {
  final RankingService _rankingService = RankingService();
  List<RankingModel> _rankings = [];
  bool _isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const Center(child: CircularProgressIndicator())
        : _rankings.isEmpty
        ? const Center(
          child: Text(
            'No rankings available!',
            style: TextStyle(fontSize: 18),
          ),
        )
        : Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    if (_rankings.length > 0)
                      Positioned(
                        top: 0,
                        left: MediaQuery.of(context).size.width / 2 - 50,
                        child: TopCard(
                          top: 1,
                          name: _rankings[0].user_name,
                          avatar: _rankings[0].avatar,
                          total: _rankings[0].total_score,
                        ),
                      ),
                    if (_rankings.length > 1)
                      Positioned(
                        top: 25,
                        left: 16,
                        child: TopCard(
                          top: 2,
                          name: _rankings[1].user_name,
                          avatar: _rankings[1].avatar,
                          total: _rankings[1].total_score,
                        ),
                      ),
                    if (_rankings.length > 2)
                      Positioned(
                        top: 25,
                        right: 16,
                        child: TopCard(
                          top: 3,
                          name: _rankings[2].user_name,
                          avatar: _rankings[2].avatar,
                          total: _rankings[2].total_score,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _rankings.length - 3 > 0 ? _rankings.length - 3 : 0,
                  itemBuilder: (context, index) {
                    final rank = _rankings[index + 3]; // Lấy từ Top 4
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8),
                      child: RankingCard(
                        user_name: rank.user_name,
                        total_score: rank.total_score,
                        rank: index + 4, // Xếp hạng từ Top 4 trở đi
                      ),
                    );
                  },
                ),
              ),
            ],
        );
  }
}
