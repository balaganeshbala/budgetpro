import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:budgetpro/pages/home/models/budget_model.dart';
import 'package:budgetpro/pages/home/repos/budget_repo.dart';
import 'package:intl/intl.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<String> yearsList = [];
  List<String> monthsList = [];
  String selectedYear = "";
  String selectedMonth = "";

  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeYearChangedEvent>(homeYearItemChangedEvent);
    on<HomeMonthChangedEvent>(homeMonthItemChangedEvent);
    on<HomeBudgetCategoryItemTappedEvent>(homeBudgetCategoryItemTappedEvent);
  }

  List<String> _getYearsList() {
    final currentYear = DateTime.now().year;
    List<String> years = [];
    for (int year = currentYear; year >= 2023; year--) {
      years.add('$year');
    }
    return years;
  }

  List<String> _getMonthsListForYear(int year) {
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;

    List<String> monthNames = [];
    for (int month = 12; month >= 1; month--) {
      final dateTime = DateTime(year, month);
      if (year == currentYear && month > currentMonth) {
        continue;
      }
      final formatter = DateFormat('MMM');
      monthNames.add(formatter.format(dateTime));
    }
    return monthNames;
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

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    yearsList = _getYearsList();
    selectedYear = yearsList.first;
    monthsList = _getMonthsListForYear(int.parse(selectedYear));
    selectedMonth = monthsList.first;
    emit(HomeMonthLoadedSuccessState(
        yearsList: yearsList,
        monthsList: monthsList,
        selectedYear: yearsList.first,
        selectedMonth: monthsList.first));

    await _startBudgetFetchingForMonth('$selectedMonth-$selectedYear', emit);
  }

  FutureOr<void> homeYearItemChangedEvent(
      HomeYearChangedEvent event, Emitter<HomeState> emit) {
    selectedYear = event.year;
    monthsList = _getMonthsListForYear(int.parse(selectedYear));
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
  }

  FutureOr<void> homeBudgetCategoryItemTappedEvent(
      HomeBudgetCategoryItemTappedEvent event, Emitter<HomeState> emit) {
    emit(HomeBudgetCategoryItemTappedState(budget: event.budget));
  }
}
