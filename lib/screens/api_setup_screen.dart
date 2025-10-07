import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/openai_service.dart';
import '../config/app_theme.dart';

class ApiSetupScreen extends StatefulWidget {
  const ApiSetupScreen({super.key});

  @override
  State<ApiSetupScreen> createState() => _ApiSetupScreenState();
}

class _ApiSetupScreenState extends State<ApiSetupScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveApiKey() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an API key')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('openai_api_key', _controller.text.trim());

      if (mounted) {
        context.read<OpenAIService>().setApiKey(_controller.text.trim());
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // Title
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
                const Text(
                  'Enter your OpenAI API key to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // API Key Input
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'OpenAI API Key',
                      hintText: 'sk-...',
                      prefixIcon: Icon(Icons.key),
                    ),
                    obscureText: true,
                    onSubmitted: (_) => _saveApiKey(),
                  ),
                ),
                const SizedBox(height: 24),

                // Continue Button
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveApiKey,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Continue'),
                  ),
                ),
                const SizedBox(height: 32),

                // Info Card
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const Text(
                        '1. Visit platform.openai.com/api-keys\n'
                        '2. Sign in or create an account\n'
                        '3. Create a new API key\n'
                        '4. Copy and paste it above',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.5,
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
