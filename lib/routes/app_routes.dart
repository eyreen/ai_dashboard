import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/api_setup_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String setup = '/setup';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        setup: (context) => const ApiSetupScreen(),
      };
}
