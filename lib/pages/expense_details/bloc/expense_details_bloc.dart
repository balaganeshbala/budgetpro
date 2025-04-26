import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/repos/expenses_repo.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:intl/intl.dart';

part 'expense_details_event.dart';
part 'expense_details_state.dart';

class ExpenseDetailsBloc
    extends Bloc<ExpenseDetailsEvent, ExpenseDetailsState> {
  late int expenseId;
  String name = '';
  String amount = '';
  ExpenseCategory category = ExpenseCategory.unknown;
  String date = '';
  DateTime? dateObject;

  ExpenseDetailsBloc() : super(ExpenseDetailsInitial()) {
    on<ExpenseDetailsInitialEvent>(onExpenseDetailsInitialEvent);
    on<ExpenseDetailsNameChanged>(onExpenseDetailsNameChanged);
    on<ExpenseDetailsAmountChanged>(onExpenseDetailsAmountChanged);
    on<ExpenseDetailsCategoryChanged>(onExpenseDetailsCategoryChanged);
    on<ExpenseDetailsDateChanged>(onExpenseDetailsDateChanged);
    on<ExpenseDetailsUpdateEvent>(onExpenseDetailsUpdateEvent);
    on<ExpenseDetailsDeleteEvent>(onExpenseDetailsDeleteEvent);
  }

  bool _isInputValid() {
    return name.isNotEmpty &&
        amount.isNotEmpty &&
        category != ExpenseCategory.unknown &&
        date.isNotEmpty;
  }

  FutureOr<void> onExpenseDetailsInitialEvent(
      ExpenseDetailsInitialEvent event, Emitter<ExpenseDetailsState> emit) {
    final expense = event.expense;
    expenseId = expense.id;
    name = expense.name;
    amount = expense.amount.toString();
    category = expense.category;
    date = expense.date;

    // Parse the displayed date format to a DateTime object
    dateObject = Utils.parseDate(expense.date);

    emit(ExpenseDetailsLoadedState(
      categories: ExpenseCategoryExtension.getAllCategories(),
    ));

    // Immediately emit input state to ensure button is enabled with valid values
    emit(ExpenseDetailsInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onExpenseDetailsNameChanged(
      ExpenseDetailsNameChanged event, Emitter<ExpenseDetailsState> emit) {
    name = event.value;
    emit(ExpenseDetailsInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onExpenseDetailsAmountChanged(
      ExpenseDetailsAmountChanged event, Emitter<ExpenseDetailsState> emit) {
    double? parsedDouble = double.tryParse(event.value);
    if (parsedDouble != null) {
      amount = parsedDouble.toString();
    } else {
      amount = '';
    }
    emit(ExpenseDetailsInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onExpenseDetailsCategoryChanged(
      ExpenseDetailsCategoryChanged event, Emitter<ExpenseDetailsState> emit) {
    category = event.value;
    emit(ExpenseDetailsInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onExpenseDetailsDateChanged(
      ExpenseDetailsDateChanged event, Emitter<ExpenseDetailsState> emit) {
    // Store the DateTime object directly
    dateObject = event.value;

    // Format for display purposes
    date = DateFormat('dd MMM yyyy').format(event.value);

    emit(ExpenseDetailsInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onExpenseDetailsUpdateEvent(ExpenseDetailsUpdateEvent event,
      Emitter<ExpenseDetailsState> emit) async {
    emit(ExpenseDetailsLoadingState());

    try {
      // Format date in yyyy-MM-dd format for database storage
      String formattedDateForDb = '';
      if (dateObject != null) {
        formattedDateForDb = DateFormat('yyyy-MM-dd').format(dateObject!);
      } else {
        // Fallback: try to parse the display date and format for db
        final parsedDate = Utils.parseDate(date);
        formattedDateForDb = DateFormat('yyyy-MM-dd').format(parsedDate);
      }

      final userId = SupabaseService.client.auth.currentUser?.id;

      final data = {
        'name': name,
        'amount': amount,
        'category': category.name,
        'date': formattedDateForDb,
        'user_id': userId,
      };

      final success = await ExpensesRepo.updateExpense(expenseId, data);

      if (success) {
        emit(ExpenseDetailsUpdatedSuccessState());
        // Return to loaded state after update
        emit(ExpenseDetailsLoadedState(
          categories: ExpenseCategoryExtension.getAllCategories(),
        ));
        emit(ExpenseDetailsInputValueChangedState(
            isInputValid: _isInputValid()));
      } else {
        emit(ExpenseDetailsErrorState(error: 'Failed to update expense'));
      }
    } catch (e) {
      emit(ExpenseDetailsErrorState(error: 'Error: ${e.toString()}'));
    }
  }

  FutureOr<void> onExpenseDetailsDeleteEvent(ExpenseDetailsDeleteEvent event,
      Emitter<ExpenseDetailsState> emit) async {
    emit(ExpenseDetailsLoadingState());

    try {
      final success = await ExpensesRepo.deleteExpense(expenseId);

      if (success) {
        emit(ExpenseDetailsDeletedSuccessState());
      } else {
        emit(ExpenseDetailsErrorState(error: 'Failed to delete expense'));
      }
    } catch (e) {
      emit(ExpenseDetailsErrorState(error: 'Error: ${e.toString()}'));
    }
  }
}
