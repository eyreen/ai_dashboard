# Quick Start Guide

## 🚀 Running the App

### 1. Navigate to the project
```bash
cd flutter_test/ai_dashboard
```

### 2. Run the app
```bash
flutter run
```

Choose your target device:
- Windows: Press `1` (or the number corresponding to Windows)
- Web: Press the number for Chrome
- Mobile: Connect device and select it

### 3. Enter your OpenAI API Key

On first launch:
1. The app will show an API key setup screen
2. Get your API key from: https://platform.openai.com/api-keys
3. Enter the key (starts with `sk-...`)
4. Click "Continue"

### 4. Start Using the Features!

Navigate using the sidebar:
- **Dashboard** - Overview of all features
- **Chat** - Talk with AI assistant
- **Data Analyzer** - Upload and analyze CSV files
- **Text Extractor** - Extract data from text
- **Forecasting** - Predict future trends
- **Sentiment** - Analyze text sentiment

## 📝 Example Use Cases

### Chat Assistant
```
Type: "Explain quantum computing in simple terms"
```

### Data Analyzer
1. Click "Upload CSV"
2. Select a CSV file (e.g., sales_data.csv)
3. Ask: "What are the top trends in this data?"

### Text Extractor
1. Paste text like:
   ```
   John Doe (john@example.com) ordered $150 worth of items on March 15, 2024.
   ```
2. Select "email addresses and phone numbers"
3. Click "Extract Data"

### Forecasting
1. Enter data: `100, 120, 115, 140, 135, 160, 155, 180`
2. Set periods: `5`
3. Click "Parse Data" then "Forecast"

### Sentiment Analysis
1. Paste customer review text
2. Click "Analyze Sentiment"
3. View emotional analysis and sentiment score

## 🎨 Keyboard Shortcuts

- `Ctrl/Cmd + R` - Hot reload (while developing)
- `Ctrl/Cmd + Q` - Quit app

## 🐛 Troubleshooting

### "API key error"
- Verify your OpenAI API key is correct
- Check you have credits in your OpenAI account
- Make sure the key starts with `sk-`

### "File picker not working"
- On web, make sure pop-ups aren't blocked
- On desktop, file picker should work automatically

### "Network error"
- Check your internet connection
- Verify OpenAI API is accessible from your location

## 💡 Tips

- The app works best with a stable internet connection
- API calls cost money - check your OpenAI pricing
- All data is processed on-demand (not stored)
- You can change your API key by going to Settings

## 🎯 Build for Production

### Windows
```bash
flutter build windows
```

### Web
```bash
flutter build web
```

### Mobile
```bash
flutter build apk  # Android
flutter build ios  # iOS (requires macOS)
```

Enjoy exploring the AI Business Intelligence Dashboard! 🎉
