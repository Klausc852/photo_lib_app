import 'package:flutter/material.dart';

/// Application color palette
/// Contains all color definitions used throughout the app
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Light Theme Colors
  static const Color primaryLight = Color(0xFF2196F3); // Blue
  static const Color secondaryLight = Color(0xFF4CAF50); // Green
  static const Color backgroundLight = Color(0xFFFFFFFF); // White
  static const Color surfaceLight = Color(0xFFF5F5F5); // Light Gray
  static const Color textPrimaryLight = Color(0xFF212121); // Dark Gray
  static const Color textSecondaryLight = Color(0xFF757575); // Medium Gray

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF90CAF9); // Light Blue
  static const Color secondaryDark = Color(0xFF81C784); // Light Green
  static const Color backgroundDark = Color(0xFF121212); // Almost Black
  static const Color surfaceDark = Color(0xFF1E1E1E); // Dark Gray
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // White
  static const Color textSecondaryDark = Color(0xFFB0B0B0); // Light Gray

  // Custom Theme Colors (Blue & Green)
  static const Color primaryCustom = Color(0xFF1976D2); // Darker Blue
  static const Color secondaryCustom = Color(0xFF388E3C); // Darker Green
  static const Color backgroundCustom = Color(0xFFF0F8FF); // Alice Blue
  static const Color accentCustom = Color(0xFF00BCD4); // Cyan

  // Common Colors (used across all themes)
  static const Color error = Color(0xFFD32F2F); // Red
  static const Color warning = Color(0xFFFFA726); // Orange
  static const Color success = Color(0xFF66BB6A); // Green
  static const Color info = Color(0xFF42A5F5); // Blue

  // Gradient Colors
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient customGradient = LinearGradient(
    colors: [Color(0xFF1976D2), Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF2C2C2C);
  static const Color shimmerHighlightDark = Color(0xFF3A3A3A);
}
