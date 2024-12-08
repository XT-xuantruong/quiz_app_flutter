import 'package:flutter/material.dart';
import 'dart:async';

class QuizTimer extends StatefulWidget {
  final int timeRemaining; // Nhận giá trị thời gian còn lại từ QuizScreen
  final Function() onTimerComplete;

  const QuizTimer({
    super.key,
    required this.timeRemaining,
    required this.onTimerComplete,
  });

  @override
  State<QuizTimer> createState() => _QuizTimerState();
}

class _QuizTimerState extends State<QuizTimer> {
  late Timer _timer;
  late int _timeRemaining;

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.timeRemaining; // Khởi tạo với giá trị timeRemaining
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer.cancel();
          widget.onTimerComplete(); // Gọi hàm khi hết giờ
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: _timeRemaining / widget.timeRemaining, // Vẽ vòng tròn theo thời gian còn lại
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF1D6156),
              strokeWidth: 8,
            ),
            Center(
              child: Text(
                _timeRemaining.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
