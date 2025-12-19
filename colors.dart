import 'dart:math';
import 'package:flutter/material.dart';

/// Enhanced color palette optimized for:
/// ✅ Elderly users (65+)
/// ✅ Parkinson's disease patients
/// ✅ WCAG AA accessibility standards
/// ✅ High contrast and clear color semantics
class AppColors {
  // ==================== Primary Colors ====================
  static const Color primary = Color(0xFF2196F3);      // Bright Blue
  static const Color primaryDark = Color(0xFF1976D2);  // Dark Blue
  static const Color primaryLight = Color(0xFF64B5F6); // Light Blue
  
  // ==================== Semantic Colors (WCAG AA Compliant) ====================
  /// 🟢 Success - Stable tremor / Connected / Battery full / Good health
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  
  /// 🔴 Error - Danger / High tremor / Low battery / SOS button
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFEF5350);
  
  /// 🟡 Warning - Caution / Charging / Moderate tremor / Connection issue
  static const Color warning = Color(0xFFFFA500);
  static const Color warningLight = Color(0xFFFFB74D);
  
  /// 🔵 Info - Information / Neutral state / Normal tremor
  static const Color info = Color(0xFF29B6F6);
  static const Color infoLight = Color(0xFF4FC3F7);
  
  // ==================== Background Colors ====================
  static const Color background = Color(0xFF121212);    // Dark background
  static const Color surface = Color(0xFF1E1E1E);       // Dark surface
  static const Color surfaceVariant = Color(0xFF2C2C2C); // Darker surface
  
  // ==================== Text Colors (High Contrast) ====================
  static const Color text = Color(0xFFFFFFFF);           // Pure white (PRIMARY)
  static const Color textPrimary = Color(0xFFFFFFFF);     // Pure white
  static const Color textSecondary = Color(0xFFB0B0B0);   // Light gray
  static const Color textTertiary = Color(0xFF808080);    // Medium gray
  static const Color textDisabled = Color(0xFF4A4A4A);    // Dark gray
  
  // ==================== Tremor Type Colors (Medical Standards) ====================
  /// Red: Resting Tremor (Parkinson's Disease)
  static const Color restingTremor = Color(0xFFE53935);
  
  /// Orange: Postural/Essential Tremor (Essential Tremor)
  static const Color essentialTremor = Color(0xFFFFA500);
  
  /// Yellow: Kinetic Tremor (Cerebellar/Intention)
  static const Color kineticTremor = Color(0xFFFFEB3B);
  
  /// Green: Normal / No tremor detected
  static const Color normal = Color(0xFF4CAF50);
  
  // ==================== UI Component Colors ====================
  static const Color secondary = Color(0xFF6C63FF);      // Purple
  static const Color secondaryLight = Color(0xFFA9A0D9);
  
  static const Color accent = Color(0xFF00BCD4);         // Cyan
  static const Color accentLight = Color(0xFF4DD0E1);
  
  static const Color accentGreen = Color(0xFF66BB6A);
  
  // ==================== Border & Divider ====================
  static const Color border = Color(0xFF333333);
  static const Color borderLight = Color(0xFF424242);
  static const Color divider = Color(0xFF424242);
  
  // ==================== Status Indicators (Enhanced Contrast) ====================
  static const Color statusGreen = Color(0xFF81C784);    // High contrast green
  static const Color statusRed = Color(0xFFE57373);      // High contrast red
  static const Color statusOrange = Color(0xFFFFB74D);   // High contrast orange
  static const Color statusYellow = Color(0xFFFFE082);   // High contrast yellow
  static const Color statusGray = Color(0xFFA0A0A0);     // High contrast gray
  
  // ==================== Special Colors ====================
  static const Color disabled = Color(0xFF4A4A4A);
  static const Color overlay = Color(0x80000000);
  
  // ==================== Gradient Colors ====================
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFEF5350)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFA500), Color(0xFFFFB74D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ==================== Accessibility Helpers ====================
  
  /// High contrast color pairs safe for elderly users
  static const List<Color> accessibleColors = [
    success,        // Green
    error,          // Red
    warning,        // Orange
    primary,        // Blue
    accentGreen,    // Light green
    secondary,      // Purple
  ];

  // ==================== Color Helper Methods ====================
  
  /// Get contrasting text color for any background
  static Color getContrastingTextColor(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Color(0xFF1F2937) : Colors.white;
  }
  
  /// Check if two colors meet WCAG AA contrast ratio (4.5:1)
  static bool meetsWCAG_AA(Color foreground, Color background) {
    return _getContrastRatio(foreground, background) >= 4.5;
  }
  
  /// Check if two colors meet WCAG AAA contrast ratio (7:1)
  static bool meetsWCAG_AAA(Color foreground, Color background) {
    return _getContrastRatio(foreground, background) >= 7.0;
  }
  
  static double _getContrastRatio(Color color1, Color color2) {
    final lum1 = _getRelativeLuminance(color1);
    final lum2 = _getRelativeLuminance(color2);
    
    final lighter = lum1 > lum2 ? lum1 : lum2;
    final darker = lum1 > lum2 ? lum2 : lum1;
    
    return (lighter + 0.05) / (darker + 0.05);
  }
  
  static double _getRelativeLuminance(Color color) {
    final r = _linearize(color.red / 255);
    final g = _linearize(color.green / 255);
    final b = _linearize(color.blue / 255);
    
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }
  
  static double _linearize(double value) {
    if (value <= 0.03928) {
      return value / 12.92;
    } else {
      return pow((value + 0.055) / 1.055, 2.4).toDouble();
    }
  }
  
  /// Get color for tremor severity level
  static Color getTremorSeverityColor(double frequency) {
    if (frequency > 7.0) return error;        // High risk
    if (frequency > 5.0) return warning;      // Medium risk
    return success;                           // Normal
  }
  
  /// Get tremor type name and color
  static ({String name, Color color}) getTremorTypeInfo(int tremorType) {
    switch (tremorType) {
      case 0:
        return (name: 'Resting (PD)', color: restingTremor);
      case 1:
        return (name: 'Postural (ET)', color: essentialTremor);
      case 2:
        return (name: 'Kinetic', color: kineticTremor);
      case 3:
        return (name: 'Normal', color: normal);
      default:
        return (name: 'Unknown', color: textSecondary);
    }
  }
}