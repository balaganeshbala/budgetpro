import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/pages/home/repos/budget_repo.dart';
import 'package:budgetpro/pages/home/repos/expenses_repo.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_event.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_state.dart';
import 'package:budgetpro/utits/utils.dart';

class NewHomeBloc extends Bloc<NewHomeEvent, NewHomeState> {
  String selectedYear = "";
  String selectedMonth = "";
  List<ExpenseModel> expenses = [];
  List<MonthlyBudgetModel> monthlyBudgets = [];

  NewHomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeMonthYearChangedEvent>(homeMonthYearItemChangedEvent);
    on<HomeBudgetCategoryItemTappedEvent>(homeBudgetCategoryItemTappedEvent);
    on<HomeScreenRefreshedEvent>(homeScreenRefreshedEvent);
  }

  FutureOr<void> _startFetchingForMonth(
      String month, Emitter<NewHomeState> emit) async {
    emit(HomeBudgetLoadingState());
    final budget = await BudgetRepo.fetchNewBudgetForMonth(month);
    final expenses = await ExpensesRepo.fetchExpensesForMonth(month);

    double totalSpent = 0.0;
    Map<String, List<ExpenseModel>> categorizedExpenses = {};
    Map<String, double> categorizedSpentAmount = {};
    for (var expense in expenses) {
      totalSpent += expense.amount;
      if (categorizedSpentAmount.containsKey(expense.category)) {
        categorizedSpentAmount[expense.category] =
            categorizedSpentAmount[expense.category]! + expense.amount;
      } else {
        categorizedSpentAmount[expense.category] = expense.amount;
      }

      if (categorizedExpenses.containsKey(expense.category)) {
        categorizedExpenses[expense.category]!.add(expense);
      } else {
        categorizedExpenses[expense.category] = [expense];
      }
    }

    double totalBudget = 0.0;

    for (var category in budget) {
      totalBudget += category.amount;
    }

    final budgetCategories = budget.map((category) {
      double spentAmount = categorizedSpentAmount[category.category] ?? 0.0;
      List<ExpenseModel> expenses =
          categorizedExpenses[category.category] ?? [];
      return CategorizedBudgetModel(
          category: ExpenseCategoryExtension.fromString(category.category),
          budgetAmount: category.amount.toInt(),
          spentAmount: spentAmount,
          expenses: expenses);
    }).toList();

    double remaining = totalBudget - totalSpent;
    emit(HomeBudgetLoadingSuccessState(
        budget: budget,
        budgetCategories: budgetCategories,
        totalBudget: totalBudget,
        totalSpent: totalSpent,
        remaining: remaining));
  }

  // FutureOr<void> _startExpenseFetchingForMonth(
  //     String month, Emitter<NewHomeState> emit) async {
  //   expenses = await ExpensesRepo.fetchExpensesForMonth(month);
  // }

  // FutureOr<void> _startMonthlyBudgetFetching(Emitter<NewHomeState> emit) async {
  //   emit(HomeBudgetTrendLoadingState());
  //   monthlyBudgets = await BudgetRepo.fetchMonthlyBudgets();
  //   monthlyBudgets.removeAt(0);
  //   emit(HomeBudgetTrendSuccessState(monthlyBudget: monthlyBudgets));
  // }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<NewHomeState> emit) async {
    selectedMonth = Utils.getMonthAsShortText(DateTime.now());
    selectedYear = '${DateTime.now().year}';
    await _startFetchingForMonth('$selectedMonth-$selectedYear', emit);
    // await _startExpenseFetchingForMonth('$selectedMonth-$selectedYear', emit);
    // await _startMonthlyBudgetFetching(emit);
  }

  FutureOr<void> homeBudgetCategoryItemTappedEvent(
      HomeBudgetCategoryItemTappedEvent event, Emitter<NewHomeState> emit) {
    String selectedCategory = event.budget.category.name;
    List<ExpenseModel> filteredTransactions = [];
    for (var expense in expenses) {
      if (expense.category == selectedCategory) {
        var updatedExpense = ExpenseModel(
            id: expense.id,
            date: expense.date,
            name: expense.name,
            category: expense.category,
            amount: expense.amount);
        filteredTransactions.add(updatedExpense);
      }
    }
    emit(HomeBudgetCategoryItemTappedState(
        budget: event.budget,
        transactions: filteredTransactions,
        month: '$selectedMonth-$selectedYear'));
  }

  FutureOr<void> homeMonthYearItemChangedEvent(
      HomeMonthYearChangedEvent event, Emitter<NewHomeState> emit) async {
    selectedMonth = event.month;
    selectedYear = event.year;
    await loadOrRefreshScreen(emit);
  }

  FutureOr<void> homeScreenRefreshedEvent(
      HomeScreenRefreshedEvent event, Emitter<NewHomeState> emit) async {
    await loadOrRefreshScreen(emit);
  }

  FutureOr<void> loadOrRefreshScreen(Emitter<NewHomeState> emit) async {
    // emit(HomeBudgetTrendHiddenState());
    await _startFetchingForMonth('$selectedMonth-$selectedYear', emit);
    // await _startExpenseFetchingForMonth('$selectedMonth-$selectedYear', emit);
    // emit(HomeBudgetTrendSuccessState(monthlyBudget: monthlyBudgets));
  }
}
