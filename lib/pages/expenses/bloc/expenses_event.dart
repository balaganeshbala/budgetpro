part of 'expenses_bloc.dart';

sealed class ExpensesEvent {}

class ExpensesInitialEvent extends ExpensesEvent {}

class ExpensesMonthYearChangedEvent extends ExpensesEvent {
  final String month;
  final String year;

  ExpensesMonthYearChangedEvent({required this.month, required this.year});
}

class ExpensesRefreshEvent extends ExpensesEvent {}

class ExpensesAddExpenseTappedEvent extends ExpensesEvent {}
