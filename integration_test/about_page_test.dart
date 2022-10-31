import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'app_test_main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Widget _makeTestableWidget(Widget body) {
    return AppTestMain(
        body: MaterialApp(
      home: body,
      theme: ThemeData.dark().copyWith(
        colorScheme: kColorScheme,
        primaryColor: kRichBlack,
        scaffoldBackgroundColor: kRichBlack,
        textTheme: kTextTheme,
      ),
    ));
  }

  testWidgets(
    'About page should display logo and app description',
    (tester) async {
      runApp(
        _makeTestableWidget(
          AboutPage(),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(appDescription),
        findsOneWidget,
      );
      expect(
        find.byType(
          Image,
        ),
        findsOneWidget,
      );
    },
  );
}
