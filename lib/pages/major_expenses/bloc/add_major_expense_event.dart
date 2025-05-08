part of 'add_major_expense_bloc.dart';

sealed class AddMajorExpenseEvent {}

class AddMajorExpenseInitialEvent extends AddMajorExpenseEvent {}

class AddMajorExpenseNameValueChanged extends AddMajorExpenseEvent {
  final String value;

  AddMajorExpenseNameValueChanged({required this.value});
}

class AddMajorExpenseAmountValueChanged extends AddMajorExpenseEvent {
  final String value;

  AddMajorExpenseAmountValueChanged({required this.value});
}

class AddMajorExpenseCategoryValueChanged extends AddMajorExpenseEvent {
  final MajorExpenseCategory value;

  AddMajorExpenseCategoryValueChanged({required this.value});
}

class AddMajorExpenseDateValueChanged extends AddMajorExpenseEvent {
  final DateTime value;

  AddMajorExpenseDateValueChanged({required this.value});
}

class AddMajorExpensePaymentMethodValueChanged extends AddMajorExpenseEvent {
  final String value;

  AddMajorExpensePaymentMethodValueChanged({required this.value});
}

class AddMajorExpenseNotesValueChanged extends AddMajorExpenseEvent {
  final String value;

  AddMajorExpenseNotesValueChanged({required this.value});
}

class AddMajorExpenseAddExpenseTappedEvent extends AddMajorExpenseEvent {}
