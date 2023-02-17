import 'package:core/common/constants.dart';
import 'package:ditonton/features/about/presentation/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
      theme: ThemeData.dark().copyWith(
        colorScheme: kColorScheme,
        primaryColor: kRichBlack,
        scaffoldBackgroundColor: kRichBlack,
        textTheme: kTextTheme,
      ),
    );
  }

  testWidgets(
    'About page should display logo and app description',
    (tester) async {
      await tester.pumpWidget(
        _makeTestableWidget(
          AboutPage(
            onTapHamburgerButton: () {},
          ),
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
