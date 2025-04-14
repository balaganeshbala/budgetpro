import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/repos/expenses_repo.dart';
import 'package:budgetpro/utits/utils.dart';

part 'all_expenses_event.dart';
part 'all_expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  List<String> yearsList = [];
  List<String> monthsList = [];
  String selectedYear = "";
  String selectedMonth = "";
  List<ExpenseModel> expenses = [];

  ExpensesBloc() : super(ExpensesInitial()) {
    on<ExpensesInitialEvent>(expensesInitialEvent);
    on<ExpensesMonthYearChangedEvent>(expensesMonthItemChangedEvent);
    on<ExpensesAddExpenseTappedEvent>(expensesAddExpenseTappedEvent);
    on<ExpensesRefreshEvent>(expensesRefreshEvent);
  }

  FutureOr<void> _startExpenseFetchingForMonth(
      String month, Emitter<ExpensesState> emit) async {
    emit(ExpensesLoadingState());
    expenses = await ExpensesRepo.fetchExpensesForMonth(month);
    emit(ExpensesLoadingSuccessState(expenses: expenses));
  }

  FutureOr<void> expensesInitialEvent(
      ExpensesInitialEvent event, Emitter<ExpensesState> emit) async {
    selectedMonth = Utils.getMonthAsShortText(DateTime.now());
    selectedYear = '${DateTime.now().year}';
    await _startExpenseFetchingForMonth('$selectedMonth-$selectedYear', emit);
  }

  FutureOr<void> expensesMonthItemChangedEvent(
      ExpensesMonthYearChangedEvent event, Emitter<ExpensesState> emit) async {
    selectedMonth = event.month;
    selectedYear = event.year;
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
