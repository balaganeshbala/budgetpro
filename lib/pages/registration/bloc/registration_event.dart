import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class RegistrationNameChanged extends RegistrationEvent {
  final String name;

  const RegistrationNameChanged({required this.name});

  @override
  List<Object?> get props => [name];
}

class RegistrationEmailChanged extends RegistrationEvent {
  final String email;

  const RegistrationEmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

class RegistrationPasswordChanged extends RegistrationEvent {
  final String password;

  const RegistrationPasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class RegistrationConfirmPasswordChanged extends RegistrationEvent {
  final String confirmPassword;

  const RegistrationConfirmPasswordChanged({required this.confirmPassword});

  @override
  List<Object?> get props => [confirmPassword];
}

class RegistrationSubmitted extends RegistrationEvent {
  const RegistrationSubmitted();
}
