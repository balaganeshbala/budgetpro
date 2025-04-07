part of 'incomes_bloc.dart';

sealed class IncomesState {}

sealed class IncomesFetchState extends IncomesState {}

sealed class IncomesActionState extends IncomesState {}

final class IncomesInitial extends IncomesState {}

final class IncomesLoadingState extends IncomesFetchState {}

class IncomesLoadingSuccessState extends IncomesFetchState {
  final List<IncomeModel> incomes;

  IncomesLoadingSuccessState({required this.incomes});
}

class IncomesLoadingErrorState extends IncomesFetchState {}

class IncomesAddIncomeClickedState extends IncomesActionState {}
