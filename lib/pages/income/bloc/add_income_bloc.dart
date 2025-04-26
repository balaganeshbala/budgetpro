import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budgetpro/models/income_category_enum.dart';
import 'package:budgetpro/repos/income_repo.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'package:intl/intl.dart';

part 'add_income_event.dart';
part 'add_income_state.dart';

class AddIncomeBloc extends Bloc<AddIncomeEvent, AddIncomeState> {
  String source = '';
  String amount = '';
  String category = '';
  String date = '';

  final List<IncomeCategory> _incomeCategories =
      IncomeCategoryExtension.getAllCategories();

  AddIncomeBloc() : super(AddIncomeInitial()) {
    on<AddIncomeInitialEvent>(onAddIncomeInitialEvent);
    on<AddIncomeSourceValueChanged>(onAddIncomeSourceValueChanged);
    on<AddIncomeAmountValueChanged>(onAddIncomeAmountValueChanged);
    on<AddIncomeCategoryValueChanged>(onAddIncomeCategoryValueChanged);
    on<AddIncomeDateValueChanged>(onAddIncomeDateValueChanged);
    on<AddIncomeAddIncomeTappedEvent>(onAddIncomeTappedEvent);
  }

  bool _isInputValid() {
    return source.isNotEmpty &&
        amount.isNotEmpty &&
        category.isNotEmpty &&
        date.isNotEmpty;
  }

  Future<bool> addIncome() async {
    final userId = SupabaseService.client.auth.currentUser?.id;

    final data = {
      'source': source,
      'amount': amount,
      'category': category,
      'date': date,
      'user_id': userId
    };
    final status = await IncomeRepo.addIncome(data);
    return status;
  }

  FutureOr<void> onAddIncomeInitialEvent(
      AddIncomeInitialEvent event, Emitter<AddIncomeState> emit) {
    // Set default category
    category = _incomeCategories.first.name;
    date = DateFormat('MM/dd/yyyy').format(DateTime.now());
    emit(AddIncomePageLoadedState(categories: _incomeCategories));
  }

  FutureOr<void> onAddIncomeSourceValueChanged(
      AddIncomeSourceValueChanged event, Emitter<AddIncomeState> emit) {
    source = event.value;
    emit(AddIncomeInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddIncomeAmountValueChanged(
      AddIncomeAmountValueChanged event, Emitter<AddIncomeState> emit) {
    double? parsedDouble = double.tryParse(event.value);
    if (parsedDouble != null) {
      amount = parsedDouble.toString();
    } else {
      amount = '';
    }
    emit(AddIncomeInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddIncomeCategoryValueChanged(
      AddIncomeCategoryValueChanged event, Emitter<AddIncomeState> emit) {
    category = event.value.name;
    emit(AddIncomeInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddIncomeDateValueChanged(
      AddIncomeDateValueChanged event, Emitter<AddIncomeState> emit) {
    date = DateFormat('MM/dd/yyyy').format(event.value);
    emit(AddIncomeInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddIncomeTappedEvent(
      AddIncomeAddIncomeTappedEvent event, Emitter<AddIncomeState> emit) async {
    emit(AddIncomeAddIncomeLoadingState());
    final status = await addIncome();
    if (status == true) {
      emit(AddIncomePageLoadedState(categories: _incomeCategories));
      emit(AddIncomeAddIncomeSuccessState());
    } else {
      emit(AddIncomeAddIncomeErrorState());
    }
  }
}
