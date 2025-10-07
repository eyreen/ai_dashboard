// Import dart:convert for JSON encoding/decoding
import 'dart:convert';

// Import http package for making API requests
// Using 'as http' creates a namespace to avoid naming conflicts
import 'package:http/http.dart' as http;

/// OpenAIService handles all communication with OpenAI's API
/// This service class encapsulates API calls and manages the API key
/// It provides methods for different AI features: chat, data analysis, forecasting, etc.
class OpenAIService {
  // ============================================
  // PRIVATE FIELDS
  // ============================================

  /// Private API key storage (the ? means it can be null)
  /// The underscore (_) makes this field private to this class
  String? _apiKey;

  /// OpenAI API base URL - all endpoints start with this URL
  /// This is public and immutable (final)
  final String baseUrl = 'https://api.openai.com/v1';

  // ============================================
  // API KEY MANAGEMENT
  // ============================================

  /// Set the API key for authentication
  /// Called when user enters their API key in the setup screen
  void setApiKey(String key) {
    _apiKey = key;
  }

  /// Getter to retrieve the current API key
  /// Returns null if no key is set
  String? get apiKey => _apiKey;

  /// Check if a valid API key is set
  /// Returns true only if API key exists and is not empty
  bool get hasApiKey => _apiKey != null && _apiKey!.isNotEmpty;

  // ============================================
  // CHAT COMPLETION - Core AI conversation method
  // ============================================

  /// Send messages to OpenAI and get a text response
  ///
  /// Parameters:
  /// - messages: List of conversation messages with 'role' and 'content'
  ///   Example: [{'role': 'user', 'content': 'Hello!'}]
  /// - model: Which AI model to use (default: gpt-3.5-turbo)
  ///
  /// Returns: The AI's response as a String
  /// Throws: Exception if API key is not set or request fails
  Future<String> chat(List<Map<String, String>> messages, {String model = 'gpt-3.5-turbo'}) async {
    // Verify API key exists before making request
    if (!hasApiKey) throw Exception('API key not set');

    // Make HTTP POST request to OpenAI's chat completions endpoint
    final response = await http.post(
      // Parse the full URL string into a Uri object
      Uri.parse('$baseUrl/chat/completions'),

      // Headers provide metadata about the request
      headers: {
        'Content-Type': 'application/json',  // We're sending JSON data
        'Authorization': 'Bearer $_apiKey',  // Authentication with API key
      },

      // Request body contains the actual data we're sending
      // jsonEncode converts the Map to a JSON string
      body: jsonEncode({
        'model': model,            // Which AI model to use
        'messages': messages,      // The conversation history
        'temperature': 0.7,        // Creativity (0-2, higher = more creative)
        'max_tokens': 1000,        // Maximum length of response
      }),
    );

    // Check if request was successful (HTTP 200 OK)
    if (response.statusCode == 200) {
      // Parse the JSON response body into a Map
      final data = jsonDecode(response.body);

      // Extract the AI's message from the nested JSON structure
      // data['choices'] is an array, we take the first [0] element
      // Then navigate to ['message']['content'] to get the text
      return data['choices'][0]['message']['content'];
    } else {
      // Request failed - throw an exception with error details
      throw Exception('Failed to get response: ${response.body}');
    }
  }

  // ============================================
  // DATA ANALYSIS FEATURE
  // ============================================

  /// Analyze data and answer questions about it
  ///
  /// Parameters:
  /// - data: String containing the data to analyze (e.g., CSV data)
  /// - query: Question to ask about the data
  ///
  /// Returns: Map with 'analysis' key containing the AI's insights
  Future<Map<String, dynamic>> analyzeData(String data, String query) async {
    // Construct the conversation messages
    // System message defines the AI's role/behavior
    // User message provides the actual task
    final messages = [
      {
        'role': 'system',  // System messages set the AI's personality/instructions
        'content': 'You are a data analyst. Analyze the provided data and answer questions about it. Provide insights, patterns, and statistics.'
      },
      {
        'role': 'user',    // User messages are requests from the user
        'content': 'Data:\n$data\n\nQuestion: $query\n\nProvide a detailed analysis with key insights.'
      }
    ];

    // Use the chat method to get response
    final response = await chat(messages);

    // Return response wrapped in a Map for consistency
    return {'analysis': response};
  }

  // ============================================
  // TEXT EXTRACTION FEATURE
  // ============================================

