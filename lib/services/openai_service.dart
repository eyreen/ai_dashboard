import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  String? _apiKey;
  final String baseUrl = 'https://api.openai.com/v1';

  void setApiKey(String key) {
    _apiKey = key;
  }

  String? get apiKey => _apiKey;

  bool get hasApiKey => _apiKey != null && _apiKey!.isNotEmpty;

  Future<String> chat(List<Map<String, String>> messages, {String model = 'gpt-3.5-turbo'}) async {
    if (!hasApiKey) throw Exception('API key not set');

    final response = await http.post(
      Uri.parse('$baseUrl/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 1000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to get response: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> analyzeData(String data, String query) async {
    final messages = [
      {
        'role': 'system',
        'content': 'You are a data analyst. Analyze the provided data and answer questions about it. Provide insights, patterns, and statistics.'
      },
      {
        'role': 'user',
        'content': 'Data:\n$data\n\nQuestion: $query\n\nProvide a detailed analysis with key insights.'
      }
    ];

    final response = await chat(messages);
    return {'analysis': response};
  }

  Future<String> extractText(String text, String extractionType) async {
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

    return await chat(messages);
  }

  Future<Map<String, dynamic>> forecastTimeSeries(List<double> data, int periods) async {
    final messages = [
      {
        'role': 'system',
        'content': 'You are a data scientist specializing in time series forecasting. Analyze patterns and predict future values.'
      },
      {
        'role': 'user',
        'content': 'Historical data: ${data.join(', ')}\n\nPredict the next $periods values based on the pattern. Provide the forecast as a JSON array of numbers and include a brief explanation of the trend.'
      }
    ];

    final response = await chat(messages);
    return {'forecast': response};
  }

  Future<Map<String, dynamic>> analyzeSentiment(String text) async {
    final messages = [
      {
        'role': 'system',
        'content': 'You are a sentiment analysis expert. Analyze the sentiment of text and provide detailed insights.'
      },
      {
        'role': 'user',
        'content': 'Analyze the sentiment of this text and provide:\n1. Overall sentiment (positive/negative/neutral)\n2. Sentiment score (0-100)\n3. Key emotions detected\n4. Brief explanation\n\nText: $text'
      }
    ];

    final response = await chat(messages);
    return {'sentiment': response};
  }

  Stream<String> chatStream(List<Map<String, String>> messages) async* {
    if (!hasApiKey) throw Exception('API key not set');

    final request = http.Request(
      'POST',
      Uri.parse('$baseUrl/chat/completions'),
    );

    request.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    });

    request.body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': messages,
      'temperature': 0.7,
      'max_tokens': 1000,
      'stream': true,
    });

    final streamedResponse = await request.send();

    await for (var chunk in streamedResponse.stream.transform(utf8.decoder)) {
      final lines = chunk.split('\n');
      for (var line in lines) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') continue;
          try {
            final json = jsonDecode(data);
            final content = json['choices'][0]['delta']['content'];
            if (content != null) {
              yield content;
            }
          } catch (_) {}
        }
      }
    }
  }
}
