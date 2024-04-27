import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:budgetpro/pages/home/models/expenses_model.dart';
import 'package:budgetpro/utits/network_services.dart';
import 'package:intl/intl.dart';

part 'new_expense_event.dart';
part 'new_expense_state.dart';

class NewExpenseBloc extends Bloc<NewExpenseEvent, NewExpenseState> {
  String name = '';
  String amount = '';
  String category = '';
  String date = '';

  final List<String> _expenseCategories = [
    'Loan',
    'Food',
    'Holiday/Trip',
    'Housing',
    'Shopping',
    'Travel',
    'Home',
    'Charges/Fees',
    'Groceries',
    'Health/Beauty',
    'Entertainment',
    'Charity/Gift',
    'Education',
    'Vehicle',
  ];

  NewExpenseBloc() : super(NewExpenseInitial()) {
    on<NewExpenseInitialEvent>(onNewExpenseInitialEvent);
    on<NewExpenseNameValueChanged>(onNewExpenseNameValueChanged);
    on<NewExpenseAmountValueChanged>(onNewExpenseAmountValueChanged);
    on<NewExpenseCategoryValueChanged>(onNewExpenseCategoryValueChanged);
    on<NewExpenseDateValueChanged>(onNewExpenseDateValueChanged);
    on<NewExpenseAddExpenseTappedEvent>(onAddExpenseTappedEvent);
  }

  bool _isInputValid() {
    return name.isNotEmpty &&
        amount.isNotEmpty &&
        category.isNotEmpty & date.isNotEmpty;
  }

  Future<bool> addExpense() async {
    const urlString = 'https://cloudpigeon.cyclic.app/budgetpro/expense/add';

    final postData = {
      'name': name,
      'amount': amount,
      'category': category,
      'date': date
    };
    final result =
        await NetworkCallService.instance.makePostAPICall(urlString, postData);
    final status = result['status'];
    return status;
  }

  FutureOr<void> onNewExpenseInitialEvent(
      NewExpenseInitialEvent event, Emitter<NewExpenseState> emit) {
    category = _expenseCategories.first;
    date = DateFormat('MM/dd/yyyy').format(DateTime.now());
    emit(NewExpensePageLoadedState(categories: _expenseCategories));
  }

  FutureOr<void> onNewExpenseNameValueChanged(
      NewExpenseNameValueChanged event, Emitter<NewExpenseState> emit) {
    name = event.value;
    emit(NewExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onNewExpenseAmountValueChanged(
      NewExpenseAmountValueChanged event, Emitter<NewExpenseState> emit) {
    double? parsedDouble = double.tryParse(event.value);
    if (parsedDouble != null) {
      amount = parsedDouble.toString();
    } else {
      amount = '';
    }
    emit(NewExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onNewExpenseCategoryValueChanged(
      NewExpenseCategoryValueChanged event, Emitter<NewExpenseState> emit) {
    category = event.value;
    emit(NewExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onNewExpenseDateValueChanged(
      NewExpenseDateValueChanged event, Emitter<NewExpenseState> emit) {
    date = DateFormat('MM/dd/yyyy').format(event.value);
    emit(NewExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddExpenseTappedEvent(NewExpenseAddExpenseTappedEvent event,
      Emitter<NewExpenseState> emit) async {
    emit(NewExpenseAddExpenseLoadingState());
    final status = await addExpense();
    if (status == true) {
      emit(NewExpensePageLoadedState(categories: _expenseCategories));
      emit(NewExpenseAddExpenseSuccessState());
    } else {
      emit(NewExpenseAddExpenseErrorState());
    }
  }
}
