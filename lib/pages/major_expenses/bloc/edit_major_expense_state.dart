part of 'edit_major_expense_bloc.dart';

sealed class EditMajorExpenseState {}

final class EditMajorExpenseInitial extends EditMajorExpenseState {}

final class EditMajorExpenseLoadedState extends EditMajorExpenseState {
  final List<MajorExpenseCategory> categories;

  EditMajorExpenseLoadedState({required this.categories});
}

final class EditMajorExpenseInputValueChangedState
    extends EditMajorExpenseState {
  final bool isInputValid;

  EditMajorExpenseInputValueChangedState({required this.isInputValid});
}

final class EditMajorExpenseLoadingState extends EditMajorExpenseState {}

final class EditMajorExpenseSuccessState extends EditMajorExpenseState {}

final class EditMajorExpenseErrorState extends EditMajorExpenseState {
  final String error;

  EditMajorExpenseErrorState({required this.error});
}

final class EditMajorExpenseDeletedState extends EditMajorExpenseState {}
