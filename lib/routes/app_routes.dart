// Import Flutter material package for navigation widgets
import 'package:flutter/material.dart';

// Import the screens that we'll navigate to
import '../screens/home_screen.dart';
import '../screens/api_setup_screen.dart';

/// AppRoutes class manages all navigation routes in the application
/// Routes are named paths that allow navigation between different screens
/// This centralizes route definitions for easier maintenance
class AppRoutes {
  // ============================================
  // ROUTE NAMES - Constants for type-safe navigation
  // Using constants prevents typos when navigating
  // ============================================

  /// Route name for the home/dashboard screen
  /// Usage: Navigator.pushNamed(context, AppRoutes.home)
  static const String home = '/home';

  /// Route name for the API key setup screen
  /// This is where users enter their OpenAI API key
  static const String setup = '/setup';

  /// Map of route names to widget builders
  /// WidgetBuilder is a function that takes BuildContext and returns a Widget
  /// Flutter uses this map to know which screen to show for each route
  ///
  /// When you call Navigator.pushNamed(context, '/home'):
  /// 1. Flutter looks up '/home' in this map
  /// 2. Finds the builder function: (context) => const HomeScreen()
  /// 3. Calls the function to create the HomeScreen widget
  /// 4. Displays the screen
  static Map<String, WidgetBuilder> get routes => {
        // When navigating to '/home', show the HomeScreen widget
        home: (context) => const HomeScreen(),

        // When navigating to '/setup', show the ApiSetupScreen widget
        setup: (context) => const ApiSetupScreen(),
      };
}
