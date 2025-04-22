import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/repos/expenses_repo.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'package:intl/intl.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  String name = '';
  String amount = '';
  String category = '';
  String date = '';

  final List<ExpenseCategory> _expenseCategories =
      ExpenseCategoryExtension.getAllCategories();

  AddExpenseBloc() : super(AddExpenseInitial()) {
    on<AddExpenseInitialEvent>(onAddExpenseInitialEvent);
    on<AddExpenseNameValueChanged>(onAddExpenseNameValueChanged);
    on<AddExpenseAmountValueChanged>(onAddExpenseAmountValueChanged);
    on<AddExpenseCategoryValueChanged>(onAddExpenseCategoryValueChanged);
    on<AddExpenseDateValueChanged>(onAddExpenseDateValueChanged);
    on<AddExpenseAddExpenseTappedEvent>(onAddExpenseTappedEvent);
  }

  bool _isInputValid() {
    return name.isNotEmpty &&
        amount.isNotEmpty &&
        category.isNotEmpty &&
        date.isNotEmpty;
  }

  Future<bool> addExpense() async {
    final userId = SupabaseService.client.auth.currentUser?.id;

    final data = {
      'name': name,
      'amount': amount,
      'category': category,
      'date': date,
      'user_id': userId
    };
    final status = await ExpensesRepo.addExpense(data);
    return status;
  }

  FutureOr<void> onAddExpenseInitialEvent(
      AddExpenseInitialEvent event, Emitter<AddExpenseState> emit) {
    category = _expenseCategories.first.name;
    date = DateFormat('MM/dd/yyyy').format(DateTime.now());
    emit(AddExpensePageLoadedState(categories: _expenseCategories));
  }

  FutureOr<void> onAddExpenseNameValueChanged(
      AddExpenseNameValueChanged event, Emitter<AddExpenseState> emit) {
    name = event.value;
    emit(AddExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddExpenseAmountValueChanged(
      AddExpenseAmountValueChanged event, Emitter<AddExpenseState> emit) {
    double? parsedDouble = double.tryParse(event.value);
    if (parsedDouble != null) {
      amount = parsedDouble.toString();
    } else {
      amount = '';
    }
    emit(AddExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddExpenseCategoryValueChanged(
      AddExpenseCategoryValueChanged event, Emitter<AddExpenseState> emit) {
    category = event.value.name;
    emit(AddExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddExpenseDateValueChanged(
      AddExpenseDateValueChanged event, Emitter<AddExpenseState> emit) {
    date = DateFormat('MM/dd/yyyy').format(event.value);
    emit(AddExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddExpenseTappedEvent(AddExpenseAddExpenseTappedEvent event,
      Emitter<AddExpenseState> emit) async {
    emit(AddExpenseAddExpenseLoadingState());
    final status = await addExpense();
    if (status == true) {
      emit(AddExpensePageLoadedState(categories: _expenseCategories));
      emit(AddExpenseAddExpenseSuccessState());
    } else {
      emit(AddExpenseAddExpenseErrorState());
    }
  }
}
