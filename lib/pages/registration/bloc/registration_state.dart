import 'package:equatable/equatable.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationInputChangedState extends RegistrationState {
  final bool isInputValid;

  const RegistrationInputChangedState({required this.isInputValid});

  @override
  List<Object?> get props => [isInputValid];
}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final String message;

  const RegistrationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class RegistrationFailure extends RegistrationState {
  final String error;

  const RegistrationFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
