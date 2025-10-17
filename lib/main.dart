import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iAnctChinese 古汉语大模型自动标注平台',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5DC),
        primaryColor: const Color(0xFFF5F5DC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B0000),
          primary: const Color(0xFFF5F5DC),
          secondary: const Color(0xFF006400),
          tertiary: const Color(0xFFDAA520),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B0000),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            height: 1.3,
            letterSpacing: 1.0,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B0000),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.3,
            letterSpacing: 1.0,
            color: Color(0xFF333333),
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.3,
            letterSpacing: 1.0,
            color: Color(0xFF333333),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            height: 1.6,
            letterSpacing: 0.5,
            color: Color(0xFF333333),
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            height: 1.6,
            letterSpacing: 0.5,
            color: Color(0xFF666666),
          ),
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
          labelSmall: TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
