import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // POS / Local store palette: Modern Fintech look
  // Light Mode Palette: Color Psychology (Indigo/Emerald/Amber)
  static const Color primaryColor = Color(0xFF2563EB);      // Indigo (Trust, Stability, Professionalism)
  static const Color secondaryColor = Color(0xFF10B981);    // Emerald (Success, Growth, Confirmation)
  static const Color accentColor = Color(0xFFF59E0B);       // Amber (Activity, Attention, Income)
  static const Color backgroundColor = Color(0xFFF8FAFC);   // Soft Slate/White (Cleanliness)
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFEF4444);        // Modern Red
  static const Color successColor = Color(0xFF10B981);
  
  static const Color textPrimary = Color(0xFF0F172A);       // Deep Slate (High contrast)
  static const Color textSecondary = Color(0xFF475569);     // Medium-Deep Slate (Improved contrast from 0xFF64748B)

  // Dark palette (Reference based - Kept as fallback)
  static const Color darkBackground = Color(0xFF4A4545);
  static const Color darkSurface = Color(0xFF332F2F);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFBDBDBD);

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
        onTertiary: Colors.white,
        onSurface: textPrimary,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
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
          side: const BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryColor.withValues(alpha: 0.2),
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
          borderSide: const BorderSide(color: Color(0xFFEEF2F6)),
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
        displayLarge: GoogleFonts.outfit(fontSize: 34, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -1),
        displayMedium: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: textPrimary, letterSpacing: -0.5),
        displaySmall: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary),
        bodyLarge: GoogleFonts.outfit(fontSize: 18, color: textPrimary),
        bodyMedium: GoogleFonts.outfit(fontSize: 16, color: textSecondary),
        bodySmall: GoogleFonts.outfit(fontSize: 14, color: textSecondary, fontWeight: FontWeight.w500),
        titleLarge: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary),
        titleMedium: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary),
        titleSmall: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
        labelLarge: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
        labelMedium: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: textSecondary),
        labelSmall: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        elevation: 12,
        height: 80,
        indicatorColor: primaryColor.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 12, color: primaryColor);
          }
          return GoogleFonts.outfit(fontSize: 12, color: textSecondary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryColor, size: 28);
          }
          return const IconThemeData(color: textSecondary, size: 24);
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
        backgroundColor: const Color(0xFF2C2828),
        elevation: 8,
        height: 80,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 12, color: accentColor);
          }
          return GoogleFonts.outfit(fontSize: 12, color: darkTextSecondary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: accentColor, size: 28);
          }
          return const IconThemeData(color: Colors.white70, size: 24);
        }),
      ),
    );
  }
}
