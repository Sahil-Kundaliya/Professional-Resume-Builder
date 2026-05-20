import 'package:flutter/material.dart';

/// Base scaffold widget for consistent app layout.
/// Can be extended with common patterns like app bar, bottom nav, etc.
class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? appBar;
  final Widget? bottomNavigationBar;
  final FloatingActionButton? floatingActionButton;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar as PreferredSizeWidget?,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
