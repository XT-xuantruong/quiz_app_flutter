import 'package:flutter/material.dart';
import 'package:quiz_app/themes/app_colors.dart';

class QuizOptions extends StatelessWidget {
  final List<String> options;
  final String? selectedAnswer;
  final String correctAnswer;
  final Function(String) onAnswerSelected;
  final bool isLocked;
  final bool isTimeUp;

  const QuizOptions({
    super.key,
    required this.options,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.onAnswerSelected,
    this.isLocked = false,
    this.isTimeUp = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        bool isSelected = selectedAnswer == option;
        bool isCorrect = option == correctAnswer;
        // Hiển thị màu khi có đáp án được chọn hoặc hết giờ
        bool shouldShowResult = selectedAnswer != null || isTimeUp;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: shouldShowResult ? null : () => onAnswerSelected(option),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: shouldShowResult
                    ? (isCorrect
                    ? AppColors.correctAnswer
                    : (isSelected ? AppColors.wrongAnswer : AppColors.neutralAnswer))
                    : (isSelected ? Colors.blue.withOpacity(0.1) : AppColors.neutralAnswer),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: shouldShowResult
                      ? (isCorrect
                      ? Colors.green
                      : (isSelected ? Colors.red : Colors.grey[300]!))
                      : (isSelected ? Colors.blue : Colors.grey[300]!),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        color: shouldShowResult
                            ? (isCorrect || isSelected ? Colors.white : Colors.black87)
                            : Colors.black87,
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (shouldShowResult && isCorrect)
                    const Icon(Icons.check_circle, color: Colors.white),
                  if (shouldShowResult && isSelected && !isCorrect)
                    const Icon(Icons.cancel, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
