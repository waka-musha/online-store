import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final class AppTheme {
  static const _black = Color(0xFF000000);
  static const _white = Color(0xFFFFFFFF);
  static const _grayF4 = Color(0xFFF4F4F4);
  static const _darkSurface = Color(0xFF0E0E0E);

  static ThemeData light() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _black,
        ).copyWith(
          primary: _black,
          onPrimary: _white,
          surface: _white,
          onSurface: _black,
          surfaceContainerHighest: _grayF4,
          secondary: _black,
        );

    final textTheme = GoogleFonts.openSansTextTheme().copyWith(
      headlineSmall: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
      titleMedium: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      labelMedium: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: _white,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: scheme.onSurface,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface),
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
          foregroundColor: const WidgetStatePropertyAll(_white),
          backgroundColor: const WidgetStatePropertyAll(_black),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        selectedColor: scheme.primary.withValues(alpha: 0.12),
        showCheckmark: false,
      ),
      dividerTheme: const DividerThemeData(thickness: 1),
    );
  }

  static ThemeData dark() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _white,
          brightness: Brightness.dark,
        ).copyWith(
          primary: _white,
          onPrimary: _black,
          surface: _darkSurface,
          onSurface: _white,
          surfaceContainerHighest: const Color(0xFF1A1A1A),
          secondary: _white,
        );

    final textTheme = GoogleFonts.openSansTextTheme(ThemeData.dark().textTheme)
        .copyWith(
          headlineSmall: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
          titleMedium: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          labelMedium: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: _darkSurface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: scheme.onSurface,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface),
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
          foregroundColor: const WidgetStatePropertyAll(_black),
          backgroundColor: const WidgetStatePropertyAll(_white),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        selectedColor: scheme.primary.withValues(alpha: 0.18),
        showCheckmark: false,
      ),
      dividerTheme: const DividerThemeData(thickness: 1),
    );
  }
}
