import 'package:core/presentation/bloc/enum_state/enum_state_event.dart';
import 'package:core/presentation/bloc/enum_state/enum_state_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Generic BLoC which keep selected state of [EnumType] type
/// and notify the UI with the new value if there is a change
/// of the selected state
class EnumStateBloc<EnumType>
    extends Bloc<SetEnumState<EnumType>, EnumStateSuccess<EnumType>> {
  EnumStateBloc(EnumType initialValue)
      : super(
          EnumStateSuccess<EnumType>(
            initialValue,
          ),
        ) {
    on<SetEnumState<EnumType>>(
      ((event, emit) async {
        if (state.selectedState != event.value) {
          emit(
            EnumStateSuccess(
              event.value,
            ),
          );
        }
      }),
    );
  }
}
