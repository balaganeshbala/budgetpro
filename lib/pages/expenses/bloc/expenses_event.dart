part of 'expenses_bloc.dart';

sealed class ExpensesEvent {}

class ExpensesInitialEvent extends ExpensesEvent {}

class ExpensesYearChangedEvent extends ExpensesEvent {
  final String year;

  ExpensesYearChangedEvent({required this.year});
}

class ExpensesMonthChangedEvent extends ExpensesEvent {
  final String month;

  ExpensesMonthChangedEvent({required this.month});
}
