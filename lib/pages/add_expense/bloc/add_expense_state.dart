part of 'add_expense_bloc.dart';

sealed class NewExpenseState {}

final class NewExpenseActionState extends NewExpenseState {}

final class NewExpenseInitial extends NewExpenseState {}

final class NewExpenseInputValueChangedState extends NewExpenseState {
  final bool isInputValid;

  NewExpenseInputValueChangedState({required this.isInputValid});
}

final class NewExpensePageLoadedState extends NewExpenseState {
  final List<ExpenseCategory> categories;

  NewExpensePageLoadedState({required this.categories});
}

final class NewExpenseAddExpenseLoadingState extends NewExpenseActionState {}

final class NewExpenseAddExpenseSuccessState extends NewExpenseActionState {}

final class NewExpenseAddExpenseErrorState extends NewExpenseActionState {}
