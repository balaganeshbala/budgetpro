part of 'expense_details_bloc.dart';

// States
sealed class ExpenseDetailsState {}

class ExpenseDetailsInitial extends ExpenseDetailsState {}

class ExpenseDetailsLoadedState extends ExpenseDetailsState {
  final List<ExpenseCategory> categories;

  ExpenseDetailsLoadedState({required this.categories});
}

class ExpenseDetailsInputValueChangedState extends ExpenseDetailsState {
  final bool isInputValid;

  ExpenseDetailsInputValueChangedState({required this.isInputValid});
}

class ExpenseDetailsLoadingState extends ExpenseDetailsState {}

class ExpenseDetailsUpdatedSuccessState extends ExpenseDetailsState {}

class ExpenseDetailsDeletedSuccessState extends ExpenseDetailsState {}

class ExpenseDetailsErrorState extends ExpenseDetailsState {
  final String error;

  ExpenseDetailsErrorState({required this.error});
}
