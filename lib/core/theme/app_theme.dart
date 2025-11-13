import 'package:flutter/material.dart';

final class AppTheme {
  static const Color _brandSeed = Color(0xFF111111);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _brandSeed,
    ).copyWith(primary: Colors.black);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14, height: 1.35),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        selectedColor: colorScheme.primary.withValues(alpha: 0.12),
        showCheckmark: false,
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _brandSeed,
      brightness: Brightness.dark,
    ).copyWith(primary: Colors.white);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0E0E0E),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14, height: 1.35),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        selectedColor: colorScheme.primary.withValues(alpha: 0.18),
        showCheckmark: false,
      ),
    );
  }
}
