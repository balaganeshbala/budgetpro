import 'dart:async';
import 'package:bloc/bloc.dart';

part 'new_income_event.dart';
part 'new_income_state.dart';

class NewIncomeBloc extends Bloc<NewIncomeEvent, NewIncomeState> {
  NewIncomeBloc() : super(NewIncomeInitialState()) {
    on<NewIncomeInitialEvent>(_onInitialEvent);
    on<NewIncomeNameValueChanged>(_onNameValueChanged);
    on<NewIncomeAmountValueChanged>(_onAmountValueChanged);
    on<NewIncomeDateValueChanged>(_onDateValueChanged);
    on<NewIncomeAddIncomeTappedEvent>(_onAddIncomeTapped);
  }

  FutureOr<void> _onInitialEvent(
      NewIncomeInitialEvent event, Emitter<NewIncomeState> emit) {
    emit(NewIncomePageLoadedState());
  }

  FutureOr<void> _onNameValueChanged(
      NewIncomeNameValueChanged event, Emitter<NewIncomeState> emit) {
    emit(NewIncomeInputValueChangedState(isInputValid: event.value.isNotEmpty));
  }

  FutureOr<void> _onAmountValueChanged(
      NewIncomeAmountValueChanged event, Emitter<NewIncomeState> emit) {
    emit(NewIncomeInputValueChangedState(
        isInputValid: double.tryParse(event.value) != null));
  }

  FutureOr<void> _onDateValueChanged(
      NewIncomeDateValueChanged event, Emitter<NewIncomeState> emit) {
    // Handle date change if needed
  }

  FutureOr<void> _onAddIncomeTapped(
      NewIncomeAddIncomeTappedEvent event, Emitter<NewIncomeState> emit) async {
    emit(NewIncomeAddIncomeLoadingState());
    try {
      // Simulate adding income logic
      await Future.delayed(const Duration(seconds: 1));
      emit(NewIncomeAddIncomeSuccessState());
    } catch (_) {
      emit(NewIncomeAddIncomeErrorState());
    }
  }
}
