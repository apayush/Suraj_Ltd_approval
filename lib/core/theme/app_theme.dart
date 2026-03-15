import 'package:flutter/material.dart';

import '../utills/app_module_container.dart';
import 'app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    primaryColorDark: AppColors.lightPrimaryColorDark,
    scaffoldBackgroundColor: AppColors.lightScaffoldBackgroundColor,
    canvasColor: AppColors.lightSurface,
    drawerTheme: const DrawerThemeData(
      surfaceTintColor: AppColors.lightDrawerBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: AppColors.lightDrawerBackgroundColor,
    ),
    appBarTheme: AppBarTheme(
      color: AppColors.darkAppBarBackground,
      elevation: 2.0,
      shadowColor: Colors.black,
      iconTheme: const IconThemeData(color: AppColors.darkIconThemeColor),
      titleTextStyle: TextStyle(
        color: AppColors.darkTitleTextColor,
        fontSize: FontSizes.extraLarge,
      ),
    ),
    tabBarTheme: TabBarThemeData(
      indicatorColor: AppColors.blue,
      unselectedLabelStyle: TextStyles.tabStyle(textColor: Colors.grey),
      labelStyle: TextStyles.tabStyle(textColor: Colors.black),
    ),
    hoverColor: Colors.black12,
    popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.black),
    ),
    buttonTheme: const ButtonThemeData(buttonColor: AppColors.lightButtonColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        textStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // <-- Radius
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightButtonColor,
        textStyle: const TextStyle(color: Colors.white),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.lightButtonColor,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    primaryColorDark: AppColors.darkPrimaryColorDark,
    scaffoldBackgroundColor: AppColors.darkScaffoldBackgroundColor,
    canvasColor: AppColors.darkSurface,
    appBarTheme: AppBarTheme(
      color: AppColors.darkAppBarBackground,
      elevation: 2.0,
      shadowColor: Colors.black,
      iconTheme: const IconThemeData(color: AppColors.darkIconThemeColor),
      titleTextStyle: TextStyle(
        color: AppColors.darkTitleTextColor,
        fontSize: FontSizes.extraLarge,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      surfaceTintColor: AppColors.darkDrawerBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: AppColors.darkDrawerBackgroundColor,
    ),
    tabBarTheme: TabBarThemeData(
      indicatorColor: AppColors.blue,
      unselectedLabelStyle: TextStyles.tabStyle(textColor: Colors.grey),
      labelStyle: TextStyles.tabStyle(textColor: Colors.white),
    ),
    hoverColor: Colors.white12,
    popupMenuTheme: const PopupMenuThemeData(color: Colors.black),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white),
    ),
    buttonTheme: const ButtonThemeData(buttonColor: AppColors.darkButtonColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // <-- Radius
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkButtonColor,
        textStyle: const TextStyle(color: Colors.white),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.darkButtonColor,
    ),
  );
}
