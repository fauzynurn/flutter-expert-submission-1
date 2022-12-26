import 'package:core/common/constants.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:core/presentation/widgets/filter_type_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FilterType selectedFilterType = FilterType.movies;
  final onTapFilter = (selectedFilter) {
    selectedFilterType = selectedFilter;
  };

  T castWidget<T>(
    Finder finder, {
    required WidgetTester tester,
  }) {
    return tester.firstWidget(finder) as T;
  }

  testWidgets(
    'Filter type picker should mark selected'
    ' filter type as selected',
    (tester) async {
      final movieOptionFinder = find.byKey(
        Key(
          movieRadioButtonKey,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterTypePicker(
              selectedFilterType: selectedFilterType,
              onTapOption: onTapFilter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        castWidget<RadioListTile>(
          movieOptionFinder,
          tester: tester,
        ).checked,
        true,
      );
    },
  );

  testWidgets(
    'Filter type picker should call'
    ' corresponding given callback when Tv Series option'
    'is tapped',
    (tester) async {
      final tvSeriesOptionFinder = find.byKey(
        Key(
          tvSeriesRadioButtonKey,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterTypePicker(
              selectedFilterType: selectedFilterType,
              onTapOption: onTapFilter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        tvSeriesOptionFinder,
      );
      expect(
        selectedFilterType,
        FilterType.tvSeries,
      );
    },
  );

  testWidgets(
    'Filter type picker should call'
    ' corresponding given callback when Movie option'
    'is tapped',
    (tester) async {
      selectedFilterType = FilterType.tvSeries;
      final movieOptionFinder = find.byKey(
        Key(
          movieRadioButtonKey,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterTypePicker(
              selectedFilterType: selectedFilterType,
              onTapOption: onTapFilter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        movieOptionFinder,
      );
      expect(
        selectedFilterType,
        FilterType.movies,
      );
    },
  );
}
