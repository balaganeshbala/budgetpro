part of 'income_details_bloc.dart';

// States
sealed class IncomeDetailsState {}

class IncomeDetailsInitial extends IncomeDetailsState {}

class IncomeDetailsLoadedState extends IncomeDetailsState {
  final List<IncomeCategory> categories;

  IncomeDetailsLoadedState({required this.categories});
}

class IncomeDetailsInputValueChangedState extends IncomeDetailsState {
  final bool isInputValid;

  IncomeDetailsInputValueChangedState({required this.isInputValid});
}

class IncomeDetailsLoadingState extends IncomeDetailsState {}

class IncomeDetailsUpdatedSuccessState extends IncomeDetailsState {}

class IncomeDetailsDeletedSuccessState extends IncomeDetailsState {}

class IncomeDetailsErrorState extends IncomeDetailsState {
  final String error;

  IncomeDetailsErrorState({required this.error});
}
