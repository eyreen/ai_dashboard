import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/nav_item.dart';
import '../widgets/dashboard_overview.dart';
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

