import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static const fontFamily = 'Roboto';

  static TextTheme textTheme = const TextTheme(
    // Tiêu đề lớn (ví dụ: màn hình welcome)
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.2,
    ),
    // Tiêu đề trung (ví dụ: tên quiz)
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.3,
    ),
    // Tiêu đề nhỏ (ví dụ: tên category)
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    // Text chính
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
      height: 1.5,
    ),
    // Text phụ
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      color: AppColors.textSecondary,
      height: 1.5,
    ),
    // Text nhỏ (ví dụ: thời gian, điểm số)
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      color: AppColors.textSecondary,
      height: 1.5,
    ),
  );

  // Style cho button
  static TextStyle buttonTextStyle = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: 1.5,
  );

  // Style cho input field
  static TextStyle inputTextStyle = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    color: AppColors.textPrimary,
    height: 1.5,
  );
}