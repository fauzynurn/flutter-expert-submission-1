import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_state.dart';
import 'package:flutter/material.dart';
import 'package:core/presentation/widgets/card_with_description.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tv_series_list/events/get_tv_series_list_event.dart';
import '../bloc/tv_series_list/now_playing_tv_series_list_bloc.dart';
import 'tv_series_detail_page.dart';

class NowPlayingTvSeriesPage extends StatefulWidget {
  static const routeName = '/now-playing-tv-series';

  const NowPlayingTvSeriesPage({super.key});

  @override
  NowPlayingTvSeriesPageState createState() => NowPlayingTvSeriesPageState();
}

class NowPlayingTvSeriesPageState extends State<NowPlayingTvSeriesPage> {
  @override
  void initState() {
    context.read<NowPlayingTvSeriesListBloc>().add(
          GetTvSeriesListEvent(),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingTvSeriesListBloc, GetAsyncDataState>(
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
