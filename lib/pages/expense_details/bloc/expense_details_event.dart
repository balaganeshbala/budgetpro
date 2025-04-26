part of 'expense_details_bloc.dart';

// Events
sealed class ExpenseDetailsEvent {}

class ExpenseDetailsInitialEvent extends ExpenseDetailsEvent {
  final ExpenseModel expense;

  ExpenseDetailsInitialEvent({required this.expense});
}

class ExpenseDetailsNameChanged extends ExpenseDetailsEvent {
  final String value;

  ExpenseDetailsNameChanged({required this.value});
}

class ExpenseDetailsAmountChanged extends ExpenseDetailsEvent {
  final String value;

  ExpenseDetailsAmountChanged({required this.value});
}

class ExpenseDetailsCategoryChanged extends ExpenseDetailsEvent {
  final ExpenseCategory value;

  ExpenseDetailsCategoryChanged({required this.value});
}

class ExpenseDetailsDateChanged extends ExpenseDetailsEvent {
  final DateTime value;

  ExpenseDetailsDateChanged({required this.value});
}

class ExpenseDetailsUpdateEvent extends ExpenseDetailsEvent {}

class ExpenseDetailsDeleteEvent extends ExpenseDetailsEvent {}
