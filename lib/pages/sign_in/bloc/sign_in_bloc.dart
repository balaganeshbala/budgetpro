import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  String email = '';
  String password = '';

  SignInBloc() : super(SignInInitial()) {
    on<SignInEmailChanged>(_onEmailChanged);
    on<SignInPasswordChanged>(_onPasswordChanged);
    on<SignInSubmitted>(_onSignInSubmitted);
  }

  FutureOr<void> _onEmailChanged(
      SignInEmailChanged event, Emitter<SignInState> emit) {
    email = event.email;
    emit(SignInInputChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> _onPasswordChanged(
      SignInPasswordChanged event, Emitter<SignInState> emit) {
    password = event.password;
    emit(SignInInputChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> _onSignInSubmitted(
      SignInSubmitted event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      await SupabaseService.signInUser(email, password);
      emit(const SignInSuccess(message: "Sign in successful!"));
    } catch (e) {
      emit(SignInFailure(error: e.toString()));
    }
  }

  bool _isInputValid() {
    return email.isNotEmpty &&
        password.isNotEmpty &&
        password.length >= 6 &&
        _isEmailValid(email);
  }

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }
}
