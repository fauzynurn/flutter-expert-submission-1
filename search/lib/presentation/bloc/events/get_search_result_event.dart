import 'package:search/presentation/bloc/events/search_result_event.dart';

class GetSearchResultEvent extends SearchResultEvent {
  final String query;

  GetSearchResultEvent({required this.query});

  @override
  List<Object> get props => [query];
}
