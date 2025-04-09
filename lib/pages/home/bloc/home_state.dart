part of 'home_bloc.dart';

sealed class HomeState {}

sealed class HomeBudgetState extends HomeState {}

sealed class HomeExpensesState extends HomeState {}

sealed class HomeBudgetTrendState extends HomeState {}

sealed class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {}

class HomeBudgetLoadingState extends HomeBudgetState {}

class HomeBudgetLoadingSuccessState extends HomeBudgetState {
  final List<CategorizedBudgetModel> budget;
  final double totalBudget;
  final double totalSpent;
  final double remaining;

  HomeBudgetLoadingSuccessState(
      {required this.budget,
      required this.totalBudget,
      required this.totalSpent,
      required this.remaining});
}

class HomeBudgetLoadingErrorState extends HomeBudgetState {}

class HomeBudgetTrendLoadingState extends HomeBudgetTrendState {}

class HomeBudgetTrendSuccessState extends HomeBudgetTrendState {
  final List<MonthlyBudgetModel> monthlyBudget;

  HomeBudgetTrendSuccessState({required this.monthlyBudget});
}

class HomeBudgetTrendHiddenState extends HomeBudgetTrendState {}

class HomeBudgetTrendErrosState extends HomeBudgetTrendState {}

class HomeBudgetCategoryItemTappedState extends HomeActionState {
  final CategorizedBudgetModel budget;
  final String month;
  HomeBudgetCategoryItemTappedState(
      {required this.budget, required this.month});
}
