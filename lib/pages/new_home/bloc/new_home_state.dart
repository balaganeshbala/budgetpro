import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/models/expenses_model.dart';

sealed class NewHomeState {}

sealed class HomeBudgetState extends NewHomeState {}

sealed class HomeExpensesState extends NewHomeState {}

sealed class HomeBudgetTrendState extends NewHomeState {}

sealed class HomeActionState extends NewHomeState {}

class HomeInitial extends NewHomeState {}

class HomeBudgetLoadingState extends HomeBudgetState {}

class HomeBudgetLoadingSuccessState extends HomeBudgetState {
  final List<BudgetModel> budget;
  final List<CategorizedBudgetModel> budgetCategories;
  final double totalBudget;
  final double totalSpent;
  final double remaining;

  HomeBudgetLoadingSuccessState(
      {required this.budget,
      required this.budgetCategories,
      required this.totalBudget,
      required this.totalSpent,
      required this.remaining});
}

class HomeBudgetCategoryItemTappedState extends HomeActionState {
  final CategorizedBudgetModel budget;
  final List<ExpenseModel> transactions;
  final String month;
  HomeBudgetCategoryItemTappedState(
      {required this.budget, required this.transactions, required this.month});
}
