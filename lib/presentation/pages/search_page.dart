import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/filter_type.dart';
import 'package:ditonton/presentation/widgets/card_with_description.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/search_notifier.dart';
import '../widgets/filter_type_picker.dart';
import 'movie_detail_page.dart';
import 'tv_series_detail_page.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
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
                  key: Key(
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
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.search,
                );
              },
            ),
            SizedBox(height: 16),
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
                if (data.state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (data.state == RequestState.Loaded) {
                  final result = data.searchResult;
                  return Expanded(
                    child: ListView.builder(
                      key: Key(
                        searchResultKey,
                      ),
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final searchResult = data.searchResult[index];
                        return CardWithDescription(
                          title: data.selectedFilterType == FilterType.movies
                              ? searchResult.title
                              : searchResult.name,
                          overview: searchResult.overview ?? '',
                          posterPath: searchResult.posterPath ?? '',
                          onTap: () {
                            if (data.selectedFilterType == FilterType.movies) {
                              Navigator.pushNamed(
                                context,
                                MovieDetailPage.ROUTE_NAME,
                                arguments: searchResult.id,
                              );
                            } else {
                              Navigator.pushNamed(
                                context,
                                TvSeriesDetailPage.ROUTE_NAME,
                                arguments: searchResult.id,
                              );
                            }
                          },
                        );
                      },
                      itemCount: result.length,
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

  void openFilter(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<SearchNotifier>(
          builder: (bottomSheetContext, provider, child) {
            return FilterTypePicker(
              key: Key(
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
