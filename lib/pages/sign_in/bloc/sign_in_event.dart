import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SignInEmailChanged extends SignInEvent {
  final String email;

  const SignInEmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

class SignInPasswordChanged extends SignInEvent {
  final String password;

  const SignInPasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class SignInSubmitted extends SignInEvent {
  const SignInSubmitted();
}
