// Import Flutter's material design package - provides UI components and design system
import 'package:flutter/material.dart';

// Import Provider package - used for state management across the app
import 'package:provider/provider.dart';

// Import SharedPreferences - used to store data locally on the device (like API keys)
import 'package:shared_preferences/shared_preferences.dart';

// Import our custom app theme configuration
import 'config/app_theme.dart';

// Import OpenAI service - handles all API calls to OpenAI
import 'services/openai_service.dart';

// Import app routes - defines navigation paths in the app
import 'routes/app_routes.dart';

/// Entry point of the Flutter application
/// The 'async' keyword allows us to use asynchronous operations in this function
void main() async {
  // Ensure Flutter framework is initialized before running the app
  // This is required when using async operations in main()
  WidgetsFlutterBinding.ensureInitialized();

  // Start the app by running MyApp widget
  runApp(const MyApp());
}

/// Root widget of the application
/// This is a StatelessWidget because it doesn't need to maintain any state
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider wraps the app to provide dependency injection
    // This allows child widgets to access services without passing them down manually
    return MultiProvider(
      // List of providers (services) available throughout the app
      providers: [
        // Make OpenAIService available to all widgets in the app
        Provider(create: (_) => OpenAIService()),
      ],
      // MaterialApp is the root widget that provides Material Design
      child: MaterialApp(
        // App title shown in task switcher on mobile devices
        title: 'AI Business Intelligence',

        // Apply our custom dark theme to the entire app
        theme: AppTheme.darkTheme,

        // Hide the debug banner in top-right corner
        debugShowCheckedModeBanner: false,

        // Set the initial screen to AppInitializer (checks API key on startup)
        home: const AppInitializer(),

        // Define named routes for navigation throughout the app
        routes: AppRoutes.routes,
      ),
    );
  }
}

/// Widget that initializes the app and decides which screen to show first
/// StatefulWidget because it needs to maintain state during the initialization process
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

/// State class for AppInitializer
/// Contains the logic for checking API key and navigating to appropriate screen
class _AppInitializerState extends State<AppInitializer> {

  /// Called once when the widget is first created
  /// This is the perfect place to check for saved API keys
  @override
  void initState() {
    super.initState();
    // Start checking if API key exists in local storage
    _checkApiKey();
  }

  /// Asynchronous function to check if OpenAI API key is saved
  /// Navigates to home screen if key exists, otherwise to setup screen
  Future<void> _checkApiKey() async {
    try {
      // Get instance of SharedPreferences to access local storage
      final prefs = await SharedPreferences.getInstance();

      // Try to retrieve the saved API key from local storage
      final apiKey = prefs.getString('openai_api_key');

      // Check if widget is still mounted (prevents errors if user navigates away)
      if (mounted) {
        // If API key exists and is not empty
        if (apiKey != null && apiKey.isNotEmpty) {
          // Set the API key in OpenAIService so it can be used for API calls
          context.read<OpenAIService>().setApiKey(apiKey);

          // Navigate to home screen, replacing current route (can't go back)
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          // No API key found, navigate to setup screen
          Navigator.of(context).pushReplacementNamed('/setup');
        }
      }
    } catch (e) {
      // If any error occurs (e.g., SharedPreferences fails)
      // Navigate to setup screen to let user enter API key
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/setup');
      }
    }
  }

  /// Build the UI for this widget
  /// Shows a loading screen while checking for API key
  @override
  Widget build(BuildContext context) {
    // Scaffold provides basic app structure (background, etc.)
    return Scaffold(
      body: Center(
        // Column arranges children vertically
        child: Column(
          // Center content vertically
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo container with gradient background
            Container(
              width: 80,
              height: 80,
              // BoxDecoration adds styling to the container
              decoration: BoxDecoration(
                // Linear gradient from primary to secondary color
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // Rounded corners with 20 pixel radius
                borderRadius: BorderRadius.circular(20),
              ),
              // Icon displayed inside the container
              child: const Icon(
                Icons.auto_awesome, // Star/sparkle icon
                size: 40,
                color: Colors.white,
              ),
            ),
            // Vertical spacing of 32 pixels
            const SizedBox(height: 32),

            // Circular loading spinner
            const CircularProgressIndicator(),

            // Vertical spacing of 16 pixels
            const SizedBox(height: 16),

            // Loading text below the spinner
            const Text(
              'Loading...',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
