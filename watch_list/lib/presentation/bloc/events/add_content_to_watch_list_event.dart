import 'package:core/presentation/bloc/get_async_data/get_async_data_event.dart';

class AddContentToWatchListEvent<T> extends GetAsyncDataEvent {
  final T content;

  const AddContentToWatchListEvent({
    required this.content,
  });
}
