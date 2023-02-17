import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter/material.dart';
import 'package:core/presentation/widgets/card_with_description.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tv_series_list/events/get_tv_series_list_event.dart';
import '../bloc/tv_series_list/popular_tv_series_list_bloc.dart';
import 'tv_series_detail_page.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const routeName = '/popular-tv-series';

  const PopularTvSeriesPage({super.key});

  @override
  PopularTvSeriesPageState createState() => PopularTvSeriesPageState();
}

class PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    context.read<PopularTvSeriesListBloc>().add(
          GetTvSeriesListEvent(),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvSeriesListBloc, GetAsyncDataState>(
            builder: (context, state) {
          if (state is GetAsyncDataLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetAsyncDataLoadedState<List<TvSeries>>) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tvSeries = state.data[index];
                return CardWithDescription(
                  title: tvSeries.name ?? '',
                  overview: tvSeries.overview ?? '',
                  posterPath: tvSeries.posterPath ?? '',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      TvSeriesDetailPage.routeName,
                      arguments: tvSeries.id,
                    );
                  },
                );
              },
              itemCount: state.data.length,
            );
          } else if (state is GetAsyncDataErrorState) {
            return Text(state.message);
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
