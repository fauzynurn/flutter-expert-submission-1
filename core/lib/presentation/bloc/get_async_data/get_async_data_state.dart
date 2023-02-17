import 'package:equatable/equatable.dart';

abstract class GetAsyncDataState extends Equatable {}

class GetAsyncDataInitialState extends GetAsyncDataState {
  @override
  List<Object> get props => [];
}

class GetAsyncDataLoadingState extends GetAsyncDataState {
  @override
  List<Object> get props => [];
}

class GetAsyncDataErrorState extends GetAsyncDataState {
  final String message;

  GetAsyncDataErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [];
}

class GetAsyncDataLoadedState<T extends Object> extends GetAsyncDataState {
  GetAsyncDataLoadedState({
    required this.data,
  });

  final T data;

  @override
  List<Object> get props => [data];
}
