import 'package:flutter/material.dart';

extension ResponsiveExtensions on num {
  /// Responsive height based on screen height
  double get h => (this / 100) * MediaQuery.of(navigatorKey.currentContext!).size.height;

  /// Responsive width based on screen width
  double get w => (this / 100) * MediaQuery.of(navigatorKey.currentContext!).size.width;

  /// Responsive font size based on screen width
  double get sp => (this / 100) * MediaQuery.of(navigatorKey.currentContext!).size.width;

  /// Responsive radius based on screen width
  double get r => (this / 100) * MediaQuery.of(navigatorKey.currentContext!).size.width;

  /// Responsive padding based on screen width
  EdgeInsets get p => EdgeInsets.all((this / 100) * MediaQuery.of(navigatorKey.currentContext!).size.width);

  /// Responsive horizontal padding
  EdgeInsets get ph => EdgeInsets.symmetric(horizontal: (this / 100) * MediaQuery.of(navigatorKey.currentContext!).size.width);

  /// Responsive vertical padding
  EdgeInsets get pv => EdgeInsets.symmetric(vertical: (this / 100) * MediaQuery.of(navigatorKey.currentContext!).size.width);
}

// Global navigator key for accessing context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Responsive breakpoints
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

// Grid configuration class
class GridConfig {
  final int crossAxisCount;
  final double childAspectRatio;
  final double spacing;
  final double padding;

  const GridConfig({required this.crossAxisCount, required this.childAspectRatio, required this.spacing, required this.padding});
}

// Responsive helper class
class ResponsiveHelper {
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < ResponsiveBreakpoints.mobile;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveBreakpoints.mobile && MediaQuery.of(context).size.width < ResponsiveBreakpoints.tablet;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= ResponsiveBreakpoints.tablet;

  static double getScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double getScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  // Responsive grid configuration
  static GridConfig getGridConfig(BuildContext context) {
    final width = getScreenWidth(context);

    if (width < ResponsiveBreakpoints.mobile) {
      return const GridConfig(crossAxisCount: 2, childAspectRatio: 0.6, spacing: 12.0, padding: 16.0);
    } else if (width < ResponsiveBreakpoints.tablet) {
      return const GridConfig(crossAxisCount: 3, childAspectRatio: 0.65, spacing: 16.0, padding: 20.0);
    } else {
      return const GridConfig(crossAxisCount: 4, childAspectRatio: 0.7, spacing: 20.0, padding: 24.0);
    }
  }
}
