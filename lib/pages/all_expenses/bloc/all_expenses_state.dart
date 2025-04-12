part of 'all_expenses_bloc.dart';

sealed class ExpensesState {}

sealed class ExpensesFetchState extends ExpensesState {}

sealed class ExpensesActionState extends ExpensesState {}

final class ExpensesInitial extends ExpensesState {}

final class ExpensesLoadingState extends ExpensesFetchState {}

class ExpensesLoadingSuccessState extends ExpensesFetchState {
  final List<ExpenseModel> expenses;

  ExpensesLoadingSuccessState({required this.expenses});
}

class ExpensesLoadingErrorState extends ExpensesFetchState {}

class ExpenesesAddExpenseClickedState extends ExpensesActionState {}
