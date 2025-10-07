import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_theme.dart';
import 'chat_screen.dart';
import 'data_analyzer_screen.dart';
import 'text_extractor_screen.dart';
import 'forecasting_screen.dart';
import 'sentiment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const DashboardOverview(),
    const ChatScreen(),
    const DataAnalyzerScreen(),
    const TextExtractorScreen(),
    const ForecastingScreen(),
    const SentimentScreen(),
  ];

  final List<NavItem> _navItems = [
    NavItem(Icons.dashboard_outlined, 'Dashboard', Icons.dashboard),
    NavItem(Icons.chat_bubble_outline, 'Chat', Icons.chat_bubble),
    NavItem(Icons.bar_chart_outlined, 'Data Analyzer', Icons.bar_chart),
    NavItem(Icons.text_fields_outlined, 'Text Extractor', Icons.text_fields),
    NavItem(Icons.show_chart_outlined, 'Forecasting', Icons.show_chart),
    NavItem(Icons.sentiment_satisfied_outlined, 'Sentiment', Icons.sentiment_satisfied_alt),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      key: _scaffoldKey,
      // Mobile: Use drawer instead of persistent sidebar
      drawer: isMobile
          ? Drawer(
              backgroundColor: AppTheme.surfaceColor,
              child: SafeArea(
                child: _buildSidebarContent(true),
              ),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            // Desktop/Tablet: Collapsible sidebar
            if (!isMobile)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isSidebarExpanded ? 240 : 70,
                color: AppTheme.surfaceColor,
                child: _buildSidebarContent(false),
              ),

            // Main Content
            Expanded(
              child: Column(
                children: [
                  // Mobile/Desktop App Bar
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 24,
                      vertical: isMobile ? 16 : 20,
                    ),
                    decoration: const BoxDecoration(
                      color: AppTheme.backgroundColor,
                      border: Border(
                        bottom: BorderSide(color: AppTheme.borderColor),
                      ),
                    ),
                    child: Row(
                      children: [
                        if (isMobile)
                          IconButton(
                            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                            icon: const Icon(Icons.menu),
                            color: AppTheme.textPrimary,
                            iconSize: 28,
                          ),
                        if (isMobile) const SizedBox(width: 8),
                        Container(
                          width: isMobile ? 36 : 40,
                          height: isMobile ? 36 : 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: isMobile ? 20 : 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _navItems[_selectedIndex].label,
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        // Quick action button
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () => _showSettings(context),
                            icon: const Icon(Icons.settings_outlined),
                            color: AppTheme.primaryColor,
                            tooltip: 'Settings',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Screen Content
                  Expanded(
                    child: _screens[_selectedIndex],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarContent(bool isDrawer) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Column(
      children: [
        // Logo/Header
        Container(
          padding: EdgeInsets.all(_isSidebarExpanded || isDrawer ? 24 : 16),
          child: Row(
            mainAxisAlignment: _isSidebarExpanded || isDrawer
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
              ),
              if (_isSidebarExpanded || isDrawer) ...[
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'AI Hub',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const Divider(color: AppTheme.borderColor, height: 1),

        // Toggle button (desktop only)
        if (!isDrawer && !isMobile)
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _isSidebarExpanded = !_isSidebarExpanded;
                });
              },
              icon: Icon(
                _isSidebarExpanded ? Icons.chevron_left : Icons.chevron_right,
                color: AppTheme.textSecondary,
              ),
              tooltip: _isSidebarExpanded ? 'Collapse' : 'Expand',
            ),
          ),

        // Navigation Items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _navItems.length,
            itemBuilder: (context, index) {
              final item = _navItems[index];
              final isSelected = _selectedIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Tooltip(
                  message: !_isSidebarExpanded && !isDrawer ? item.label : '',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() => _selectedIndex = index);
                        if (isDrawer) {
                          Navigator.pop(context); // Close drawer on mobile
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: _isSidebarExpanded || isDrawer ? 16 : 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryColor.withOpacity(0.3)
                                : Colors.transparent,
                          ),
                        ),
                        child: _isSidebarExpanded || isDrawer
                            ? Row(
                                children: [
                                  Icon(
                                    isSelected ? item.activeIcon : item.icon,
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : AppTheme.textSecondary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppTheme.primaryColor
                                            : AppTheme.textSecondary,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Icon(
                                  isSelected ? item.activeIcon : item.icon,
                                  color: isSelected
                                      ? AppTheme.primaryColor
                                      : AppTheme.textSecondary,
                                  size: 20,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Settings/Profile Section
        const Divider(color: AppTheme.borderColor, height: 1),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (isDrawer) Navigator.pop(context);
                _showSettings(context);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.all(_isSidebarExpanded || isDrawer ? 12 : 8),
                child: _isSidebarExpanded || isDrawer
                    ? const Row(
                        children: [
                          Icon(
                            Icons.settings_outlined,
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Settings',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Icon(
                          Icons.settings_outlined,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('Settings', style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text(
          'API Key and other settings will be available here.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final IconData activeIcon;

  NavItem(this.icon, this.label, this.activeIcon);
}

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
                    children: [
                      _QuickStat(
                        icon: Icons.chat_bubble,
                        label: '5 AI Features',
                        color: AppTheme.primaryColor,
                      ),
                      _QuickStat(
                        icon: Icons.speed,
                        label: 'Real-time',
                        color: AppTheme.accentGreen,
                      ),
                      _QuickStat(
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
                _FeatureCard(
                  icon: Icons.chat_bubble,
                  title: 'AI Chat',
                  description: 'Conversational AI assistant for any task',
                  color: AppTheme.primaryColor,
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  ),
                ).animate().fadeIn(delay: 100.ms).scale(begin: const Offset(0.8, 0.8)),
                _FeatureCard(
                  icon: Icons.bar_chart,
                  title: 'Data Analyzer',
                  description: 'Upload CSV files for AI-powered insights',
                  color: AppTheme.accentBlue,
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentBlue, Color(0xFF8B5CF6)],
                  ),
                ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),
                _FeatureCard(
                  icon: Icons.text_fields,
                  title: 'Text Extractor',
                  description: 'Extract structured data from text',
                  color: AppTheme.accentGreen,
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentGreen, Color(0xFF059669)],
                  ),
                ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.8, 0.8)),
                _FeatureCard(
                  icon: Icons.show_chart,
                  title: 'Forecasting',
                  description: 'Predict future trends from historical data',
                  color: AppTheme.accentYellow,
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentYellow, Color(0xFFD97706)],
                  ),
                ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8)),
                _FeatureCard(
                  icon: Icons.sentiment_satisfied_alt,
                  title: 'Sentiment Analysis',
                  description: 'Analyze emotions and opinions in text',
                  color: AppTheme.secondaryColor,
                  gradient: const LinearGradient(
                    colors: [AppTheme.secondaryColor, AppTheme.primaryColor],
                  ),
                ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.8, 0.8)),
                _FeatureCard(
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

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickStat({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Gradient gradient;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Card(
      elevation: 2,
      shadowColor: color.withOpacity(0.3),
      child: InkWell(
        onTap: () {
          // Could navigate to the feature
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.05),
                Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon header with background pattern
              Container(
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.15),
                      color.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: isMobile ? 48 : 56,
                      height: isMobile ? 48 : 56,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: isMobile ? 24 : 28),
                    ),
                    const Spacer(),
                    // Decorative dots
                    Column(
                      children: [
                        Row(
                          children: [
                            _buildDot(color),
                            const SizedBox(width: 4),
                            _buildDot(color),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildDot(color),
                            const SizedBox(width: 4),
                            _buildDot(color),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content section
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 10),
                      Expanded(
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 13,
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Action hint
                      Row(
                        children: [
                          Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: isMobile ? 11 : 12,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: isMobile ? 12 : 14,
                            color: color,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
    );
  }
}
