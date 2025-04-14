import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  RegistrationBloc() : super(RegistrationInitial()) {
    on<RegistrationNameChanged>(_onNameChanged);
    on<RegistrationEmailChanged>(_onEmailChanged);
    on<RegistrationPasswordChanged>(_onPasswordChanged);
    on<RegistrationConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegistrationSubmitted>(_onRegistrationSubmitted);
  }

  FutureOr<void> _onNameChanged(
      RegistrationNameChanged event, Emitter<RegistrationState> emit) {
    name = event.name;
    emit(RegistrationInputChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> _onEmailChanged(
      RegistrationEmailChanged event, Emitter<RegistrationState> emit) {
    email = event.email;
    emit(RegistrationInputChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> _onPasswordChanged(
      RegistrationPasswordChanged event, Emitter<RegistrationState> emit) {
    password = event.password;
    emit(RegistrationInputChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> _onConfirmPasswordChanged(
      RegistrationConfirmPasswordChanged event,
      Emitter<RegistrationState> emit) {
    confirmPassword = event.confirmPassword;
    emit(RegistrationInputChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> _onRegistrationSubmitted(
      RegistrationSubmitted event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());
    try {
      await SupabaseService.registerUser(name, email, password);
      emit(const RegistrationSuccess(message: "Registration successful!"));
    } catch (e) {
      emit(RegistrationFailure(error: e.toString()));
    }
  }

  bool _isInputValid() {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password.length >= 6 &&
        password == confirmPassword &&
        _isEmailValid(email);
  }

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }
}
