import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budgetpro/models/major_expense_category_enum.dart';
import 'package:budgetpro/repos/major_expense_repo.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'package:intl/intl.dart';

part 'add_major_expense_event.dart';
part 'add_major_expense_state.dart';

class AddMajorExpenseBloc
    extends Bloc<AddMajorExpenseEvent, AddMajorExpenseState> {
  String name = '';
  String amount = '';
  String category = '';
  String date = '';
  String paymentMethod = '';
  String? notes;

  final List<MajorExpenseCategory> _majorExpenseCategories =
      MajorExpenseCategoryExtension.getAllCategories();
  final List<String> _paymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'Insurance',
    'Savings',
    'Loan',
    'EMI',
    'Other'
  ];

  AddMajorExpenseBloc() : super(AddMajorExpenseInitial()) {
    on<AddMajorExpenseInitialEvent>(onAddMajorExpenseInitialEvent);
    on<AddMajorExpenseNameValueChanged>(onAddMajorExpenseNameValueChanged);
    on<AddMajorExpenseAmountValueChanged>(onAddMajorExpenseAmountValueChanged);
    on<AddMajorExpenseCategoryValueChanged>(
        onAddMajorExpenseCategoryValueChanged);
    on<AddMajorExpenseDateValueChanged>(onAddMajorExpenseDateValueChanged);
    on<AddMajorExpensePaymentMethodValueChanged>(
        onAddMajorExpensePaymentMethodValueChanged);
    on<AddMajorExpenseNotesValueChanged>(onAddMajorExpenseNotesValueChanged);
    on<AddMajorExpenseAddExpenseTappedEvent>(onAddMajorExpenseTappedEvent);
  }

  bool _isInputValid() {
    return name.isNotEmpty &&
        amount.isNotEmpty &&
        category.isNotEmpty &&
        date.isNotEmpty &&
        paymentMethod.isNotEmpty;
  }

  Future<bool> addMajorExpense() async {
    final userId = SupabaseService.client.auth.currentUser?.id;

    final data = {
      'name': name,
      'amount': amount,
      'category': category,
      'date': date,
      'notes': notes,
      'user_id': userId
    };
    final status = await MajorExpenseRepo.addMajorExpense(data);
    return status;
  }

  FutureOr<void> onAddMajorExpenseInitialEvent(
      AddMajorExpenseInitialEvent event, Emitter<AddMajorExpenseState> emit) {
    // Set default category and payment method
    category = _majorExpenseCategories.first.name;
    paymentMethod = _paymentMethods.first;
    date = DateFormat('MM/dd/yyyy').format(DateTime.now());
    emit(AddMajorExpensePageLoadedState(
      categories: _majorExpenseCategories,
      paymentMethods: _paymentMethods,
    ));
  }

  FutureOr<void> onAddMajorExpenseNameValueChanged(
      AddMajorExpenseNameValueChanged event,
      Emitter<AddMajorExpenseState> emit) {
    name = event.value;
    emit(AddMajorExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddMajorExpenseAmountValueChanged(
      AddMajorExpenseAmountValueChanged event,
      Emitter<AddMajorExpenseState> emit) {
    double? parsedDouble = double.tryParse(event.value);
    if (parsedDouble != null) {
      amount = parsedDouble.toString();
    } else {
      amount = '';
    }
    emit(AddMajorExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddMajorExpenseCategoryValueChanged(
      AddMajorExpenseCategoryValueChanged event,
      Emitter<AddMajorExpenseState> emit) {
    category = event.value.name;
    emit(AddMajorExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddMajorExpenseDateValueChanged(
      AddMajorExpenseDateValueChanged event,
      Emitter<AddMajorExpenseState> emit) {
    date = DateFormat('MM/dd/yyyy').format(event.value);
    emit(AddMajorExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddMajorExpensePaymentMethodValueChanged(
      AddMajorExpensePaymentMethodValueChanged event,
      Emitter<AddMajorExpenseState> emit) {
    paymentMethod = event.value;
    emit(AddMajorExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddMajorExpenseNotesValueChanged(
      AddMajorExpenseNotesValueChanged event,
      Emitter<AddMajorExpenseState> emit) {
    notes = event.value;
    // Notes are optional, so we don't need to validate them
    emit(AddMajorExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onAddMajorExpenseTappedEvent(
      AddMajorExpenseAddExpenseTappedEvent event,
      Emitter<AddMajorExpenseState> emit) async {
    emit(AddMajorExpenseAddExpenseLoadingState());
    final status = await addMajorExpense();
    if (status == true) {
      emit(AddMajorExpensePageLoadedState(
        categories: _majorExpenseCategories,
        paymentMethods: _paymentMethods,
      ));
      emit(AddMajorExpenseAddExpenseSuccessState());
    } else {
      emit(AddMajorExpenseAddExpenseErrorState());
    }
  }
}
