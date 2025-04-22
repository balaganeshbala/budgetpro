part of 'add_expense_bloc.dart';

sealed class AddExpenseState {}

final class AddExpenseActionState extends AddExpenseState {}

final class AddExpenseInitial extends AddExpenseState {}

final class AddExpenseInputValueChangedState extends AddExpenseState {
  final bool isInputValid;

  AddExpenseInputValueChangedState({required this.isInputValid});
}

final class AddExpensePageLoadedState extends AddExpenseState {
  final List<ExpenseCategory> categories;

  AddExpensePageLoadedState({required this.categories});
}

final class AddExpenseAddExpenseLoadingState extends AddExpenseActionState {}

final class AddExpenseAddExpenseSuccessState extends AddExpenseActionState {}

final class AddExpenseAddExpenseErrorState extends AddExpenseActionState {}
