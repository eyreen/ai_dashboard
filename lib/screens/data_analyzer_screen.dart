import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import '../services/openai_service.dart';
import '../core/theme/app_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DataAnalyzerScreen extends StatefulWidget {
  const DataAnalyzerScreen({super.key});

  @override
  State<DataAnalyzerScreen> createState() => _DataAnalyzerScreenState();
}

class _DataAnalyzerScreenState extends State<DataAnalyzerScreen> {
  List<List<dynamic>>? _csvData;
  String? _fileName;
  String? _analysis;
  bool _isLoading = false;
  bool _isUploading = false;
  final TextEditingController _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    setState(() => _isUploading = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true, // Ensure we get bytes for web
      );

      print('File picker result: $result');

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        print('File selected: ${file.name}, size: ${file.size}, bytes null: ${file.bytes == null}');

        // Get CSV data - withData ensures bytes are loaded
        if (file.bytes == null) {
          throw Exception('Unable to read file data. Please try again.');
        }

        final csvString = utf8.decode(file.bytes!);
        print('CSV string length: ${csvString.length}');

        final csv = const CsvToListConverter().convert(csvString);
        print('CSV parsed: ${csv.length} rows');

        if (csv.isEmpty) {
          throw Exception('CSV file is empty');
        }

        setState(() {
          _csvData = csv;
          _fileName = file.name;
          _analysis = null;
          _isUploading = false;
        });

        print('State updated, _csvData length: ${_csvData?.length}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('✓ Loaded ${file.name} (${csv.length} rows)'),
                  ),
                ],
              ),
              backgroundColor: AppTheme.accentGreen,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        print('No file selected or result is null');
        setState(() => _isUploading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No file selected'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('Error loading CSV: $e');
      print('Stack trace: $stackTrace');
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading file: $e'),
            backgroundColor: AppTheme.accentRed,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _analyzeData() async {
    if (_csvData == null || _queryController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final openAI = context.read<OpenAIService>();
      final dataPreview = _csvData!.take(20).map((row) => row.join(', ')).join('\n');
      final query = _queryController.text.trim();

      final result = await openAI.analyzeData(dataPreview, query);

      setState(() {
        _analysis = result['analysis'];
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
            child: _csvData == null
                ? _buildEmptyState(isMobile)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDataPreview(isMobile),
                      SizedBox(height: isMobile ? 16 : 24),
                      _buildQuerySection(isMobile),
                      if (_analysis != null) ...[
                        SizedBox(height: isMobile ? 16 : 24),
                        _buildAnalysisResult(isMobile),
                      ],
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isMobile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 24 : 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentBlue.withOpacity(0.1),
                  AppTheme.secondaryColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.accentBlue.withOpacity(0.3),
              ),
            ),
            child: Icon(
              Icons.cloud_upload_outlined,
              size: isMobile ? 48 : 64,
              color: AppTheme.accentBlue,
            ),
          ),
          SizedBox(height: isMobile ? 20 : 24),
          Text(
            'Upload a CSV file to begin',
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: isMobile ? 6 : 8),
          Text(
            'Upload your data and ask questions about it',
            style: TextStyle(
              fontSize: isMobile ? 13 : 14,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 24 : 32),
          ElevatedButton.icon(
            onPressed: _isUploading ? null : _pickFile,
            icon: _isUploading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.upload_file),
            label: Text(_isUploading ? 'Uploading...' : 'Upload CSV File'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 32,
                vertical: isMobile ? 16 : 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataPreview(bool isMobile) {
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
                    color: AppTheme.accentBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.table_chart,
                    color: AppTheme.accentBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fileName ?? 'Data Preview',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_csvData!.length} rows × ${_csvData!.first.length} columns',
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isMobile)
                  IconButton(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.upload_file),
                    tooltip: 'Upload new file',
                  ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(
                    AppTheme.surfaceColor,
                  ),
                  dataRowMinHeight: isMobile ? 40 : 48,
                  dataRowMaxHeight: isMobile ? 40 : 48,
                  headingRowHeight: isMobile ? 44 : 56,
                  columns: _csvData!.first
                      .map((col) => DataColumn(
                            label: Text(
                              col.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                                fontSize: isMobile ? 12 : 14,
                              ),
                            ),
                          ))
                      .toList(),
                  rows: _csvData!
                      .skip(1)
                      .take(isMobile ? 5 : 10)
                      .map(
                        (row) => DataRow(
                          cells: row
                              .map((cell) => DataCell(
                                    Text(
                                      cell.toString(),
                                      style: TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: isMobile ? 11 : 13,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            if (isMobile) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.upload_file, size: 18),
                  label: const Text('Upload New File'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuerySection(bool isMobile) {
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
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Ask a Question',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            TextField(
              controller: _queryController,
              decoration: InputDecoration(
                hintText: 'e.g., What are the key trends in this data?',
                hintStyle: TextStyle(fontSize: isMobile ? 12 : 14),
              ),
              maxLines: isMobile ? 2 : 3,
            ),
            SizedBox(height: isMobile ? 12 : 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _analyzeData,
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
                label: Text(_isLoading ? 'Analyzing...' : 'Analyze Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResult(bool isMobile) {
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
                    color: AppTheme.accentGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: AppTheme.accentGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Analysis Results',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Container(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: SelectableText(
                _analysis!,
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
