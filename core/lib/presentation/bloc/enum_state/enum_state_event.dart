import 'package:equatable/equatable.dart';

class SetEnumState<EnumType> extends Equatable {
  final EnumType value;

  const SetEnumState(this.value,);

  @override
  List<EnumType> get props => [value];
}