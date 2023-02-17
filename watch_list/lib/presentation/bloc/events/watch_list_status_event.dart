import 'package:core/domain/entities/filter_type.dart';
import 'package:core/presentation/bloc/get_async_data/get_async_data_event.dart';

class WatchListStatusEvent extends GetAsyncDataEvent {
  final int id;
  final FilterType type;

  const WatchListStatusEvent({
    required this.id,
    required this.type,
  });
}
