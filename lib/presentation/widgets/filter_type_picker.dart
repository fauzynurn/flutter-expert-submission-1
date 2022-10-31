import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/filter_type.dart';

class FilterTypePicker extends StatelessWidget {
  final FilterType selectedFilterType;
  final Function(FilterType) onTapOption;

  const FilterTypePicker({
    Key? key,
    required this.selectedFilterType,
    required this.onTapOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          RadioListTile<FilterType>(
            key: Key(movieRadioButtonKey),
            title: const Text('Movies'),
            value: FilterType.movies,
            groupValue: selectedFilterType,
            onChanged: (selectedType) {
              onTapOption(selectedType!);
            },
          ),
          const SizedBox(
            height: 4,
          ),
          RadioListTile<FilterType>(
            key: Key(tvSeriesRadioButtonKey),
            title: const Text('TV Series'),
            value: FilterType.tvSeries,
            groupValue: selectedFilterType,
            onChanged: (selectedType) {
              onTapOption(selectedType!);
            },
          ),
        ],
      ),
    );
  }
}
