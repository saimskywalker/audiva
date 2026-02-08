import 'package:flutter/material.dart';

/// App color palette for dark theme
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary brand color
  static const primary = Color(0xFF7C3AED); // Purple
  static const primaryDark = Color(0xFF5B21B6);

  // Accent
  static const accent = Color(0xFFEC4899); // Pink

  // Backgrounds
  static const background = Color(0xFF0F0F0F); // Almost black
  static const surface = Color(0xFF1A1A1A); // Dark grey
  static const surfaceLight = Color(0xFF252525);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9CA3AF);
  static const textTertiary = Color(0xFF6B7280);

  // Status colors
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);

  // Special
  static const liveRed = Color(0xFFDC2626);
}
