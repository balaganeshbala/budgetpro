part of 'major_expenses_bloc.dart';

sealed class MajorExpensesState {}

sealed class MajorExpensesFetchState extends MajorExpensesState {}

sealed class MajorExpensesActionState extends MajorExpensesState {}

final class MajorExpensesInitial extends MajorExpensesState {}

final class MajorExpensesLoadingState extends MajorExpensesFetchState {}

final class MajorExpensesLoadedState extends MajorExpensesFetchState {
  final List<MajorExpenseModel> expenses;
  final double totalAmount;

  MajorExpensesLoadedState({
    required this.expenses,
    required this.totalAmount,
  });
}

final class MajorExpensesErrorState extends MajorExpensesFetchState {
  final String message;

  MajorExpensesErrorState({required this.message});
}

final class MajorExpenseDetailsClickedState extends MajorExpensesActionState {
  final MajorExpenseModel expense;

  MajorExpenseDetailsClickedState({required this.expense});
}
