import 'package:equatable/equatable.dart';

class EnumStateSuccess<EnumType> extends Equatable {
  final EnumType selectedState;

  const EnumStateSuccess(this.selectedState);

  @override
  List<EnumType> get props => [selectedState];
}
