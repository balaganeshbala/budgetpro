import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/pages/edit_budget/bloc/edit_budget_event.dart';
import 'package:budgetpro/pages/edit_budget/bloc/edit_budget_state.dart';
import 'package:budgetpro/repos/budget_repo.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBudgetBloc extends Bloc<EditBudgetEvent, EditBudgetState> {
  EditBudgetBloc() : super(EditBudgetState()) {
    on<EditBudgetInitialEvent>(_onInitialEvent);
    on<EditBudgetAmountChanged>(_onAmountChanged);
    on<UpdateBudget>(_onUpdateBudget);
  }

  void _onInitialEvent(
      EditBudgetInitialEvent event, Emitter<EditBudgetState> emit) {
    Map<String, BudgetModel> budgets = {};
    double totalBudget = 0.0;

    event.budgetItems.forEach((key, budget) {
      budgets[key] = budget;
      totalBudget += budget.amount;
    });

    emit(EditBudgetState(
      budgets: budgets,
      totalBudget: totalBudget,
    ));
  }

  void _onAmountChanged(
      EditBudgetAmountChanged event, Emitter<EditBudgetState> emit) {
    final updatedBudgets = Map<String, BudgetModel>.from(state.budgets);
    updatedBudgets[event.category] = updatedBudgets[event.category]!.copyWith(
      amount: event.amount,
    );
    final totalBudget =
        updatedBudgets.values.fold(0.0, (sum, budget) => sum + budget.amount);

    emit(EditBudgetState(
      budgets: updatedBudgets,
      totalBudget: totalBudget,
    ));
  }

  Future<void> _onUpdateBudget(
      UpdateBudget event, Emitter<EditBudgetState> emit) async {
    emit(state.copyWith(status: EditBudgetStatus.loading, errorMessage: null));

    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated!');
      }

      if (event.newBudgetItems.isEmpty) {
        emit(state.copyWith(
          status: EditBudgetStatus.failure,
          errorMessage: 'No budget items to update!',
        ));
        return;
      }

      await BudgetRepo.updateBudget(budgets: event.newBudgetItems);
      emit(state.copyWith(status: EditBudgetStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: EditBudgetStatus.failure,
        errorMessage: 'Failed to update budget!',
      ));
    }
  }
}
