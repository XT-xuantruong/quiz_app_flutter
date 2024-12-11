import 'package:flutter/material.dart';

class RankingCard extends StatelessWidget {
  final int rank;
  final String user_name;
  final int total_score;

  const RankingCard({
    super.key,
    required this.user_name,
    required this.total_score,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('$rank'),
              const SizedBox(
                width: 8,
              ),
              Text('$user_name'),
            ],
          ),
          Text('$total_score')
        ],
      ),
    );
  }
}
