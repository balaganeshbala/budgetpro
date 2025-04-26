part of 'add_income_bloc.dart';

sealed class AddIncomeState {}

final class AddIncomeActionState extends AddIncomeState {}

final class AddIncomeInitial extends AddIncomeState {}

final class AddIncomeInputValueChangedState extends AddIncomeState {
  final bool isInputValid;

  AddIncomeInputValueChangedState({required this.isInputValid});
}

final class AddIncomePageLoadedState extends AddIncomeState {
  final List<IncomeCategory> categories;

  AddIncomePageLoadedState({required this.categories});
}

final class AddIncomeAddIncomeLoadingState extends AddIncomeActionState {}

final class AddIncomeAddIncomeSuccessState extends AddIncomeActionState {}

final class AddIncomeAddIncomeErrorState extends AddIncomeActionState {}
