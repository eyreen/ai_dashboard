// Import Flutter's material package for UI components
import 'package:flutter/material.dart';

/// QuickStat is a small badge widget that displays an icon and label
/// Used in the dashboard to show quick information like "5 AI Features", "Real-time", "Secure"
/// This is a StatelessWidget because it doesn't need to change after being built
class QuickStat extends StatelessWidget {
  /// Icon to display on the left side of the badge
  final IconData icon;

  /// Text label to display next to the icon
  final String label;

  /// Color for the icon, text, and badge border/background
  final Color color;

  /// Constructor with required parameters
  /// 'required' means these must be provided when creating a QuickStat
  const QuickStat({
    super.key,         // Pass key to parent class for widget identification
    required this.icon,
    required this.label,
    required this.color,
  });

  /// Build method - creates the UI for this widget
  @override
  Widget build(BuildContext context) {
    // Container provides the badge background and styling
    return Container(
      // Padding inside the badge (horizontal: 12px, vertical: 8px)
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      // BoxDecoration styles the container with colors, borders, and rounded corners
      decoration: BoxDecoration(
        // Background color with 15% opacity (semi-transparent)
        color: color.withOpacity(0.15),

        // Rounded corners with 8px radius
        borderRadius: BorderRadius.circular(8),

        // Border around the badge with 30% opacity
        border: Border.all(color: color.withOpacity(0.3)),
      ),

      // Row arranges icon and text horizontally
      child: Row(
        // mainAxisSize.min makes the row only as wide as its content
        // Without this, it would try to fill available width
        mainAxisSize: MainAxisSize.min,

        children: [
          // Icon on the left side
          Icon(
            icon,
            size: 16,       // Small icon size
            color: color,   // Icon color matches the theme color
          ),

          // Horizontal spacing between icon and text
          const SizedBox(width: 8),

          // Text label on the right side
          Text(
            label,
            style: TextStyle(
              fontSize: 13,                   // Small text size
              fontWeight: FontWeight.w600,    // Semi-bold weight
              color: color,                   // Text color matches theme
            ),
          ),
        ],
      ),
    );
  }
}
