import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // POS / Local store palette: Modern Fintech look
  static const Color primaryColor = Color(0xFF6366F1);      // Indigo 500
  static const Color secondaryColor = Color(0xFF4F46E5);    // Indigo 600
  static const Color accentColor = Color(0xFFF59E0B);       // Amber 500
  static const Color backgroundColor = Color(0xFFF8FAFC);   // Slate 50
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFF43F5E);        // Rose 500
  static const Color successColor = Color(0xFF10B981);      // Emerald 500

  static const Color textPrimary = Color(0xFF1E293B);       // Slate 800
  static const Color textSecondary = Color(0xFF64748B);     // Slate 500

  // Dark palette
  static const Color darkBackground = Color(0xFF0F172A);    // Slate 900
  static const Color darkSurface = Color(0xFF1E293B);       // Slate 800
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: textPrimary,
        onSurface: textPrimary,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),

      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor),
        ),
        labelStyle: GoogleFonts.outfit(color: textSecondary),
        hintStyle: GoogleFonts.outfit(color: textSecondary),
      ),

      textTheme: GoogleFonts.outfitTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -1),
        displayMedium: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary, letterSpacing: -0.5),
        bodyLarge: GoogleFonts.outfit(fontSize: 16, color: textPrimary),
        bodyMedium: GoogleFonts.outfit(fontSize: 14, color: textSecondary),
        titleLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
        titleMedium: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
        titleSmall: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        elevation: 8,
        height: 80,
        indicatorColor: primaryColor.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 12, color: primaryColor);
          }
          return GoogleFonts.outfit(fontSize: 12, color: textSecondary);
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: darkTextPrimary,
        onSurface: darkTextPrimary,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),

      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor),
        ),
        labelStyle: GoogleFonts.outfit(color: darkTextSecondary),
        hintStyle: GoogleFonts.outfit(color: darkTextSecondary),
      ),

      textTheme: GoogleFonts.outfitTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w800, color: darkTextPrimary, letterSpacing: -1),
        displayMedium: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w700, color: darkTextPrimary, letterSpacing: -0.5),
        bodyLarge: GoogleFonts.outfit(fontSize: 16, color: darkTextPrimary),
        bodyMedium: GoogleFonts.outfit(fontSize: 14, color: darkTextSecondary),
        titleLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: darkTextPrimary),
        titleMedium: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: darkTextPrimary),
        titleSmall: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: darkTextPrimary),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF0A101F),
        elevation: 8,
        height: 80,
        indicatorColor: primaryColor.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.white);
          }
          return GoogleFonts.outfit(fontSize: 12, color: darkTextSecondary);
        }),
      ),
    );
  }
}
