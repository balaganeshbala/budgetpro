import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {}

class SignInInputChangedState extends SignInState {
  final bool isInputValid;

  const SignInInputChangedState({required this.isInputValid});

  @override
  List<Object?> get props => [isInputValid];
}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final String message;

  const SignInSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class SignInFailure extends SignInState {
  final String error;

  const SignInFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
