// Import Flutter's material package for UI components
import 'package:flutter/material.dart';

// Import Provider for state management (accessing OpenAIService)
import 'package:provider/provider.dart';

// Import SharedPreferences for local storage (saving API key)
import 'package:shared_preferences/shared_preferences.dart';

// Import our OpenAI service to set the API key
import '../services/openai_service.dart';

// Import app theme for colors
import '../config/app_theme.dart';

/// ApiSetupScreen is where users enter their OpenAI API key
/// This is the first screen shown when the app launches (if no key is saved)
/// StatefulWidget because it needs to manage loading state and text input
class ApiSetupScreen extends StatefulWidget {
  const ApiSetupScreen({super.key});

  @override
  State<ApiSetupScreen> createState() => _ApiSetupScreenState();
}

/// State class for ApiSetupScreen
/// Manages the API key input and saving process
class _ApiSetupScreenState extends State<ApiSetupScreen> {
  // TextEditingController manages the text field's content
  // We can read the current text value and listen to changes
  final _controller = TextEditingController();

  // Boolean to track if we're currently saving the API key
  // Used to show loading spinner and disable button during save
  bool _isLoading = false;

  /// dispose() is called when this widget is removed from the widget tree
  /// IMPORTANT: Always dispose controllers to prevent memory leaks!
  @override
  void dispose() {
    _controller.dispose();  // Free up resources used by the controller
    super.dispose();        // Call parent class dispose
  }

  /// Saves the API key to local storage and navigates to home screen
  /// This is an async function because saving to storage takes time
  Future<void> _saveApiKey() async {
    // Validate: check if the text field is not empty
    // trim() removes leading/trailing whitespace
    if (_controller.text.trim().isEmpty) {
      // Show error message using SnackBar (toast notification at bottom)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an API key')),
      );
      return;  // Exit the function early
    }

    // Update UI to show loading state
    // setState() tells Flutter to rebuild the widget with new values
    setState(() => _isLoading = true);

    try {
      // Get SharedPreferences instance to access local storage
      final prefs = await SharedPreferences.getInstance();

      // Save the API key to local storage with key 'openai_api_key'
      // This persists even after the app is closed
      await prefs.setString('openai_api_key', _controller.text.trim());

      // Check if widget is still mounted (user hasn't navigated away)
      // This prevents errors if user navigates during async operation
      if (mounted) {
        // Update the OpenAIService with the new API key
        // context.read<T>() gets the nearest Provider of type T
        context.read<OpenAIService>().setApiKey(_controller.text.trim());

        // Navigate to home screen, replacing current screen
        // pushReplacementNamed removes setup screen from navigation stack
        // so user can't go back to it with back button
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      // If any error occurs during save, show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      // finally block always runs, even if there's an error
      // Reset loading state
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Build the UI for the setup screen
  @override
  Widget build(BuildContext context) {
    // Scaffold provides basic app structure
    return Scaffold(
      // SafeArea prevents content from overlapping system UI (notches, status bar)
      body: SafeArea(
        // Center the content horizontally
        child: Center(
          // SingleChildScrollView allows scrolling if content is too tall
          // Useful on small screens or landscape orientation
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),  // Padding around all content

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  // Center vertically

              children: [
                // ==========================================
                // APP LOGO
                // ==========================================
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    // Gradient background from primary to secondary color
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // Star/sparkle icon inside
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 40,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 32),  // Vertical spacing

                // ==========================================
                // TITLE
                // ==========================================
                const Text(
                  'AI Business Intelligence',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // ==========================================
                // SUBTITLE
                // ==========================================
                const Text(
                  'Enter your OpenAI API key to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // ==========================================
                // API KEY INPUT FIELD
                // ==========================================
                // Container with maxWidth constraint for better layout on wide screens
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),

                  child: TextField(
                    controller: _controller,  // Link to our TextEditingController

                    // InputDecoration styles the text field
                    decoration: const InputDecoration(
                      labelText: 'OpenAI API Key',  // Floating label above field
                      hintText: 'sk-...',            // Placeholder text inside field
                      prefixIcon: Icon(Icons.key),   // Key icon on the left
                    ),

                    // obscureText: true hides the text (shows dots/asterisks)
                    // Good for sensitive data like passwords and API keys
                    obscureText: true,

                    // onSubmitted is called when user presses Enter/Return
                    // The (_) ignores the submitted text value (we get it from controller)
                    onSubmitted: (_) => _saveApiKey(),
                  ),
                ),

                const SizedBox(height: 24),

                // ==========================================
                // CONTINUE BUTTON
                // ==========================================
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  width: double.infinity,  // Full width of container

                  child: ElevatedButton(
                    // Disable button when loading (null makes it grayed out)
                    onPressed: _isLoading ? null : _saveApiKey,

                    // Show spinner when loading, otherwise show "Continue" text
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            // CircularProgressIndicator is a loading spinner
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Continue'),
                  ),
                ),

                const SizedBox(height: 32),

                // ==========================================
                // INFO CARD - Instructions for getting API key
                // ==========================================
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(16),

                  // Styled box with border and background
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderColor),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // Header with info icon and title
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'How to get your API key',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Step-by-step instructions
                      const Text(
                        '1. Visit platform.openai.com/api-keys\n'
                        '2. Sign in or create an account\n'
                        '3. Create a new API key\n'
                        '4. Copy and paste it above',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.5,  // Line height for readability
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
