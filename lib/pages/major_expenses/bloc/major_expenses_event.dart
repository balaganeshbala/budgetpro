part of 'major_expenses_bloc.dart';

sealed class MajorExpensesEvent {}

class MajorExpensesInitialEvent extends MajorExpensesEvent {}

class MajorExpensesRefreshEvent extends MajorExpensesEvent {}

class MajorExpenseDetailsClickedEvent extends MajorExpensesEvent {
  final MajorExpenseModel expense;

  MajorExpenseDetailsClickedEvent({required this.expense});
}
