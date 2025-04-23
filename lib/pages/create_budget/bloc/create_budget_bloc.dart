// budget_bloc.dart (updated)
import 'package:budgetpro/repos/budget_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'create_budget_event.dart';
import 'create_budget_state.dart';

class CreateBudgetBloc extends Bloc<CreateBudgetEvent, CreateBudgetState> {
  final List<ExpenseCategory> categories;

  CreateBudgetBloc({
    required this.categories,
  }) : super(const CreateBudgetState()) {
    on<BudgetAmountChanged>(_onBudgetAmountChanged);
    on<SaveBudget>(_onSaveBudget);
  }

  void _onBudgetAmountChanged(
    BudgetAmountChanged event,
    Emitter<CreateBudgetState> emit,
  ) {
    final updatedBudgets = Map<String, double>.from(state.categoryBudgets);
    updatedBudgets[event.category] = event.amount;

    // Calculate total budget
    final totalBudget =
        updatedBudgets.values.fold(0.0, (sum, amount) => sum + amount);

    emit(state.copyWith(
      categoryBudgets: updatedBudgets,
      totalBudget: totalBudget,
    ));
  }

  Future<void> _onSaveBudget(
    SaveBudget event,
    Emitter<CreateBudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));

    if (!BudgetRepo.hasAtLeastOneBudget(state.categoryBudgets)) {
      emit(state.copyWith(
        status: BudgetStatus.failure,
        errorMessage: 'Please set at least one budget category',
      ));
      return;
    }

    try {
      await BudgetRepo.saveBudget(
        month: event.month,
        year: event.year,
        categoryBudgets: state.categoryBudgets,
        categories: categories,
      );
      emit(state.copyWith(status: BudgetStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: BudgetStatus.failure,
        errorMessage: 'Error creating budget!',
      ));
    }
  }
}
