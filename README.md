# AI Business Intelligence Dashboard

A modern, feature-rich AI-powered business intelligence application built with Flutter and OpenAI API. Inspired by design principles from leading tech brands like Stripe, Linear, and Vercel.

## ✨ Features

### 1. **AI Chat Assistant**
- Real-time conversational AI
- Chat history management
- Clean, modern chat interface
- Streaming responses

### 2. **Data Analyzer**
- Upload CSV files
- AI-powered data insights
- Interactive data visualization
- Ask questions about your data
- Preview data in tables

### 3. **Text Extractor**
- Extract structured data from unstructured text
- Multiple extraction types:
  - Names and entities
  - Dates and times
  - Email addresses and phone numbers
  - Prices and amounts
  - Addresses
  - Key information

### 4. **Time Series Forecasting**
- Predict future trends from historical data
- Visual chart representation
- AI-powered pattern analysis
- Customizable forecast periods

### 5. **Sentiment Analysis**
- Analyze emotions and opinions in text
- Customer feedback analysis
- Social media sentiment monitoring
- Detailed emotion detection

## 🎨 Design

Modern dark theme with:
- Clean, minimal interface
- Smooth animations
- Responsive layout
- Professional color palette
- Google Fonts (Inter)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.3.0 or higher)
- OpenAI API Key ([Get one here](https://platform.openai.com/api-keys))

### Installation

1. Navigate to the project directory:
```bash
cd flutter_test/ai_dashboard
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### First Launch

1. On first launch, you'll be prompted to enter your OpenAI API key
2. Visit [platform.openai.com/api-keys](https://platform.openai.com/api-keys) to get your key
3. Enter the key and click "Continue"
4. Start exploring the AI features!

## 📱 Supported Platforms

- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Web
- ✅ iOS
- ✅ Android

## 🛠️ Tech Stack

- **Framework:** Flutter
- **State Management:** Provider
- **API:** OpenAI GPT-3.5-turbo
- **Charts:** FL Chart
- **Fonts:** Google Fonts (Inter)
- **Storage:** Shared Preferences
- **File Handling:** File Picker
- **CSV Parsing:** CSV package

## 📦 Dependencies

```yaml
http: ^1.2.0
provider: ^6.1.1
fl_chart: ^0.66.0
file_picker: ^6.1.1
csv: ^6.0.0
shared_preferences: ^2.2.2
google_fonts: ^6.1.0
flutter_animate: ^4.5.0
```

## 🎯 Use Cases

- **Business Analytics:** Analyze sales data, customer feedback, and trends
- **Customer Support:** Sentiment analysis of support tickets
- **Marketing:** Social media sentiment monitoring
- **Finance:** Time series forecasting for revenue predictions
- **Data Processing:** Extract structured information from documents

## 🔒 Security

- API keys are stored locally using SharedPreferences
- No data is stored on external servers except OpenAI API calls
- All data processing happens client-side

## 📝 License

This project is created for demonstration purposes.

## 🤝 Contributing

Feel free to fork, modify, and use this project for your own purposes!

## 📧 Support

For issues or questions, please check the OpenAI API documentation or Flutter documentation.

---

**Built with ❤️ using Flutter and OpenAI**
