import 'package:core/common/constants.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final VoidCallback onTapHamburgerButton;

  const AboutPage({
    required this.onTapHamburgerButton,
  });
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onTapHamburgerButton,
          icon: const Icon(
            Icons.menu,
          ),
        ),
        elevation: 0,
        backgroundColor: Color.fromRGBO(
          8,
          52,
          100,
          1.0,
        ),
        title: const Text('About'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: kPrussianBlue,
              child: Center(
                child: Image.asset(
                  'assets/circle-g.png',
                  width: 128,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32.0),
              color: kMikadoYellow,
              child: Text(
                appDescription,
                style: TextStyle(color: Colors.black87, fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
