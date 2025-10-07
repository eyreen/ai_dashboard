// Import Flutter's material package for UI components
import 'package:flutter/material.dart';

// Import our app theme to access color constants
import '../config/app_theme.dart';

/// FeatureCard is a stylish card widget that displays AI features on the dashboard
/// Each card shows an icon, title, description, and optional image
/// Cards are clickable and have gradient backgrounds with decorative elements
class FeatureCard extends StatelessWidget {
  /// Icon to display in the header (e.g., Icons.chat_bubble for AI Chat)
  final IconData icon;

  /// Feature title (e.g., "AI Chat", "Data Analyzer")
  final String title;

  /// Short description of what the feature does
  final String description;

  /// Theme color for the card (used for accents, borders, shadows)
  final Color color;

  /// Gradient for the icon background
  final Gradient gradient;

  /// Optional network image URL to display at the bottom of the card
  /// The ? means this parameter is nullable (can be null)
  final String? imageUrl;

  /// Optional callback function when card is tapped
  /// VoidCallback is a function that takes no parameters and returns nothing
  final VoidCallback? onTap;

  /// Constructor with required and optional parameters
  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.gradient,
    this.imageUrl,      // Optional: can be omitted when creating card
    this.onTap,         // Optional: can be omitted when creating card
  });

  @override
  Widget build(BuildContext context) {
    // MediaQuery gets device information like screen size
    // We use it for responsive design - different layouts for mobile/tablet/desktop
    final isMobile = MediaQuery.of(context).size.width < 768;

    // Card widget provides elevation and shadow effects
    return Card(
      elevation: 2,                        // Height of the shadow
      shadowColor: color.withOpacity(0.3), // Colored shadow matching theme

      // InkWell provides tap animation and handles tap events
      child: InkWell(
        onTap: onTap,  // Function called when card is tapped
        borderRadius: BorderRadius.circular(16), // Rounded tap effect

        // Container holds the card content with gradient background
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),

            // Subtle gradient overlay on the card
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.05),  // Very faint color at top-left
                Colors.transparent,        // Fades to transparent at bottom-right
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          // Column arranges children vertically: header → content → image
          child: Column(
            // stretch makes children fill the card width
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              // ==========================================
              // HEADER SECTION - Icon with gradient background
              // ==========================================
              Container(
                // Responsive height: smaller on mobile
                height: isMobile ? 80 : 100,

                // Responsive padding: less on mobile to save space
                padding: EdgeInsets.all(isMobile ? 16 : 20),

                // Gradient background for header area
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.15),  // Slightly visible color
                      color.withOpacity(0.05),  // Fades to almost transparent
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  // Only round top corners (bottom is content area)
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),

                // Stack allows overlapping widgets (icon and decorative dots)
                child: Stack(
                  children: [
                    // ------------------------------------------
                    // Icon on the left side
                    // ------------------------------------------
                    Align(
                      alignment: Alignment.centerLeft, // Position on left side

                      // Container with gradient background for the icon
                      child: Container(
                        // Responsive icon container size
                        width: isMobile ? 48 : 56,
                        height: isMobile ? 48 : 56,

                        decoration: BoxDecoration(
                          gradient: gradient,  // Colorful gradient background
                          borderRadius: BorderRadius.circular(14), // Rounded corners

                          // Shadow below the icon for depth
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.4), // Semi-transparent color
                              blurRadius: 12,                 // Soft shadow
                              offset: const Offset(0, 4),     // Shadow below (y=4)
                            ),
                          ],
                        ),

                        // The actual icon inside the container
                        child: Icon(
                          icon,
                          color: Colors.white,           // White icon on gradient
                          size: isMobile ? 24 : 28,      // Responsive size
                        ),
                      ),
                    ),

                    // ------------------------------------------
                    // Decorative dots in top-right corner
                    // ------------------------------------------
                    Positioned(
                      top: 0,     // Align to top
                      right: 0,   // Align to right

                      // Create a 2x2 grid of dots
                      child: Column(
                        children: [
                          // First row of dots
                          Row(
                            children: [
                              _buildDot(color),           // First dot
                              const SizedBox(width: 4),   // Space between dots
                              _buildDot(color),           // Second dot
                            ],
                          ),
                          const SizedBox(height: 4),      // Space between rows

                          // Second row of dots
                          Row(
                            children: [
                              _buildDot(color),
                              const SizedBox(width: 4),
                              _buildDot(color),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ==========================================
              // CONTENT SECTION - Title, description, and action hint
              // ==========================================
              Expanded(  // Expands to fill available space between header and image
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to left

                    children: [
                      // ------------------------------------------
                      // Feature title
                      // ------------------------------------------
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,   // Larger on desktop
                          fontWeight: FontWeight.bold,     // Bold text
                          color: AppTheme.textPrimary,     // White text
                        ),
                      ),

                      // Spacing between title and description
                      SizedBox(height: isMobile ? 8 : 10),

                      // ------------------------------------------
                      // Feature description
                      // ------------------------------------------
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 13,    // Slightly smaller text
                          color: AppTheme.textSecondary,   // Gray text
                          height: 1.5,                      // Line height for readability
                        ),
                        maxLines: 3,                        // Limit to 3 lines
                        overflow: TextOverflow.ellipsis,    // Add "..." if text too long
                      ),

                      const SizedBox(height: 12),

                      // ------------------------------------------
                      // "Explore" action hint with arrow
                      // ------------------------------------------
                      Row(
                        children: [
                          Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: isMobile ? 11 : 12,
                              color: color,                   // Match card theme color
                              fontWeight: FontWeight.w600,     // Semi-bold
                            ),
                          ),

                          const SizedBox(width: 4),

                          // Arrow icon
                          Icon(
                            Icons.arrow_forward,
                            size: isMobile ? 12 : 14,
                            color: color,                     // Match card theme color
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ==========================================
              // IMAGE SECTION - Full-width image at bottom (optional)
              // ==========================================
              // Only show if imageUrl is provided
              if (imageUrl != null)
                // ClipRRect clips the image with rounded bottom corners
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),

                  // Load image from network URL
                  child: Image.network(
                    imageUrl!,  // The ! asserts imageUrl is not null here
                    height: isMobile ? 120 : 140,  // Responsive height
                    width: double.infinity,        // Full width of card
                    fit: BoxFit.cover,             // Fill the area, crop if needed

                    // Show nothing if image fails to load
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to build a small decorative dot
  /// Returns a circular Container with the specified color
  Widget _buildDot(Color color) {
    return Container(
      width: 4,   // Very small width
      height: 4,  // Very small height

      decoration: BoxDecoration(
        color: color.withOpacity(0.3),  // Semi-transparent colored dot
        shape: BoxShape.circle,          // Make it circular
      ),
    );
  }
}
