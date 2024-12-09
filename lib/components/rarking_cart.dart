// import 'package:flutter/material.dart';
// import '../screens/ranking.dart';

// class RarkingCart extends StatefulWidget {
//   final String id;
//   final String user_id;
//   final int total_score;
//   const RarkingCart(
//       {super.key,
//       required this.id,
//       required this.user_id,
//       required this.total_score});

//   @override
//   State<RarkingCart> createState() => _RarkingCartState();
// }

// class _RarkingCartState extends State<RarkingCart> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: Padding(padding: co),
//     );
//   }
// }
import 'package:flutter/material.dart';

class RankingCard extends StatelessWidget {
  final String id;
  final String user_id;
  final int total_score;

  const RankingCard({
    super.key,
    required this.id,
    required this.user_id,
    required this.total_score,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: 300,
        height: 50,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            Text('$id'),
            Text('$user_id'),
            Text('$total_score')
          ],
        ),
      ),
    );
  }
}
