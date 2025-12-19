import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'dart:math';


/// Accessibility Service for Elderly Users and Parkinson's Patients
/// Features:
/// ✅ Haptic feedback patterns
/// ✅ Color contrast checking
/// ✅ Responsive font sizing
/// ✅ Large touch target helpers
/// ✅ Screen reader support
class AccessibilityService {
  // ==================== Haptic Feedback Patterns ====================
  
  /// Light tap feedback (50ms)
  static Future<void> lightTap() async {
    await Vibration.vibrate(duration: 50);
  }

  /// Medium tap feedback (100ms)
  static Future<void> mediumTap() async {
    await Vibration.vibrate(duration: 100);
  }

  /// Heavy tap feedback (200ms)
  static Future<void> heavyTap() async {
    await Vibration.vibrate(duration: 200);
  }

  /// Success pattern: double tap
  static Future<void> successPattern() async {
    await Vibration.vibrate(duration: 100);
    await Future.delayed(const Duration(milliseconds: 100));
    await Vibration.vibrate(duration: 100);
  }

  /// Error pattern: triple tap
  static Future<void> errorPattern() async {
    await Vibration.vibrate(duration: 200);
    await Future.delayed(const Duration(milliseconds: 100));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(const Duration(milliseconds: 100));
    await Vibration.vibrate(duration: 200);
  }

  /// Warning pattern: rapid double tap
  static Future<void> warningPattern() async {
    await Vibration.vibrate(duration: 50);
    await Future.delayed(const Duration(milliseconds: 50));
    await Vibration.vibrate(duration: 50);
  }

  /// Connected pattern: ascending vibration
  static Future<void> connectedPattern() async {
    await Vibration.vibrate(duration: 50);
    await Future.delayed(const Duration(milliseconds: 50));
    await Vibration.vibrate(duration: 75);
    await Future.delayed(const Duration(milliseconds: 50));
    await Vibration.vibrate(duration: 100);
  }

  // ==================== Font Size Management ====================
  
  /// Get responsive font size based on base size and text scale
  static double getResponsiveFontSize(
    double baseSize, {
    double textScaleFactor = 1.0,
    double maxSize = 32,
    double minSize = 16,
  }) {
    final scaledSize = baseSize * textScaleFactor;
    return scaledSize.clamp(minSize, maxSize);
  }

  /// Ensure minimum readable font size
  static double ensureMinimumFontSize(double fontSize) {
    return fontSize < 16 ? 16 : fontSize;
  }

  // ==================== Color Contrast Checking ====================
  
  /// Check if foreground and background meet WCAG AA standard (4.5:1)
  static bool meetsWCAG_AA(Color foreground, Color background) {
    final contrastRatio = _getContrastRatio(foreground, background);
    return contrastRatio >= 4.5;
  }

  /// Check if foreground and background meet WCAG AAA standard (7:1)
  static bool meetsWCAG_AAA(Color foreground, Color background) {
    final contrastRatio = _getContrastRatio(foreground, background);
    return contrastRatio >= 7.0;
  }

  /// Get the actual contrast ratio between two colors
  static double getContrastRatio(Color foreground, Color background) {
    return _getContrastRatio(foreground, background);
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

  // ==================== Touch Target Helpers ====================
  
  /// Minimum touch target size for elderly users with trembling hands
  static const double minTouchSize = 56.0; // WCAG 2.5:1 pointer target

  /// Wrap a widget with accessible touch target sizing
  static Widget wrapWithAccessibleTouchTarget({
    required Widget child,
    VoidCallback? onTap,
    String? semanticLabel,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        label: semanticLabel,
        enabled: onTap != null,
        button: true,
        onTap: onTap,
        child: SizedBox(
          width: minTouchSize,
          height: minTouchSize,
          child: Center(child: child),
        ),
      ),
    );
  }

  /// Wrap a button with minimum touch size and haptic feedback
  static Widget enhancedButton({
    required VoidCallback onPressed,
    required Widget child,
    String? semanticLabel,
    double minSize = minTouchSize,
  }) {
    return SizedBox(
      width: minSize,
      height: minSize,
      child: Semantics(
        label: semanticLabel,
        enabled: true,
        button: true,
        onTap: () {
          mediumTap();
          onPressed();
        },
        child: GestureDetector(
          onTap: () {
            mediumTap();
            onPressed();
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                mediumTap();
                onPressed();
              },
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== Screen Reader / Semantic Labels ====================
  
  /// Generate semantic label for screen readers
  static String generateSemanticLabel({
    required String action,
    required String context,
    String? additionalInfo,
  }) {
    final parts = [action, context];
    if (additionalInfo != null) {
      parts.add(additionalInfo);
    }
    return parts.join(', ');
  }

  /// Tremor level semantic label
  static String getTremorLevelLabel(double frequency) {
    if (frequency > 7.0) {
      return 'High tremor detected. Heart rate elevated. Consider contacting emergency services.';
    } else if (frequency > 5.0) {
      return 'Moderate tremor detected. Monitor closely.';
    } else {
      return 'Normal tremor level.';
    }
  }

  /// Device status semantic label
  static String getDeviceStatusLabel(bool isConnected, String? deviceName) {
    if (isConnected) {
      return 'Device connected: ${deviceName ?? 'Unknown device'}';
    } else {
      return 'Device not connected. Tap to pair.';
    }
  }

  // ==================== Error Message Formatting ====================
  
  /// Format user-friendly error messages (not technical)
  static String formatErrorMessage(String error) {
    if (error.contains('timeout')) {
      return 'Connection timed out. Please try again.';
    } else if (error.contains('permission')) {
      return 'Permission denied. Please enable Bluetooth in settings.';
    } else if (error.contains('bluetooth')) {
      return 'Bluetooth error. Please turn off and on again.';
    } else if (error.contains('connection')) {
      return 'Unable to connect. Move closer to device.';
    } else if (error.contains('database')) {
      return 'Data saving error. Please check storage.';
    } else {
      return 'An error occurred. Please try again.';
    }
  }

  // ==================== Color Recommendation ====================
  
  /// Get recommended text color for background (ensures contrast)
  static Color getContrastingTextColor(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Check if colors are suitable for elderly users
  static bool isSafeForElderlyUsers(Color foreground, Color background) {
    return meetsWCAG_AA(foreground, background) &&
        !_isSimilarColor(foreground, background);
  }

  static bool _isSimilarColor(Color color1, Color color2) {
    final diff = (color1.red - color2.red).abs() +
        (color1.green - color2.green).abs() +
        (color1.blue - color2.blue).abs();
    return diff < 100; // If too similar, might be hard to distinguish
  }

  // ==================== Accessibility Settings ====================
  
  /// Check if system accessibility features are enabled
  static Future<bool> areAccessibilityFeaturesEnabled(
    BuildContext context,
  ) async {
    // This would require platform-specific code
    // For now, return true to always provide enhanced accessibility
    return true;
  }

  /// Get user's text scale factor from system settings
  static double getSystemTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  /// Ensure app respects system accessibility settings
  static double respectSystemAccessibility(
    BuildContext context,
    double baseSize,
  ) {
    final systemScale = getSystemTextScaleFactor(context);
    return baseSize * systemScale;
  }
}
