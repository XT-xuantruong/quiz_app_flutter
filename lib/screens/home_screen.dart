import 'package:flutter/material.dart';
import 'package:quiz_app/components/category_card.dart';
import 'package:quiz_app/components/quiz_card.dart';

import '../components/searchField.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      "https://res.cloudinary.com/dvzjb1o3h/image/upload/v1727704410/x6xaehqt16rjvnvhofv3.jpg",
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text('Truong'),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.lightBlue,

                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                  child: Text('1000')
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: SearchField(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                  'Categories',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),

              CategoryCard(),
              SizedBox(height: 16.0),
              Text(
                'Quizzes',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              QuizCard()
            ],
          ),
        ),
      ),
    );
  }
}
