import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budgetpro/models/major_expense_category_enum.dart';
import 'package:budgetpro/models/major_expense_model.dart';
import 'package:budgetpro/repos/major_expense_repo.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:intl/intl.dart';

part 'edit_major_expense_event.dart';
part 'edit_major_expense_state.dart';

class EditMajorExpenseBloc
    extends Bloc<EditMajorExpenseEvent, EditMajorExpenseState> {
  int expenseId = 0;
  String name = '';
  String amount = '';
  String category = '';
  String date = '';
  DateTime? dateObject;
  String? notes;

  final List<MajorExpenseCategory> _categories =
      MajorExpenseCategoryExtension.getAllCategories();

  EditMajorExpenseBloc() : super(EditMajorExpenseInitial()) {
    on<EditMajorExpenseInitialEvent>(onEditMajorExpenseInitialEvent);
    on<EditMajorExpenseNameChanged>(onEditMajorExpenseNameChanged);
    on<EditMajorExpenseAmountChanged>(onEditMajorExpenseAmountChanged);
    on<EditMajorExpenseCategoryChanged>(onEditMajorExpenseCategoryChanged);
    on<EditMajorExpenseDateValueChanged>(onEditMajorExpenseDateValueChanged);
    on<EditMajorExpenseNotesChanged>(onEditMajorExpenseNotesChanged);
    on<EditMajorExpenseUpdateEvent>(onEditMajorExpenseUpdateEvent);
    on<EditMajorExpenseDeleteEvent>(onEditMajorExpenseDeleteEvent);
  }

  bool _isInputValid() {
    return name.isNotEmpty &&
        amount.isNotEmpty &&
        category.isNotEmpty &&
        date.isNotEmpty;
  }

  FutureOr<void> onEditMajorExpenseInitialEvent(
      EditMajorExpenseInitialEvent event, Emitter<EditMajorExpenseState> emit) {
    // Initialize values from the existing expense
    expenseId = event.expense.id;
    name = event.expense.name;
    amount = event.expense.amount.toString();
    category = event.expense.category.name;
    date = event.expense.date;
    notes = event.expense.notes;

    // Parse the displayed date format to a DateTime object
    dateObject = Utils.parseDate(event.expense.date);

    emit(EditMajorExpenseLoadedState(categories: _categories));

    // Immediately emit input state to ensure button is enabled with valid values
    emit(EditMajorExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onEditMajorExpenseNameChanged(
      EditMajorExpenseNameChanged event, Emitter<EditMajorExpenseState> emit) {
    name = event.value;
    emit(EditMajorExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onEditMajorExpenseAmountChanged(
      EditMajorExpenseAmountChanged event,
      Emitter<EditMajorExpenseState> emit) {
    double? parsedDouble = double.tryParse(event.value);
    if (parsedDouble != null) {
      amount = parsedDouble.toString();
    } else {
      amount = '';
    }
    emit(EditMajorExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onEditMajorExpenseCategoryChanged(
      EditMajorExpenseCategoryChanged event,
      Emitter<EditMajorExpenseState> emit) {
    category = event.value.name;
    emit(EditMajorExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onEditMajorExpenseDateValueChanged(
      EditMajorExpenseDateValueChanged event,
      Emitter<EditMajorExpenseState> emit) {
    // Store the DateTime object directly
    dateObject = event.value;

    // Format for display purposes
    date = DateFormat('dd MMM yyyy').format(event.value);

    emit(EditMajorExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onEditMajorExpenseNotesChanged(
      EditMajorExpenseNotesChanged event, Emitter<EditMajorExpenseState> emit) {
    notes = event.value;
    // Notes are optional, so we don't need to validate them
    emit(EditMajorExpenseInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onEditMajorExpenseUpdateEvent(
      EditMajorExpenseUpdateEvent event,
      Emitter<EditMajorExpenseState> emit) async {
    emit(EditMajorExpenseLoadingState());

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
        'category': category,
        'date': formattedDateForDb,
        'notes': notes,
        'user_id': userId,
      };

      final success =
          await MajorExpenseRepo.updateMajorExpense(expenseId, data);

      if (success) {
        emit(EditMajorExpenseSuccessState());
      } else {
        emit(EditMajorExpenseErrorState(error: 'Failed to update expense'));
      }
    } catch (e) {
      emit(EditMajorExpenseErrorState(error: 'Error: ${e.toString()}'));
    }
  }

  FutureOr<void> onEditMajorExpenseDeleteEvent(
      EditMajorExpenseDeleteEvent event,
      Emitter<EditMajorExpenseState> emit) async {
    emit(EditMajorExpenseLoadingState());
    try {
      final success = await MajorExpenseRepo.deleteMajorExpense(expenseId!);
      if (success) {
        emit(EditMajorExpenseDeletedState());
      } else {
        emit(EditMajorExpenseErrorState(error: 'Failed to delete expense'));
      }
    } catch (e) {
      emit(EditMajorExpenseErrorState(error: e.toString()));
    }
  }
}
