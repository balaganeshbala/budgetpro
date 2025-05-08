part of 'edit_major_expense_bloc.dart';

sealed class EditMajorExpenseEvent {}

class EditMajorExpenseInitialEvent extends EditMajorExpenseEvent {
  final MajorExpenseModel expense;

  EditMajorExpenseInitialEvent({required this.expense});
}

class EditMajorExpenseNameChanged extends EditMajorExpenseEvent {
  final String value;

  EditMajorExpenseNameChanged({required this.value});
}

class EditMajorExpenseAmountChanged extends EditMajorExpenseEvent {
  final String value;

  EditMajorExpenseAmountChanged({required this.value});
}

class EditMajorExpenseCategoryChanged extends EditMajorExpenseEvent {
  final MajorExpenseCategory value;

  EditMajorExpenseCategoryChanged({required this.value});
}

class EditMajorExpenseDateValueChanged extends EditMajorExpenseEvent {
  final DateTime value;

  EditMajorExpenseDateValueChanged({required this.value});
}

class EditMajorExpenseNotesChanged extends EditMajorExpenseEvent {
  final String value;

  EditMajorExpenseNotesChanged({required this.value});
}

class EditMajorExpenseUpdateEvent extends EditMajorExpenseEvent {}

class EditMajorExpenseDeleteEvent extends EditMajorExpenseEvent {}
