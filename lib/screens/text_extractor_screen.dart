import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/openai_service.dart';
import '../core/theme/app_theme.dart';

class TextExtractorScreen extends StatefulWidget {
  const TextExtractorScreen({super.key});

  @override
  State<TextExtractorScreen> createState() => _TextExtractorScreenState();
}

class _TextExtractorScreenState extends State<TextExtractorScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedType = 'names and entities';
  String? _extractedData;
  bool _isLoading = false;

  final List<String> _extractionTypes = [
    'names and entities',
    'dates and times',
    'email addresses and phone numbers',
    'prices and amounts',
    'addresses',
    'key information',
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _extractText() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final openAI = context.read<OpenAIService>();
      final result = await openAI.extractText(
        _textController.text.trim(),
        _selectedType,
      );

      setState(() {
        _extractedData = result;
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
        _buildInputSection(),
        const SizedBox(height: 16),
        if (_extractedData != null) _buildResultsSection(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildInputSection()),
        const SizedBox(width: 24),
        Expanded(child: _buildResultsSection()),
      ],
    );
  }

  Widget _buildInputSection() {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit_note, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Input Text',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText:
                    'Paste your text here...\n\nExample: John Doe sent an email to contact@example.com on March 15, 2024 at 2:30 PM regarding the \$5,000 invoice.',
                hintStyle: TextStyle(fontSize: isMobile ? 12 : 14),
              ),
              maxLines: isMobile ? 8 : 12,
            ),
            const SizedBox(height: 20),
            Text(
              'Extract:',
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _extractionTypes.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(
                    type,
                    style: TextStyle(fontSize: isMobile ? 11 : 13),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedType = type);
                    }
                  },
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: AppTheme.surfaceColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.borderColor,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _extractText,
                icon: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_fix_high),
                label: const Text('Extract Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.list_alt, color: AppTheme.accentGreen),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Extracted Data',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _extractedData == null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 24 : 48),
                      child: Column(
                        children: [
                          Icon(
                            Icons.content_paste_off,
                            size: isMobile ? 40 : 48,
                            color: AppTheme.textSecondary.withOpacity(0.5),
                          ),
                          SizedBox(height: isMobile ? 12 : 16),
                          Text(
                            'No data extracted yet',
                            style: TextStyle(
                              fontSize: isMobile ? 13 : 14,
                              color: AppTheme.textSecondary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: SelectableText(
                      _extractedData!,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: AppTheme.textPrimary,
                        height: 1.6,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
