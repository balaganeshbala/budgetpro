import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/models/income_model.dart';

sealed class NewHomeState {}

sealed class HomeContentState extends NewHomeState {}

sealed class HomeActionState extends NewHomeState {}

class HomeLoadingState extends HomeContentState {}

class HomeInitial extends NewHomeState {}

class HomeBudgetPendingState extends HomeContentState {}

class HomeLoadingSuccessState extends HomeContentState {
  final List<BudgetModel> budget;
  final List<CategorizedBudgetModel> budgetCategories;
  final double totalBudget;
  final double totalSpent;
  final double remaining;
  final List<ExpenseModel> expenses;
  final List<IncomeModel> incomes;

  HomeLoadingSuccessState(
      {required this.budget,
      required this.budgetCategories,
      required this.totalBudget,
      required this.totalSpent,
      required this.remaining,
      required this.expenses,
      required this.incomes});
}

class HomeBudgetCategoryItemTappedState extends HomeActionState {
  final CategorizedBudgetModel budget;
  final String month;
  final String year;
  HomeBudgetCategoryItemTappedState(
      {required this.budget, required this.month, required this.year});
}
