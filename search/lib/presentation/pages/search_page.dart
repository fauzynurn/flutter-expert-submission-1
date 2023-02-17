import 'package:core/common/constants.dart';
import 'package:core/domain/entities/filter_type.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/bloc/enum_state/enum_state_bloc.dart';
import 'package:core/presentation/bloc/enum_state/enum_state_event.dart';
import 'package:core/presentation/bloc/enum_state/enum_state_state.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:core/presentation/widgets/card_with_description.dart';
import 'package:core/presentation/widgets/filter_type_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/events/get_search_result_event.dart';
import 'package:search/presentation/bloc/events/reset_search_result_event.dart';

import '../bloc/search_movie_bloc.dart';
import '../bloc/search_tv_series_bloc.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search';

  final EnumStateBloc<FilterType> searchTypeStateBloc =
      EnumStateBloc<FilterType>(
    FilterType.movies,
  );

  SearchPage({super.key});

  void onTapMovieResult(
    Movie movie, {
    required BuildContext context,
  }) {}

  void onTapTvSeriesResult(
    TvSeries tvSeries, {
    required BuildContext context,
  }) {}

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
            BlocBuilder<EnumStateBloc, EnumStateSuccess>(
              bloc: searchTypeStateBloc,
              builder: (context, state) {
                return TextField(
                  key: const Key(
                    searchTextFieldKey,
                  ),
                  onSubmitted: (query) {
                    state.selectedState == FilterType.movies
                        ? context.read<SearchMovieBloc>().add(
                              GetSearchResultEvent(
                                query: query,
                              ),
                            )
                        : context.read<SearchTvSeriesBloc>().add(
                              GetSearchResultEvent(
                                query: query,
                              ),
                            );
                  },
                  decoration: InputDecoration(
                    hintText: 'Search ${state.selectedState.name}',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.search,
                );
              },
            ),
            const SizedBox(height: 16),
            BlocConsumer<EnumStateBloc, EnumStateSuccess>(
              bloc: searchTypeStateBloc,
              listener: (context, event) {
                if (event.selectedState == FilterType.movies) {
                  /// Reset previous tv series search result
                  context.read<SearchTvSeriesBloc>().add(
                        ResetSearchResultEvent(),
                      );
                } else {
                  /// Reset previous movie search result
                  context.read<SearchMovieBloc>().add(
                        ResetSearchResultEvent(),
                      );
                }
              },
              builder: (context, state) {
                return state.selectedState == FilterType.movies
                    ? movieSearchResult(context)
                    : tvSeriesSearchResult(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget movieSearchResult(BuildContext context) {
    return BlocBuilder<SearchMovieBloc, GetAsyncDataState>(
      builder: (context, state) {
        if (state is GetAsyncDataLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetAsyncDataLoadedState<List<Movie>>) {
          final result = state.data;
          return Expanded(
            child: result.isNotEmpty
                ? ListView.builder(
                    key: const Key(
                      movieSearchResultKey,
                    ),
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final searchResult = result[index];
                      return CardWithDescription(
                        title: searchResult.title ?? '',
                        overview: searchResult.overview ?? '',
                        posterPath: searchResult.posterPath ?? '',
                        onTap: () {
                          onTapMovieResult(
                            searchResult,
                            context: context,
                          );
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
    );
  }

  Widget tvSeriesSearchResult(BuildContext context) {
    return BlocBuilder<SearchTvSeriesBloc, GetAsyncDataState>(
      builder: (context, state) {
        if (state is GetAsyncDataLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetAsyncDataLoadedState<List<TvSeries>>) {
          final result = state.data;
          return Expanded(
            child: result.isNotEmpty
                ? ListView.builder(
                    key: const Key(
                      tvSeriesSearchResultKey,
                    ),
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final searchResult = result[index];
                      return CardWithDescription(
                        title: searchResult.name ?? '',
                        overview: searchResult.overview ?? '',
                        posterPath: searchResult.posterPath ?? '',
                        onTap: () {
                          onTapTvSeriesResult(
                            searchResult,
                            context: context,
                          );
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
    );
  }

  void openFilter(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (btmSheetContext) {
        return FilterTypePicker(
          key: const Key(
            filterTypeBottomSheetKey,
          ),
          onTapOption: (selectedType) {
            searchTypeStateBloc.add(
              SetEnumState(
                selectedType,
              ),
            );
            Navigator.pop(btmSheetContext);
          },
          selectedFilterType: searchTypeStateBloc.state.selectedState,
        );
      },
    );
  }
}
