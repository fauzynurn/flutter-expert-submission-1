import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/detail_list_type.dart';
import 'package:core/presentation/widgets/card_with_description.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/detail_tv_series_list_notifier.dart';
import 'tv_series_detail_page.dart';

class DetailTvSeriesListPage extends StatefulWidget {
  static const routeName = '/detail-tv-series-list';

  final DetailListType type;

  const DetailTvSeriesListPage({super.key, required this.type});
  @override
  DetailTvSeriesListPageState createState() => DetailTvSeriesListPageState();
}

class DetailTvSeriesListPageState extends State<DetailTvSeriesListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<DetailTvSeriesListNotifier>(context, listen: false)
          .fetchTvSeries(
        detailListType: widget.type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type.name} TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<DetailTvSeriesListNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = data.tvSeries[index];
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
                itemCount: data.tvSeries.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
