import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../integration_test/app_test_main.dart';

void main() {
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
      await tester.pumpWidget(
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
