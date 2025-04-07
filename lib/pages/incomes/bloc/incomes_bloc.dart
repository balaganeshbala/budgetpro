import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budgetpro/pages/home/models/incomes_model.dart';
import 'package:budgetpro/pages/home/repos/incomes_repo.dart';
import 'package:budgetpro/utits/utils.dart';

part 'incomes_event.dart';
part 'incomes_state.dart';

class IncomesBloc extends Bloc<IncomesEvent, IncomesState> {
  List<String> yearsList = [];
  List<String> monthsList = [];
  String selectedYear = "";
  String selectedMonth = "";
  List<IncomeModel> incomes = [];

  IncomesBloc() : super(IncomesInitial()) {
    on<IncomesInitialEvent>(_incomesInitialEvent);
    on<IncomesMonthYearChangedEvent>(_incomesMonthYearChangedEvent);
    on<IncomesAddIncomeTappedEvent>(_incomesAddIncomeTappedEvent);
    on<IncomesRefreshEvent>(_incomesRefreshEvent);
  }

  FutureOr<void> _startIncomeFetchingForMonth(
      String month, Emitter<IncomesState> emit) async {
    emit(IncomesLoadingState());
    incomes = await IncomesRepo.fetchIncomesForMonth(month);
    print(incomes);
    emit(IncomesLoadingSuccessState(incomes: incomes));
  }

  FutureOr<void> _incomesInitialEvent(
      IncomesInitialEvent event, Emitter<IncomesState> emit) async {
    selectedMonth = Utils.getMonthAsShortText(DateTime.now());
    selectedYear = '${DateTime.now().year}';
    await _startIncomeFetchingForMonth('$selectedMonth-$selectedYear', emit);
  }

  FutureOr<void> _incomesMonthYearChangedEvent(
      IncomesMonthYearChangedEvent event, Emitter<IncomesState> emit) async {
    selectedMonth = event.month;
    selectedYear = event.year;
    await _startIncomeFetchingForMonth('$selectedMonth-$selectedYear', emit);
  }

  FutureOr<void> _incomesAddIncomeTappedEvent(
      IncomesAddIncomeTappedEvent event, Emitter<IncomesState> emit) {
    emit(IncomesAddIncomeClickedState());
  }

  FutureOr<void> _incomesRefreshEvent(
      IncomesRefreshEvent event, Emitter<IncomesState> emit) async {
    await _startIncomeFetchingForMonth('$selectedMonth-$selectedYear', emit);
  }
}
