import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/app_theme.dart';
import 'feature_card.dart';
import 'quick_stat.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1200;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;
    final isMobile = screenWidth < 768;

    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);
    final padding = isMobile ? 16.0 : (isTablet ? 24.0 : 32.0);

    return Container(
      color: AppTheme.backgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.1),
                    AppTheme.secondaryColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to AI Hub',
                              style: TextStyle(
                                fontSize: isMobile ? 22 : 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your intelligent business companion powered by OpenAI',
                              style: TextStyle(
                                fontSize: isMobile ? 13 : 15,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Quick Stats
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const [
                      QuickStat(
                        icon: Icons.chat_bubble,
                        label: '5 AI Features',
                        color: AppTheme.primaryColor,
                      ),
                      QuickStat(
                        icon: Icons.speed,
                        label: 'Real-time',
                        color: AppTheme.accentGreen,
                      ),
                      QuickStat(
                        icon: Icons.security,
                        label: 'Secure',
                        color: AppTheme.accentBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1),

            SizedBox(height: isMobile ? 24 : 32),

            // Section Title
            Text(
              'Explore Features',
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a feature to get started with AI-powered insights',
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: isMobile ? 16 : 24),

            // Feature Cards Grid
            GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: isMobile ? 12 : 20,
              mainAxisSpacing: isMobile ? 12 : 20,
              childAspectRatio: isMobile ? 1.0 : (isTablet ? 1.1 : 1.15),
              children: [
                FeatureCard(
                  icon: Icons.chat_bubble,
                  title: 'AI Chat',
                  description: 'Conversational AI assistant for any task',
                  color: AppTheme.primaryColor,
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  ),
                  imageUrl: 'https://images.unsplash.com/photo-1531746790731-6c087fecd65a?w=400',
                ).animate().fadeIn(delay: 100.ms).scale(begin: const Offset(0.8, 0.8)),
                FeatureCard(
                  icon: Icons.bar_chart,
                  title: 'Data Analyzer',
                  description: 'Upload CSV files for AI-powered insights',
                  color: AppTheme.accentBlue,
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentBlue, Color(0xFF8B5CF6)],
                  ),
                  imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400',
                ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),
                FeatureCard(
                  icon: Icons.text_fields,
                  title: 'Text Extractor',
                  description: 'Extract structured data from text',
                  color: AppTheme.accentGreen,
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentGreen, Color(0xFF059669)],
                  ),
                  imageUrl: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=400',
                ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.8, 0.8)),
                FeatureCard(
                  icon: Icons.show_chart,
                  title: 'Forecasting',
                  description: 'Predict future trends from historical data',
                  color: AppTheme.accentYellow,
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentYellow, Color(0xFFD97706)],
                  ),
                  imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400',
                ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8)),
                FeatureCard(
                  icon: Icons.sentiment_satisfied_alt,
                  title: 'Sentiment Analysis',
                  description: 'Analyze emotions and opinions in text',
                  color: AppTheme.secondaryColor,
                  gradient: const LinearGradient(
                    colors: [AppTheme.secondaryColor, AppTheme.primaryColor],
                  ),
                  imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400',
                ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.8, 0.8)),
                FeatureCard(
                  icon: Icons.auto_awesome,
                  title: 'Coming Soon',
                  description: 'More AI features on the way',
                  color: AppTheme.textSecondary,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4B5563), Color(0xFF6B7280)],
                  ),
                ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.8, 0.8)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
