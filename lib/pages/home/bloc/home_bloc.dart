import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:budgetpro/pages/home/models/budget_model.dart';
import 'package:budgetpro/pages/home/models/expenses_model.dart';
import 'package:budgetpro/pages/home/repos/budget_repo.dart';
import 'package:budgetpro/pages/home/repos/expenses_repo.dart';
import 'package:budgetpro/utits/utils.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  String selectedYear = "";
  String selectedMonth = "";
  List<ExpenseModel> expenses = [];
  List<MonthlyBudgetModel> monthlyBudgets = [];

  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeMonthYearChangedEvent>(homeMonthYearItemChangedEvent);
    on<HomeBudgetCategoryItemTappedEvent>(homeBudgetCategoryItemTappedEvent);
  }

  FutureOr<void> _startBudgetFetchingForMonth(
      String month, Emitter<HomeState> emit) async {
    emit(HomeBudgetLoadingState());
    final budget = await BudgetRepo.fetchBudgetForMonth(month);
    double totalBudget = 0.0;
    double totalSpent = 0.0;
    for (var category in budget) {
      totalBudget += category.budgetAmount;
      totalSpent += category.spentAmount;
    }
    double remaining = totalBudget - totalSpent;
    emit(HomeBudgetLoadingSuccessState(
        budget: budget,
        totalBudget: totalBudget,
        totalSpent: totalSpent,
        remaining: remaining));
  }

  FutureOr<void> _startExpenseFetchingForMonth(
      String month, Emitter<HomeState> emit) async {
    expenses = await ExpensesRepo.fetchExpensesForMonth(month);
  }

  FutureOr<void> _startMonthlyBudgetFetching(Emitter<HomeState> emit) async {
    emit(HomeBudgetTrendLoadingState());
    monthlyBudgets = await BudgetRepo.fetchMonthlyBudgets();
    monthlyBudgets.removeAt(0);
    emit(HomeBudgetTrendSuccessState(monthlyBudget: monthlyBudgets));
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    selectedMonth = Utils.getMonthAsShortText(DateTime.now());
    selectedYear = '${DateTime.now().year}';
    await _startBudgetFetchingForMonth('$selectedMonth-$selectedYear', emit);
    await _startExpenseFetchingForMonth('$selectedMonth-$selectedYear', emit);
    await _startMonthlyBudgetFetching(emit);
  }

  FutureOr<void> homeBudgetCategoryItemTappedEvent(
      HomeBudgetCategoryItemTappedEvent event, Emitter<HomeState> emit) {
    String selectedCategory = event.budget.category;
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
      HomeMonthYearChangedEvent event, Emitter<HomeState> emit) async {
    selectedMonth = event.month;
    selectedYear = event.year;

    emit(HomeBudgetTrendHiddenState());
    await _startBudgetFetchingForMonth('$selectedMonth-$selectedYear', emit);
    await _startExpenseFetchingForMonth('$selectedMonth-$selectedYear', emit);
    emit(HomeBudgetTrendSuccessState(monthlyBudget: monthlyBudgets));
  }
}
