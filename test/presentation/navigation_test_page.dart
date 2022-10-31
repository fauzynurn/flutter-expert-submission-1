import 'package:flutter/material.dart';

/// This page only show current route name
/// for navigation test and expected to
/// reduce dependency initialization for
/// specific page
class NavigationTestPage extends StatefulWidget {
  static const ROUTE_NAME = '/navigation-test-page';

  final String routeName;
  final dynamic parameter;

  const NavigationTestPage({
    super.key,
    required this.routeName,
    this.parameter,
  });

  @override
  State<NavigationTestPage> createState() => _NavigationTestPageState();
}

class _NavigationTestPageState extends State<NavigationTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Navigation Test',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              widget.routeName,
            ),
            const SizedBox(
              height: 21,
            ),
            Text(
              (widget.parameter ?? '').toString(),
            ),
          ],
        ),
      ),
    );
  }
}
