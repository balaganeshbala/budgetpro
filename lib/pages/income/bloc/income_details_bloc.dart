import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budgetpro/models/income_category_enum.dart';
import 'package:budgetpro/models/income_model.dart';
import 'package:budgetpro/repos/income_repo.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:intl/intl.dart';

part 'income_details_event.dart';
part 'income_details_state.dart';

class IncomeDetailsBloc extends Bloc<IncomeDetailsEvent, IncomeDetailsState> {
  late int incomeId;
  String source = '';
  String amount = '';
  IncomeCategory category = IncomeCategory.other;
  String date = '';
  DateTime? dateObject;

  IncomeDetailsBloc() : super(IncomeDetailsInitial()) {
    on<IncomeDetailsInitialEvent>(onIncomeDetailsInitialEvent);
    on<IncomeDetailsSourceChanged>(onIncomeDetailsSourceChanged);
    on<IncomeDetailsAmountChanged>(onIncomeDetailsAmountChanged);
    on<IncomeDetailsCategoryChanged>(onIncomeDetailsCategoryChanged);
    on<IncomeDetailsDateChanged>(onIncomeDetailsDateChanged);
    on<IncomeDetailsUpdateEvent>(onIncomeDetailsUpdateEvent);
    on<IncomeDetailsDeleteEvent>(onIncomeDetailsDeleteEvent);
  }

  bool _isInputValid() {
    return source.isNotEmpty &&
        amount.isNotEmpty &&
        category != IncomeCategory.other &&
        date.isNotEmpty;
  }

  FutureOr<void> onIncomeDetailsInitialEvent(
      IncomeDetailsInitialEvent event, Emitter<IncomeDetailsState> emit) {
    final income = event.income;
    incomeId = income.id;
    source = income.source;
    amount = income.amount.toString();
    category = income.category;
    date = income.date;

    // Parse the displayed date format to a DateTime object
    dateObject = Utils.parseDate(income.date);

    emit(IncomeDetailsLoadedState(
      categories: IncomeCategoryExtension.getAllCategories(),
    ));

    // Immediately emit input state to ensure button is enabled with valid values
    emit(IncomeDetailsInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onIncomeDetailsSourceChanged(
      IncomeDetailsSourceChanged event, Emitter<IncomeDetailsState> emit) {
    source = event.value;
    emit(IncomeDetailsInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onIncomeDetailsAmountChanged(
      IncomeDetailsAmountChanged event, Emitter<IncomeDetailsState> emit) {
    double? parsedDouble = double.tryParse(event.value);
    if (parsedDouble != null) {
      amount = parsedDouble.toString();
    } else {
      amount = '';
    }
    emit(IncomeDetailsInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onIncomeDetailsCategoryChanged(
      IncomeDetailsCategoryChanged event, Emitter<IncomeDetailsState> emit) {
    category = event.value;
    emit(IncomeDetailsInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onIncomeDetailsDateChanged(
      IncomeDetailsDateChanged event, Emitter<IncomeDetailsState> emit) {
    // Store the DateTime object directly
    dateObject = event.value;

    // Format for display purposes
    date = DateFormat('dd MMM yyyy').format(event.value);

    emit(IncomeDetailsInputValueChangedState(isInputValid: _isInputValid()));
  }

  FutureOr<void> onIncomeDetailsUpdateEvent(
      IncomeDetailsUpdateEvent event, Emitter<IncomeDetailsState> emit) async {
    emit(IncomeDetailsLoadingState());

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
        'source': source,
        'amount': amount,
        'category': category.name,
        'date': formattedDateForDb,
        'user_id': userId,
      };

      final success = await IncomeRepo.updateIncome(incomeId, data);

      if (success) {
        emit(IncomeDetailsUpdatedSuccessState());
        // Return to loaded state after update
        emit(IncomeDetailsLoadedState(
          categories: IncomeCategoryExtension.getAllCategories(),
        ));
        emit(
            IncomeDetailsInputValueChangedState(isInputValid: _isInputValid()));
      } else {
        emit(IncomeDetailsErrorState(error: 'Failed to update income'));
      }
    } catch (e) {
      emit(IncomeDetailsErrorState(error: 'Error: ${e.toString()}'));
    }
  }

  FutureOr<void> onIncomeDetailsDeleteEvent(
      IncomeDetailsDeleteEvent event, Emitter<IncomeDetailsState> emit) async {
    emit(IncomeDetailsLoadingState());

    try {
      final success = await IncomeRepo.deleteIncome(incomeId);

      if (success) {
        emit(IncomeDetailsDeletedSuccessState());
      } else {
        emit(IncomeDetailsErrorState(error: 'Failed to delete income'));
      }
    } catch (e) {
      emit(IncomeDetailsErrorState(error: 'Error: ${e.toString()}'));
    }
  }
}
