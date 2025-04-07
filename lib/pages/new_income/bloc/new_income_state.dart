part of 'new_income_bloc.dart';

sealed class NewIncomeState {}

class NewIncomeInitialState extends NewIncomeState {}

class NewIncomePageLoadedState extends NewIncomeState {}

class NewIncomeInputValueChangedState extends NewIncomeState {
  final bool isInputValid;

  NewIncomeInputValueChangedState({required this.isInputValid});
}

sealed class NewIncomeActionState extends NewIncomeState {}

class NewIncomeAddIncomeLoadingState extends NewIncomeActionState {}

class NewIncomeAddIncomeSuccessState extends NewIncomeActionState {}

class NewIncomeAddIncomeErrorState extends NewIncomeActionState {}
