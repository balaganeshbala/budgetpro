part of 'add_expense_bloc.dart';

sealed class AddExpenseEvent {}

class AddExpenseInitialEvent extends AddExpenseEvent {}

class AddExpenseNameValueChanged extends AddExpenseEvent {
  final String value;

  AddExpenseNameValueChanged({required this.value});
}

class AddExpenseAmountValueChanged extends AddExpenseEvent {
  final String value;

  AddExpenseAmountValueChanged({required this.value});
}

class AddExpenseCategoryValueChanged extends AddExpenseEvent {
  final ExpenseCategory value;

  AddExpenseCategoryValueChanged({required this.value});
}

class AddExpenseDateValueChanged extends AddExpenseEvent {
  final DateTime value;

  AddExpenseDateValueChanged({required this.value});
}

class AddExpenseAddExpenseTappedEvent extends AddExpenseEvent {}
