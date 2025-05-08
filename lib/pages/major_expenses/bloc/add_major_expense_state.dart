part of 'add_major_expense_bloc.dart';

sealed class AddMajorExpenseState {}

final class AddMajorExpenseActionState extends AddMajorExpenseState {}

final class AddMajorExpenseInitial extends AddMajorExpenseState {}

final class AddMajorExpenseInputValueChangedState extends AddMajorExpenseState {
  final bool isInputValid;

  AddMajorExpenseInputValueChangedState({required this.isInputValid});
}

final class AddMajorExpensePageLoadedState extends AddMajorExpenseState {
  final List<MajorExpenseCategory> categories;
  final List<String> paymentMethods;

  AddMajorExpensePageLoadedState({
    required this.categories,
    required this.paymentMethods,
  });
}

final class AddMajorExpenseAddExpenseLoadingState
    extends AddMajorExpenseActionState {}

final class AddMajorExpenseAddExpenseSuccessState
    extends AddMajorExpenseActionState {}

final class AddMajorExpenseAddExpenseErrorState
    extends AddMajorExpenseActionState {}
