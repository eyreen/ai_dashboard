import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/openai_service.dart';
import '../config/app_theme.dart';

class SentimentScreen extends StatefulWidget {
  const SentimentScreen({super.key});

  @override
  State<SentimentScreen> createState() => _SentimentScreenState();
}

class _SentimentScreenState extends State<SentimentScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _sentimentResult;
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _loadSampleText() {
    setState(() {
      _textController.text =
          "I absolutely love this product! The customer service was amazing and the quality exceeded my expectations. "
          "However, the delivery took a bit longer than promised, which was slightly disappointing. "
          "Overall, I'm very happy with my purchase and would definitely recommend it to others!";
    });
  }

  Future<void> _analyzeSentiment() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text to analyze')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final openAI = context.read<OpenAIService>();
      final result = await openAI.analyzeSentiment(_textController.text.trim());

      setState(() {
        _sentimentResult = result['sentiment'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Column(
      children: [
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputSection(true),
        const SizedBox(height: 16),
        if (_sentimentResult != null) _buildResultsSection(true),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildInputSection(false)),
        const SizedBox(width: 24),
        Expanded(child: _buildResultsSection(false)),
      ],
    );
  }

  Widget _buildInputSection(bool isMobile) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit_note,
                    color: AppTheme.secondaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Text to Analyze',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _loadSampleText,
                  icon: const Icon(Icons.text_snippet, size: 16),
                  label: Text(
                    isMobile ? 'Sample' : 'Load Sample',
                    style: TextStyle(fontSize: isMobile ? 12 : 14),
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText:
                    'Enter text to analyze sentiment...\n\nExamples:\n- Customer reviews\n- Social media posts\n- Feedback comments\n- Survey responses',
                hintStyle: TextStyle(fontSize: isMobile ? 12 : 14),
              ),
              maxLines: isMobile ? 8 : 15,
            ),
            SizedBox(height: isMobile ? 16 : 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _analyzeSentiment,
                icon: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.analytics),
                label: Text(_isLoading ? 'Analyzing...' : 'Analyze Sentiment'),
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Container(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Use Cases',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                          fontSize: isMobile ? 13 : 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 6 : 8),
                  Text(
                    '• Analyze customer feedback and reviews\n'
                    '• Monitor brand sentiment on social media\n'
                    '• Evaluate survey responses\n'
                    '• Detect emotions in customer support tickets',
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 13,
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection(bool isMobile) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: AppTheme.secondaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Analysis Results',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            _sentimentResult == null
                ? _buildEmptyState(isMobile)
                : _buildResults(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isMobile) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 24 : 48),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.secondaryColor.withOpacity(0.1),
                    AppTheme.primaryColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.secondaryColor.withOpacity(0.3),
                ),
              ),
              child: Icon(
                Icons.sentiment_neutral,
                size: isMobile ? 48 : 64,
                color: AppTheme.secondaryColor,
              ),
            ),
            SizedBox(height: isMobile ? 16 : 24),
            Text(
              'No analysis yet',
              style: TextStyle(
                fontSize: isMobile ? 15 : 16,
                color: AppTheme.textSecondary.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: isMobile ? 6 : 8),
            Text(
              'Enter text and click analyze',
              style: TextStyle(
                fontSize: isMobile ? 12 : 14,
                color: AppTheme.textSecondary.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sentiment Indicators
        isMobile
            ? Column(
                children: [
                  _SentimentIndicator(
                    icon: Icons.sentiment_very_satisfied,
                    label: 'Positive',
                    color: AppTheme.accentGreen,
                    isMobile: true,
                  ),
                  const SizedBox(height: 8),
                  _SentimentIndicator(
                    icon: Icons.sentiment_neutral,
                    label: 'Neutral',
                    color: AppTheme.accentYellow,
                    isMobile: true,
                  ),
                  const SizedBox(height: 8),
                  _SentimentIndicator(
                    icon: Icons.sentiment_dissatisfied,
                    label: 'Negative',
                    color: AppTheme.accentRed,
                    isMobile: true,
                  ),
                ],
              )
            : Row(
                children: [
                  _SentimentIndicator(
                    icon: Icons.sentiment_very_satisfied,
                    label: 'Positive',
                    color: AppTheme.accentGreen,
                    isMobile: false,
                  ),
                  const SizedBox(width: 12),
                  _SentimentIndicator(
                    icon: Icons.sentiment_neutral,
                    label: 'Neutral',
                    color: AppTheme.accentYellow,
                    isMobile: false,
                  ),
                  const SizedBox(width: 12),
                  _SentimentIndicator(
                    icon: Icons.sentiment_dissatisfied,
                    label: 'Negative',
                    color: AppTheme.accentRed,
                    isMobile: false,
                  ),
                ],
              ),
        SizedBox(height: isMobile ? 16 : 24),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: SelectableText(
            _sentimentResult!,
            style: TextStyle(
              fontSize: isMobile ? 13 : 14,
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _SentimentIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isMobile;

  const _SentimentIndicator({
    required this.icon,
    required this.label,
    required this.color,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        : Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(icon, color: color, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
