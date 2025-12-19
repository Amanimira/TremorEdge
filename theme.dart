import 'package:flutter/material.dart';
import 'colors.dart'; // تأكد من المسار الصحيح

/// Enhanced theme optimized for:
/// ✅ Elderly users (minimum font sizes: 16sp+)
/// ✅ Trembling hands (larger touch targets: 56dp+)
class AppTheme {
  // ==================== Accessibility Constants ====================
  static const double minTouchSize = 56.0;      // WCAG 2.5:1
  static const double minFontSize = 16.0;       // For elderly users
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      
      // ==================== Color Scheme ====================
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      
      // ==================== AppBar Theme ====================
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,        
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
          size: 28,            
        ),
      ),
      
      // ==================== Text Theme ====================
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        
        // Body text starting at 16sp for readability
        bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: AppColors.textPrimary, fontSize: 16, height: 1.5),
        bodySmall: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
      ),
      
      // ==================== Card Theme ====================
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 2),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // ==================== Button Themes (Target Size 56+) ====================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          minimumSize: const Size(minTouchSize, minTouchSize), // Accessibility
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          minimumSize: const Size(minTouchSize, minTouchSize),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      
      // ==================== Input/Form Theme ====================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 3), // Thicker focus
        ),
        labelStyle: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
      ),
    );
  }
  
  // ==================== Helper Methods ====================
  static TextStyle getLargeText({Color color = AppColors.textPrimary}) {
    return TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.w600);
  }
}