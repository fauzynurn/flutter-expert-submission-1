import 'package:flutter/src/widgets/framework.dart';

class AppTestMain extends StatelessWidget {
  final Widget body;
  const AppTestMain({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return body;
  }
}
