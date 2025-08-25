import 'package:chawi_hotel/utils/theme/custom_themes/appbar_theme.dart';
import 'package:chawi_hotel/utils/theme/custom_themes/input_theme.dart';
import 'package:flutter/material.dart' hide AppBarThemeData;
import '../constants/colors.dart';
import 'custom_themes/button_theme.dart';
import 'custom_themes/text_theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: const Color(0xFFF1F8E9),
    brightness: Brightness.light,
    textTheme: AppTextTheme.lightTextTheme,
    filledButtonTheme: AppButtonTheme.lightFilledButtonTheme,
    elevatedButtonTheme: AppButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: AppButtonTheme.lightOutlinedButtonTheme,
    textButtonTheme: AppButtonTheme.lightTextButtonTheme,
    appBarTheme: AppBarThemeData.lightAppBarTheme,
    inputDecorationTheme: AppInputTheme.lightInputTheme,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkbackground,
    brightness: Brightness.dark,
    textTheme: AppTextTheme.darkTextTheme,
    filledButtonTheme: AppButtonTheme.darkFilledButtonTheme,
    elevatedButtonTheme: AppButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: AppButtonTheme.darkOutlinedButtonTheme,
    textButtonTheme: AppButtonTheme.darkTextButtonTheme,
    appBarTheme: AppBarThemeData.darkAppBarTheme,
    inputDecorationTheme: AppInputTheme.darkInputTheme,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
    ),
  );
}
