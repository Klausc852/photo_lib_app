import 'package:flutter/material.dart';

/// Application color palette
/// Contains all color definitions used throughout the app
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Light Theme Colors - Blue & Green Main Colors
  static const Color primaryLight = Color(0xFF64B5F6); // Bright Blue
  static const Color secondaryLight = Color(0xFF81C784); // Fresh Green
  static const Color backgroundLight = Color(0xFFFFFBFF); // Soft White
  static const Color surfaceLight = Color(0xFFF0F8FF); // Light Blue Tint
  static const Color textPrimaryLight = Color(0xFF1565C0); // Deep Blue Text
  static const Color textSecondaryLight = Color(0xFF2E7D32); // Green Text

  // Dark Theme Colors - Pastel Dark Tones
  static const Color primaryDark = Color(0xFF6B9BD5); // Muted Blue
  static const Color secondaryDark = Color(0xFF7BB17A); // Muted Green
  static const Color backgroundDark = Color(0xFF1A1A1A); // Soft Black
  static const Color surfaceDark = Color(0xFF2A2A2A); // Soft Dark Gray
  static const Color textPrimaryDark = Color(0xFFF0F0F0); // Soft White
  static const Color textSecondaryDark = Color(0xFFC0C0C0); // Light Gray

  // Common Colors (used across all themes) - Soft Pastels
  static const Color error = Color(0xFFE8A4A0); // Pastel Red
  static const Color warning = Color(0xFFFFD4A3); // Pastel Orange
  static const Color success = Color(0xFFA8E6A1); // Pastel Green
  static const Color info = Color(0xFFA4C2F4); // Pastel Blue

  // Gradient Colors - Updated Gradients
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF64B5F6), Color(0xFF81C784)], // Blue to Green
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer Colors - Pastel Shimmer
  static const Color shimmerBase = Color(0xFFF0F0F0);
  static const Color shimmerHighlight = Color(0xFFFBFBFB);
  static const Color shimmerBaseDark = Color(0xFF3A3A3A);
  static const Color shimmerHighlightDark = Color(0xFF4A4A4A);

  // Additional Pastel Color Variants
  static const Color pastelLavender = Color(0xFFE6E6FA);
  static const Color pastelPink = Color(0xFFFFB6C1);
  static const Color deepPink = Color(0xFF8E4A90); // For pink theme text
  static const Color pastelYellow = Color(0xFFFFFACD);
  static const Color pastelMint = Color(0xFFF0FFF0);
  static const Color pastelCoral = Color(0xFFFFDAB9);
  static const Color pastelLilac = Color(0xFFDDA0DD);
  static const Color pastelSkyBlue = Color(0xFF87CEEB);
  static const Color pastelRose = Color(0xFFFFE4E1);

  // Theme-specific variants
  static const Color lightBlue = Color(0xFF64B5F6); // Light theme blue
  static const Color freshGreen = Color(0xFF81C784); // Light theme green
}