  /// Extract structured information from unstructured text
  ///
  /// Parameters:
  /// - text: The unstructured text to process
  /// - extractionType: What to extract (e.g., "emails", "phone numbers", "dates")
  ///
  /// Returns: Extracted and structured information as a String
  Future<String> extractText(String text, String extractionType) async {
    // Define the AI's role as a text extraction expert
    final messages = [
      {
        'role': 'system',
        'content': 'You are a text extraction expert. Extract structured information from unstructured text.'
      },
      {
        'role': 'user',
        'content': 'Extract $extractionType from the following text. Format the output as structured data:\n\n$text'
      }
    ];

    // Return the extracted information
    return await chat(messages);
  }

  // ============================================
  // TIME SERIES FORECASTING FEATURE
  // ============================================

  /// Predict future values based on historical data
  ///
  /// Parameters:
  /// - data: List of historical numerical values
  /// - periods: How many future periods to predict
  ///
  /// Returns: Map with 'forecast' key containing predictions and explanation
  Future<Map<String, dynamic>> forecastTimeSeries(List<double> data, int periods) async {
    // Instruct AI to act as a forecasting specialist
    final messages = [
      {
        'role': 'system',
        'content': 'You are a data scientist specializing in time series forecasting. Analyze patterns and predict future values.'
      },
      {
        'role': 'user',
        // Join the data array into a comma-separated string
        'content': 'Historical data: ${data.join(', ')}\n\nPredict the next $periods values based on the pattern. Provide the forecast as a JSON array of numbers and include a brief explanation of the trend.'
      }
    ];

    final response = await chat(messages);
    return {'forecast': response};
  }

  // ============================================
  // SENTIMENT ANALYSIS FEATURE
  // ============================================

  /// Analyze the sentiment and emotions in text
  ///
  /// Parameters:
  /// - text: The text to analyze for sentiment
  ///
  /// Returns: Map with 'sentiment' key containing sentiment analysis
  Future<Map<String, dynamic>> analyzeSentiment(String text) async {
    // Set up AI as a sentiment analysis expert
    final messages = [
      {
        'role': 'system',
        'content': 'You are a sentiment analysis expert. Analyze the sentiment of text and provide detailed insights.'
      },
      {
        'role': 'user',
        // Request structured sentiment analysis output
        'content': 'Analyze the sentiment of this text and provide:\n1. Overall sentiment (positive/negative/neutral)\n2. Sentiment score (0-100)\n3. Key emotions detected\n4. Brief explanation\n\nText: $text'
      }
    ];

    final response = await chat(messages);
    return {'sentiment': response};
  }

  // ============================================
  // STREAMING CHAT - For real-time responses
  // ============================================

  /// Chat with AI using streaming (word-by-word response)
  /// This creates a more interactive experience as the AI responds
  ///
  /// async* means this is a generator function that yields multiple values over time
  /// Stream<String> means it returns a stream of text chunks
  ///
  /// Parameters:
  /// - messages: List of conversation messages
  ///
  /// Yields: Individual text chunks as they arrive from the API
  Stream<String> chatStream(List<Map<String, String>> messages) async* {
    // Check API key
    if (!hasApiKey) throw Exception('API key not set');

    // Create a streaming HTTP request (not a simple POST)
    final request = http.Request(
      'POST',
      Uri.parse('$baseUrl/chat/completions'),
    );

    // Add headers for authentication and content type
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    });

    // Add request body with 'stream: true' to enable streaming
    request.body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': messages,
      'temperature': 0.7,
      'max_tokens': 1000,
      'stream': true,  // THIS enables streaming responses!
    });

    // Send the request and get a streamed response
    final streamedResponse = await request.send();

    // Listen to the stream of data chunks as they arrive
    // utf8.decoder converts raw bytes to UTF-8 text
    await for (var chunk in streamedResponse.stream.transform(utf8.decoder)) {
      // Split chunk into individual lines (OpenAI sends line-by-line)
      final lines = chunk.split('\n');

      // Process each line
      for (var line in lines) {
        // OpenAI's streaming format: each line starts with "data: "
        if (line.startsWith('data: ')) {
          // Remove "data: " prefix to get JSON
          final data = line.substring(6);

          // Skip the final "[DONE]" message
          if (data == '[DONE]') continue;

          try {
            // Parse the JSON data
            final json = jsonDecode(data);

            // Extract the text content from the delta (incremental update)
            final content = json['choices'][0]['delta']['content'];

            // If there's content, yield it (send it to the stream listener)
            if (content != null) {
              yield content;  // 'yield' is like 'return' but for streams
            }
          } catch (_) {
            // Ignore parsing errors (malformed chunks)
          }
        }
      }
    }
  }
}
