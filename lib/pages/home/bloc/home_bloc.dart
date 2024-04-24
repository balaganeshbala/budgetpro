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
  List<String> yearsList = [];
  List<String> monthsList = [];
  String selectedYear = "";
  String selectedMonth = "";
  List<ExpenseModel> expenses = [];

  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeYearChangedEvent>(homeYearItemChangedEvent);
    on<HomeMonthChangedEvent>(homeMonthItemChangedEvent);
    on<HomeBudgetCategoryItemTappedEvent>(homeBudgetCategoryItemTappedEvent);
  }

  void _startYearAndMonthFetching(Emitter<HomeState> emit) {
    emit(HomeLoadingState());
    yearsList = Utils.getYearsList();
    selectedYear = yearsList.first;
    monthsList = Utils.getMonthsListForYear(int.parse(selectedYear));
    selectedMonth = monthsList.first;
    emit(HomeMonthLoadedSuccessState(
        yearsList: yearsList,
        monthsList: monthsList,
        selectedYear: yearsList.first,
        selectedMonth: monthsList.first));
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
        remaining: remaining,
        month: '$selectedMonth-$selectedYear'));
  }

  FutureOr<void> _startExpenseFetchingForMonth(
      String month, Emitter<HomeState> emit) async {
    expenses = await ExpensesRepo.fetchExpensesForMonth(month);
  }

  FutureOr<void> _startMonthlyBudgetFetching(Emitter<HomeState> emit) async {
    emit(HomeBudgetTrendLoadingState());
    final monthlyBudget = await BudgetRepo.fetchMonthlyBudget();
    emit(HomeBudgetTrendSuccessState(monthlyBudget: monthlyBudget));
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    _startYearAndMonthFetching(emit);
    await _startBudgetFetchingForMonth('$selectedMonth-$selectedYear', emit);
    await _startExpenseFetchingForMonth('$selectedMonth-$selectedYear', emit);
    await _startMonthlyBudgetFetching(emit);
  }

  FutureOr<void> homeYearItemChangedEvent(
      HomeYearChangedEvent event, Emitter<HomeState> emit) {
    selectedYear = event.year;
    monthsList = Utils.getMonthsListForYear(int.parse(selectedYear));
    emit(HomeMonthLoadedSuccessState(
        yearsList: yearsList,
        monthsList: monthsList,
        selectedYear: selectedYear,
        selectedMonth: monthsList.first));
  }

  FutureOr<void> homeMonthItemChangedEvent(
      HomeMonthChangedEvent event, Emitter<HomeState> emit) async {
    selectedMonth = event.month;
    emit(HomeMonthLoadedSuccessState(
        yearsList: yearsList,
        monthsList: monthsList,
        selectedYear: selectedYear,
        selectedMonth: selectedMonth));
    emit(HomeMonthItemChangedState(year: selectedYear, month: selectedMonth));
    await _startBudgetFetchingForMonth('$selectedMonth-$selectedYear', emit);
    await _startExpenseFetchingForMonth('$selectedMonth-$selectedYear', emit);
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
        budget: event.budget, transactions: filteredTransactions));
  }
}
