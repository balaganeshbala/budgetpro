part of 'incomes_bloc.dart';

sealed class IncomesEvent {}

class IncomesInitialEvent extends IncomesEvent {}

class IncomesMonthYearChangedEvent extends IncomesEvent {
  final String month;
  final String year;

  IncomesMonthYearChangedEvent({required this.month, required this.year});
}

class IncomesRefreshEvent extends IncomesEvent {}

class IncomesAddIncomeTappedEvent extends IncomesEvent {}
