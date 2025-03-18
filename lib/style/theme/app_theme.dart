import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../typography/app_text_styles.dart';

class AppTheme {
  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      displaySmall: AppTextStyles.displaySmall,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,
      bodyLarge: AppTextStyles.bodyLargeBold,
      bodyMedium: AppTextStyles.bodyLargeMedium,
      bodySmall: AppTextStyles.bodyLargeRegular,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
      
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: AppColors.green500.color,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: AppColors.green500.color,
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
    );
  }
  
}

