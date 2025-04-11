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

  NewHomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeMonthYearChangedEvent>(homeMonthYearItemChangedEvent);
    on<HomeBudgetCategoryItemTappedEvent>(homeBudgetCategoryItemTappedEvent);
    on<HomeScreenRefreshedEvent>(homeScreenRefreshedEvent);
  }

  FutureOr<void> _startFetchingForMonth(
      String month, Emitter<NewHomeState> emit) async {
    emit(HomeLoadingState());
    final budget = await BudgetRepo.fetchNewBudgetForMonth(month);
    expenses = await ExpensesRepo.fetchExpensesForMonth(month);

    double totalSpent = 0.0;
    Map<String, List<ExpenseModel>> categorizedExpenses = {};
    Map<String, double> categorizedSpentAmount = {};
    for (var expense in expenses) {
      totalSpent += expense.amount;
      if (categorizedSpentAmount.containsKey(expense.category.name)) {
        categorizedSpentAmount[expense.category.name] =
            categorizedSpentAmount[expense.category.name]! + expense.amount;
      } else {
        categorizedSpentAmount[expense.category.name] = expense.amount;
      }

      if (categorizedExpenses.containsKey(expense.category.name)) {
        categorizedExpenses[expense.category.name]!.add(expense);
      } else {
        categorizedExpenses[expense.category.name] = [expense];
      }
    }

    double totalBudget = 0.0;

    final budgetCategories = budget.map((budgetItem) {
      totalBudget += budgetItem.amount;
      double spentAmount =
          categorizedSpentAmount[budgetItem.category.name] ?? 0.0;
      List<ExpenseModel> expenses =
          categorizedExpenses[budgetItem.category.name] ?? [];
      return CategorizedBudgetModel(
          category: budgetItem.category,
          budgetAmount: budgetItem.amount.toInt(),
          spentAmount: spentAmount,
          expenses: expenses);
    }).toList();

    double remaining = totalBudget - totalSpent;
    emit(HomeLoadingSuccessState(
        budget: budget,
        budgetCategories: budgetCategories,
        totalBudget: totalBudget,
        totalSpent: totalSpent,
        remaining: remaining,
        expenses: expenses));
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
    emit(HomeBudgetCategoryItemTappedState(
        budget: event.budget, month: '$selectedMonth-$selectedYear'));
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
