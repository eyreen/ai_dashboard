// Import Flutter's material design package for UI components
import 'package:flutter/material.dart';

// Import Google Fonts package to use custom fonts from Google Fonts library
import 'package:google_fonts/google_fonts.dart';

/// AppTheme class contains all color definitions and theme configuration
/// This centralizes the app's visual appearance for consistency
class AppTheme {
  // ============================================
  // COLOR PALETTE - Modern design inspired by Stripe/Linear
  // Using 'const' makes these values compile-time constants for better performance
  // Color format: 0xFF[HEX] where FF is opacity (fully opaque)
  // ============================================

  // Primary brand color - Indigo blue used for main UI elements
  static const Color primaryColor = Color(0xFF6366F1);

  // Secondary brand color - Purple used for accents and gradients
  static const Color secondaryColor = Color(0xFF8B5CF6);

  // Main background color - Very dark blue/black for the app background
  static const Color backgroundColor = Color(0xFF0F0F14);

  // Surface color - Slightly lighter than background, used for panels/sidebars
  static const Color surfaceColor = Color(0xFF1A1A23);

  // Card color - Used for card components, lighter than surface
  static const Color cardColor = Color(0xFF232331);

  // Border color - Subtle borders between sections
  static const Color borderColor = Color(0xFF2D2D3D);

  // Primary text color - Pure white for main text
  static const Color textPrimary = Color(0xFFFFFFFF);

  // Secondary text color - Muted gray for less important text
  static const Color textSecondary = Color(0xFFA1A1B5);

  // Accent color for success states (e.g., "Secure" badge)
  static const Color accentGreen = Color(0xFF10B981);

  // Accent color for error/danger states
  static const Color accentRed = Color(0xFFEF4444);

  // Accent color for warning states (e.g., "Forecasting" feature)
  static const Color accentYellow = Color(0xFFF59E0B);

  // Accent color for informational states (e.g., "Data Analyzer" feature)
  static const Color accentBlue = Color(0xFF3B82F6);

  /// Getter that returns the complete dark theme configuration
  /// This defines how all Flutter widgets should look throughout the app
  static ThemeData get darkTheme {
    return ThemeData(
      // Use Material 3 design system (latest version)
      useMaterial3: true,

      // Set overall brightness to dark mode
      brightness: Brightness.dark,

      // Background color for Scaffold widgets (main screen background)
      scaffoldBackgroundColor: backgroundColor,

      // Primary color used throughout the app
      primaryColor: primaryColor,

      // Color scheme defines colors for various widget states
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,      // Main interactive elements
        secondary: secondaryColor,  // Secondary interactive elements
        surface: surfaceColor,      // Surfaces like cards and sheets
        background: backgroundColor, // General background
        error: accentRed,           // Error messages and states
      ),

      // Text theme configuration using Google's Inter font
      // Inter is a modern, readable font designed for screens
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: textPrimary,     // Color for body text
        displayColor: textPrimary,  // Color for large display text
      ),

      // Global styling for Card widgets
      cardTheme: CardTheme(
        color: cardColor,           // Background color of cards
        elevation: 0,               // No shadow (flat design)
        // Shape of card with rounded corners and border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // 16px rounded corners
          side: const BorderSide(color: borderColor, width: 1), // 1px border
        ),
      ),

      // Global styling for AppBar widgets (top navigation bar)
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor, // Match main background
        elevation: 0,                     // No shadow (flat)
        centerTitle: false,               // Align title to left (Material style)
        // Custom text style for app bar title
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,    // Semi-bold weight
          color: textPrimary,
        ),
      ),

      // Global styling for ElevatedButton widgets
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,   // Button background color
          foregroundColor: Colors.white,   // Text/icon color on button
          elevation: 0,                    // No shadow (flat)
          // Internal padding inside button
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          // Button shape with rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // Text style for button labels
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,   // Semi-bold
          ),
        ),
      ),

      // Global styling for TextFormField and TextField widgets
      inputDecorationTheme: InputDecorationTheme(
        filled: true,                      // Fill the input background
        fillColor: surfaceColor,           // Background color for input fields

        // Default border (when not focused or enabled)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),

        // Border when field is enabled but not focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),

        // Border when field is focused (user is typing)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2), // Thicker, colored border
        ),

        // Padding inside the input field
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

        // Style for placeholder/hint text
        hintStyle: const TextStyle(color: textSecondary),
      ),

      // Global styling for icons throughout the app
      iconTheme: const IconThemeData(color: textSecondary),
    );
  }
}
