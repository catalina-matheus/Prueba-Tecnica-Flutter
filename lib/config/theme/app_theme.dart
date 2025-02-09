import 'package:flutter/material.dart';

class AppTheme {
  final Brightness brightness;

  AppTheme({required this.brightness});

  Color get primaryColor => brightness == Brightness.dark
      ? Color.fromARGB(255, 67, 161, 232)
      : Color.fromARGB(255, 65, 162, 238);
  Color get backgroundColor =>
      brightness == Brightness.dark ? Colors.black : Colors.white;
  Color get textColor =>
      brightness == Brightness.dark ? Colors.white : Colors.black87;
  Color get iconColor => Colors.white;

  Gradient get menuButtonGradient => const LinearGradient(
        colors: [
          Color.fromARGB(255, 95, 227, 143),
          Color.fromARGB(255, 65, 162, 238)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  ThemeData get getTheme => ThemeData(
        useMaterial3: true,
        brightness: brightness,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: brightness,
        ),
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor:
              brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: textColor),
          bodyMedium: TextStyle(fontSize: 16, color: textColor),
          titleLarge: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
          headlineLarge: TextStyle(
              fontSize: 34, fontWeight: FontWeight.bold, color: textColor),
          headlineSmall: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
        ),
        cardColor:
            brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(color: iconColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primaryColor,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      );
}
