part of 'home_bloc.dart';

sealed class HomeState {}

sealed class HomeBudgetState extends HomeState {}

sealed class HomeExpensesState extends HomeState {}

sealed class HomeBudgetTrendState extends HomeState {}

sealed class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeMonthLoadedSuccessState extends HomeState {
  final List<String> yearsList;
  final List<String> monthsList;
  final String selectedYear;
  final String selectedMonth;

  HomeMonthLoadedSuccessState(
      {required this.yearsList,
      required this.monthsList,
      required this.selectedYear,
      required this.selectedMonth});
}

class HomeErrorState extends HomeState {}

class HomeBudgetLoadingState extends HomeBudgetState {}

class HomeBudgetLoadingSuccessState extends HomeBudgetState {
  final List<BudgetModel> budget;
  final double totalBudget;
  final double totalSpent;
  final double remaining;
  final String month;

  HomeBudgetLoadingSuccessState(
      {required this.budget,
      required this.totalBudget,
      required this.totalSpent,
      required this.remaining,
      required this.month});
}

class HomeBudgetLoadingErrorState extends HomeBudgetState {}

class HomeBudgetTrendLoadingState extends HomeBudgetTrendState {}

class HomeBudgetTrendSuccessState extends HomeBudgetTrendState {
  final List<MonthlyBudgetModel> monthlyBudget;

  HomeBudgetTrendSuccessState({required this.monthlyBudget});
}

class HomeBudgetTrendErrosState extends HomeBudgetTrendState {}

class HomeMonthItemChangedState extends HomeActionState {
  final String year;
  final String month;
  HomeMonthItemChangedState({required this.year, required this.month});
}

class HomeBudgetCategoryItemTappedState extends HomeActionState {
  final BudgetModel budget;
  final List<ExpenseModel> transactions;
  HomeBudgetCategoryItemTappedState(
      {required this.budget, required this.transactions});
}
