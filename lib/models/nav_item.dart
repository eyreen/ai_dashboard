// Import Flutter material package to use IconData type
import 'package:flutter/material.dart';

/// NavItem class represents a navigation menu item in the sidebar
/// This is a simple data class (model) that holds information about each navigation option
///
/// Example: The "Dashboard" menu item would have:
/// - icon: Icons.dashboard_outlined (shown when not selected)
/// - label: "Dashboard" (text displayed next to icon)
/// - activeIcon: Icons.dashboard (shown when selected - usually filled version)
class NavItem {
  /// Icon displayed when this navigation item is NOT selected
  /// Usually an outlined/hollow version of the icon
  final IconData icon;

  /// Text label displayed next to the icon
  /// Example: "Dashboard", "Chat", "Data Analyzer"
  final String label;

  /// Icon displayed when this navigation item IS selected
  /// Usually a filled/solid version of the icon for visual emphasis
  final IconData activeIcon;

  /// Constructor - creates a new NavItem with required parameters
  /// Uses positional parameters (order matters):
  /// NavItem(icon, label, activeIcon)
  ///
  /// Example usage:
  /// NavItem(Icons.dashboard_outlined, 'Dashboard', Icons.dashboard)
  NavItem(this.icon, this.label, this.activeIcon);
}
