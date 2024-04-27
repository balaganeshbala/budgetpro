part of 'expenses_bloc.dart';

sealed class ExpensesState {}

sealed class ExpensesFetchState extends ExpensesState {}

sealed class ExpensesActionState extends ExpensesState {}

final class ExpensesInitial extends ExpensesState {}

class ExpensesMonthLoadedSuccessState extends ExpensesState {
  final List<String> yearsList;
  final List<String> monthsList;
  final String selectedYear;
  final String selectedMonth;

  ExpensesMonthLoadedSuccessState(
      {required this.yearsList,
      required this.monthsList,
      required this.selectedYear,
      required this.selectedMonth});
}

class ExpensesMonthItemChangedState extends ExpensesActionState {
  final String year;
  final String month;
  ExpensesMonthItemChangedState({required this.year, required this.month});
}

final class ExpensesLoadingState extends ExpensesFetchState {}

class ExpensesLoadingSuccessState extends ExpensesFetchState {
  final List<ExpenseModel> expenses;

  ExpensesLoadingSuccessState({required this.expenses});
}

class ExpensesLoadingErrorState extends ExpensesFetchState {}

class ExpenesesAddExpenseClickedState extends ExpensesActionState {}
