import 'package:flutter/material.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 498,
            height: 870,
            color: Colors.orangeAccent,
          ),
          Positioned(
            child: Container(
              width: 498,
              height: 400,
              child: Row(),
            )
            )
        ],
      ),
    );
  }
}
