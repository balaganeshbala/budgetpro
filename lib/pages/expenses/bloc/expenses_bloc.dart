import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budgetpro/pages/home/models/expenses_model.dart';
import 'package:budgetpro/pages/home/repos/expenses_repo.dart';
import 'package:budgetpro/utits/utils.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  List<String> yearsList = [];
  List<String> monthsList = [];
  String selectedYear = "";
  String selectedMonth = "";
  List<ExpenseModel> expenses = [];

  ExpensesBloc() : super(ExpensesInitial()) {
    on<ExpensesInitialEvent>(expensesInitialEvent);
    on<ExpensesYearChangedEvent>(expensesYearItemChangedEvent);
    on<ExpensesMonthChangedEvent>(expensesMonthItemChangedEvent);
    on<ExpensesAddExpenseTappedEvent>(expensesAddExpenseTappedEvent);
    on<ExpensesRefreshEvent>(expensesRefreshEvent);
  }

  void _startYearAndMonthFetching(Emitter<ExpensesState> emit) {
    yearsList = Utils.getYearsList();
    selectedYear = yearsList.first;
    monthsList = Utils.getMonthsListForYear(int.parse(selectedYear));
    selectedMonth = monthsList.first;
    emit(ExpensesMonthLoadedSuccessState(
        yearsList: yearsList,
        monthsList: monthsList,
        selectedYear: yearsList.first,
        selectedMonth: monthsList.first));
  }

  FutureOr<void> _startExpenseFetchingForMonth(
      String month, Emitter<ExpensesState> emit) async {
    emit(ExpensesLoadingState());
    expenses = await ExpensesRepo.fetchExpensesForMonth(month);
    emit(ExpensesLoadingSuccessState(expenses: expenses));
  }

  FutureOr<void> expensesInitialEvent(
      ExpensesInitialEvent event, Emitter<ExpensesState> emit) async {
    _startYearAndMonthFetching(emit);
    await _startExpenseFetchingForMonth('$selectedMonth-$selectedYear', emit);
  }

  FutureOr<void> expensesYearItemChangedEvent(
      ExpensesYearChangedEvent event, Emitter<ExpensesState> emit) {
    selectedYear = event.year;
    monthsList = Utils.getMonthsListForYear(int.parse(selectedYear));
    emit(ExpensesMonthLoadedSuccessState(
        yearsList: yearsList,
        monthsList: monthsList,
        selectedYear: selectedYear,
        selectedMonth: monthsList.first));
  }

  FutureOr<void> expensesMonthItemChangedEvent(
      ExpensesMonthChangedEvent event, Emitter<ExpensesState> emit) async {
    selectedMonth = event.month;
    emit(ExpensesMonthLoadedSuccessState(
        yearsList: yearsList,
        monthsList: monthsList,
        selectedYear: selectedYear,
        selectedMonth: selectedMonth));
    emit(ExpensesMonthItemChangedState(
        year: selectedYear, month: selectedMonth));
    await _startExpenseFetchingForMonth('$selectedMonth-$selectedYear', emit);
  }

  FutureOr<void> expensesAddExpenseTappedEvent(
      ExpensesAddExpenseTappedEvent event, Emitter<ExpensesState> emit) {
    emit(ExpenesesAddExpenseClickedState());
  }

  FutureOr<void> expensesRefreshEvent(
      ExpensesRefreshEvent event, Emitter<ExpensesState> emit) async {
    await _startExpenseFetchingForMonth('$selectedMonth-$selectedYear', emit);
  }
}
