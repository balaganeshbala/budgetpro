import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  String email = '';

  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
  }

  FutureOr<void> _onEmailChanged(
      ForgotPasswordEmailChanged event, Emitter<ForgotPasswordState> emit) {
    email = event.email;
    emit(ForgotPasswordInputChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> _onForgotPasswordSubmitted(
      ForgotPasswordSubmitted event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());
    try {
      await SupabaseService.resetPassword(email);
      emit(const ForgotPasswordSuccess(
          message: "Password reset link sent to your email!"));
    } catch (e) {
      emit(ForgotPasswordFailure(error: e.toString()));
    }
  }

  bool _isInputValid() {
    return email.isNotEmpty && _isEmailValid(email);
  }

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }
}
