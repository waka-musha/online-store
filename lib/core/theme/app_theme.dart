import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final class AppTheme {
  static const _black = Color(0xFF000000);
  static const _white = Color(0xFFFFFFFF);
  static const _gray = Color(0xFFF4F4F4);
  static const _darkSurface = Color(0xFF0E0E0E);
  static const _darkSurfaceHighest = Color(0xFF1A1A1A);

  static ThemeData light() => _buildTheme(
    brightness: Brightness.light,
    primary: _black,
    onPrimary: _white,
    surface: _white,
    onSurface: _black,
    surfaceContainerHighest: _gray,
    scaffoldBackground: _white,
    selectedChipOpacity: 0.12,
  );

  static ThemeData dark() => _buildTheme(
    brightness: Brightness.dark,
    primary: _white,
    onPrimary: _black,
    surface: _darkSurface,
    onSurface: _white,
    surfaceContainerHighest: _darkSurfaceHighest,
    scaffoldBackground: _darkSurface,
    selectedChipOpacity: 0.18,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color onPrimary,
    required Color surface,
    required Color onSurface,
    required Color surfaceContainerHighest,
    required Color scaffoldBackground,
    required double selectedChipOpacity,
  }) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: brightness,
        ).copyWith(
          primary: primary,
          onPrimary: onPrimary,
          surface: surface,
          onSurface: onSurface,
          surfaceContainerHighest: surfaceContainerHighest,
          secondary: primary,
        );

    final textTheme = _textTheme(brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBackground,
      appBarTheme: _appBarTheme(scheme),
      cardTheme: _cardTheme(scheme),
      filledButtonTheme: _filledButtonTheme(
        foreground: onPrimary,
        background: primary,
      ),
      chipTheme: _chipTheme(
        scheme: scheme,
        selectedOpacity: selectedChipOpacity,
      ),
      dividerTheme: const DividerThemeData(thickness: 1),
    );
  }

  static TextTheme _textTheme(Brightness brightness) {
    final base = GoogleFonts.openSansTextTheme(
      brightness == Brightness.dark
          ? ThemeData.dark().textTheme
          : ThemeData.light().textTheme,
    );

    return base.copyWith(
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static AppBarTheme _appBarTheme(ColorScheme scheme) => AppBarTheme(
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
  );

  static CardThemeData _cardTheme(ColorScheme scheme) => CardThemeData(
    color: scheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    clipBehavior: Clip.antiAlias,
    surfaceTintColor: Colors.transparent,
  );

  static FilledButtonThemeData _filledButtonTheme({
    required Color foreground,
    required Color background,
  }) => FilledButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      ),
      foregroundColor: WidgetStatePropertyAll(foreground),
      backgroundColor: WidgetStatePropertyAll(background),
    ),
  );

  static ChipThemeData _chipTheme({
    required ColorScheme scheme,
    required double selectedOpacity,
  }) => ChipThemeData(
    shape: const StadiumBorder(),
    labelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    selectedColor: scheme.primary.withValues(alpha: selectedOpacity),
    showCheckmark: false,
  );
}
