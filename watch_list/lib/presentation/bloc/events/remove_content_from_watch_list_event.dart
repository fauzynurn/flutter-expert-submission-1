import 'package:core/presentation/bloc/get_async_data/get_async_data_event.dart';

class RemoveContentFromWatchListEvent<T> extends GetAsyncDataEvent {
  final T content;

  const RemoveContentFromWatchListEvent({
    required this.content,
  });
}
