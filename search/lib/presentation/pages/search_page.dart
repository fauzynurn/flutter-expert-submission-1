import 'package:core/common/constants.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/widgets/card_with_description.dart';
import 'package:core/presentation/widgets/filter_type_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/search_notifier.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search';

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => openFilter(
              context,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<SearchNotifier>(
              builder: (context, data, child) {
                return TextField(
                  key: const Key(
                    searchTextFieldKey,
                  ),
                  onSubmitted: (query) {
                    Provider.of<SearchNotifier>(
                      context,
                      listen: false,
                    ).fetchResult(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search ${data.selectedFilterType.name}',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.search,
                );
              },
            ),
            const SizedBox(height: 16),
            Consumer<SearchNotifier>(
              builder: (context, data, child) {
                return Visibility(
                  visible: data.searchResult.isNotEmpty,
                  child: Text(
                    'Search Result',
                    style: kHeading6,
                  ),
                );
              },
            ),
            Consumer<SearchNotifier>(
              builder: (context, data, child) {
                if (data.state == RequestState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (data.state == RequestState.loaded) {
                  final result = data.searchResult;
                  return Expanded(
                    child: result.isNotEmpty
                        ? ListView.builder(
                            key: const Key(
                              searchResultKey,
                            ),
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final searchResult = data.searchResult[index];
                              return CardWithDescription(
                                title:
                                    data.selectedFilterType == FilterType.movies
                                        ? searchResult.title
                                        : searchResult.name,
                                overview: searchResult.overview ?? '',
                                posterPath: searchResult.posterPath ?? '',
                                onTap: () {
                                  if (data.selectedFilterType ==
                                      FilterType.movies) {
                                    onTapMovieResult(searchResult);
                                  } else {
                                    onTapTvSeriesResult(searchResult);
                                  }
                                },
                              );
                            },
                            itemCount: result.length,
                          )
                        : Center(
                            child: Text(
                              'No result found',
                              style: kSubtitle,
                            ),
                          ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void onTapMovieResult(Movie movie) {}

  void onTapTvSeriesResult(TvSeries tvSeries) {}

  void openFilter(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<SearchNotifier>(
          builder: (bottomSheetContext, provider, child) {
            return FilterTypePicker(
              key: const Key(
                filterTypeBottomSheetKey,
              ),
              onTapOption: (selectedType) {
                provider.onChangeFilterType(selectedType);
                Navigator.pop(bottomSheetContext);
              },
              selectedFilterType: provider.selectedFilterType,
            );
          },
        );
      },
    );
  }
}
