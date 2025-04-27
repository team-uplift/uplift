import 'package:flutter/material.dart';
import 'package:uplift/constants/constants.dart';

final ThemeData upliftAuthTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.baseYellow,
  primaryColor: AppColors.baseGreen,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.baseGreen,
    primary: AppColors.baseGreen,
    background: AppColors.warmWhite,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.warmWhite,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(
      color: Colors.grey[600],
      fontSize: 16,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.baseGreen,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
    ),
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Colors.black87,
      height: 1.5,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
);
