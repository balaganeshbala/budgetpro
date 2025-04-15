part of 'add_expense_bloc.dart';

sealed class NewExpenseEvent {}

class NewExpenseInitialEvent extends NewExpenseEvent {}

class NewExpenseNameValueChanged extends NewExpenseEvent {
  final String value;

  NewExpenseNameValueChanged({required this.value});
}

class NewExpenseAmountValueChanged extends NewExpenseEvent {
  final String value;

  NewExpenseAmountValueChanged({required this.value});
}

class NewExpenseCategoryValueChanged extends NewExpenseEvent {
  final ExpenseCategory value;

  NewExpenseCategoryValueChanged({required this.value});
}

class NewExpenseDateValueChanged extends NewExpenseEvent {
  final DateTime value;

  NewExpenseDateValueChanged({required this.value});
}

class NewExpenseAddExpenseTappedEvent extends NewExpenseEvent {}
