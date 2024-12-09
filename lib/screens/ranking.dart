import 'package:flutter/material.dart';
import '../services/ranking_service.dart';
import '../models/ranking_model.dart';
import '../components/rarking_cart.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
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
    } catch (e) {
      print('Error fetching rankings: $e');
      setState(() {
        _isLoading = false;
      });
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
          : Stack(
              children: [
                //
                Container(
                  width: 498,
                  height: 870,
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    width: 498,
                    height: 400,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(top: 90),
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 9, 94, 12),
                                                width: 6)),
                                        child: ClipOval(
                                            child: Image.network(
                                          "https://res.cloudinary.com/diia1p9ou/image/upload/v1733673683/avatar/t9uvcvpbnkefb9z91zuf.jpg",
                                          fit: BoxFit.cover,
                                        ))),
                                    // Image.asset(''),
                                    Text('name'),
                                    Text('total')
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 35,
                                bottom: 85,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 9, 94, 12),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '2',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 180),
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 229, 255, 0),
                                        width: 6)),
                              ),
                              Positioned(
                                left: 35,
                                bottom: 175,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 248, 224, 10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '1',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 90),
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 9, 94, 12),
                                        width: 6)),
                              ),
                              Positioned(
                                left: 35,
                                bottom: 85,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 9, 94, 12),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '3',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ]),
                  ),
                ),
                Positioned(
                  top: 250,
                  child: Container(
                    width: 498,
                    height: 470,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(150),
                        topRight: Radius.circular(150),
                      ),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: _rankings.length,
                      itemBuilder: (context, index) {
                        final ranking = _rankings[index];
                        return RankingCard(
                          id: ranking.id,
                          user_id: ranking.user_id,
                          total_score: ranking.total_score,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
