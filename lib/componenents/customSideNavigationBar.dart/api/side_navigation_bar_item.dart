import 'package:flutter/material.dart';

/// Interface to provide information about item use in [SideNavigationBar.items]
class SideNavigationBarItem {
  /// The [IconData] you want to display
  final IconData icon;

  /// A text to display route information
  final String label;

  /// Optional margin for the icon (e.g., left margin)
  final EdgeInsetsGeometry? margin;

  /// Item data
  const SideNavigationBarItem({
    required this.icon,
    required this.label,
    this.margin, // Optional margin parameter
  });
}
