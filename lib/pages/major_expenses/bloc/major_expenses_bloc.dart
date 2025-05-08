import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budgetpro/models/major_expense_model.dart';
import 'package:budgetpro/repos/major_expense_repo.dart';

part 'major_expenses_event.dart';
part 'major_expenses_state.dart';

class MajorExpensesBloc extends Bloc<MajorExpensesEvent, MajorExpensesState> {
  List<MajorExpenseModel> expenses = [];
  double totalAmount = 0.0;

  MajorExpensesBloc() : super(MajorExpensesInitial()) {
    on<MajorExpensesInitialEvent>(onMajorExpensesInitialEvent);
    on<MajorExpensesRefreshEvent>(onMajorExpensesRefreshEvent);
    on<MajorExpenseDetailsClickedEvent>(onMajorExpenseDetailsClickedEvent);
  }

  FutureOr<void> _fetchMajorExpenses(Emitter<MajorExpensesState> emit) async {
    emit(MajorExpensesLoadingState());
    try {
      expenses = await MajorExpenseRepo.fetchMajorExpenses();
      totalAmount = await MajorExpenseRepo.getTotalMajorExpenses();
      emit(MajorExpensesLoadedState(
        expenses: expenses,
        totalAmount: totalAmount,
      ));
    } catch (e) {
      emit(MajorExpensesErrorState(message: e.toString()));
    }
  }

  FutureOr<void> onMajorExpensesInitialEvent(
      MajorExpensesInitialEvent event, Emitter<MajorExpensesState> emit) async {
    await _fetchMajorExpenses(emit);
  }

  FutureOr<void> onMajorExpensesRefreshEvent(
      MajorExpensesRefreshEvent event, Emitter<MajorExpensesState> emit) async {
    await _fetchMajorExpenses(emit);
  }

  FutureOr<void> onMajorExpenseDetailsClickedEvent(
      MajorExpenseDetailsClickedEvent event, Emitter<MajorExpensesState> emit) {
    emit(MajorExpenseDetailsClickedState(expense: event.expense));
    // Re-emit the loaded state to maintain UI after navigation
    emit(MajorExpensesLoadedState(
      expenses: expenses,
      totalAmount: totalAmount,
    ));
  }
}
