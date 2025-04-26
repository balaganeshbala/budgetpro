import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/models/income_model.dart';
import 'package:budgetpro/repos/budget_repo.dart';
import 'package:budgetpro/repos/expenses_repo.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_event.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_state.dart';
import 'package:budgetpro/repos/income_repo.dart';
import 'package:budgetpro/utits/utils.dart';

class NewHomeBloc extends Bloc<NewHomeEvent, NewHomeState> {
  String selectedYear = "";
  String selectedMonth = "";
  List<ExpenseModel> expenses = [];
  List<IncomeModel> incomes = [];

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
    if (budget.isEmpty) {
      emit(HomeBudgetPendingState());
      return;
    }

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

    incomes = await IncomeRepo.fetchIncomesForMonth(month);

    double remaining = totalBudget - totalSpent;
    emit(HomeLoadingSuccessState(
        budget: budget,
        budgetCategories: budgetCategories,
        totalBudget: totalBudget,
        totalSpent: totalSpent,
        remaining: remaining,
        expenses: expenses,
        incomes: incomes));
  }

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
    await _startFetchingForMonth('$selectedMonth-$selectedYear', emit);
  }

  FutureOr<void> homeScreenRefreshedEvent(
      HomeScreenRefreshedEvent event, Emitter<NewHomeState> emit) async {
    await _startFetchingForMonth('$selectedMonth-$selectedYear', emit);
  }
}
