import 'package:ditonton/presentation/widgets/card_with_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Card with description should show'
    'correct data',
    (tester) async {
      bool isTap = false;
      final widgetKey = Key(
        'widget_key',
      );
      final title = 'Title test';
      final overview = 'Overview test';
      final posterPath = 'Poster path test';
      final onTap = () {
        isTap = true;
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardWithDescription(
              key: widgetKey,
              title: title,
              overview: overview,
              posterPath: posterPath,
              onTap: onTap,
            ),
          ),
        ),
      );
      expect(
        find.text(
          title,
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          overview,
        ),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(
          widgetKey,
        ),
      );
      expect(
        isTap,
        true,
      );
    },
  );
}
