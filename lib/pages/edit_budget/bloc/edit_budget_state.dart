import 'package:budgetpro/models/budget_model.dart';

enum EditBudgetStatus { initial, loading, info, success, failure }

class EditBudgetState {
  final Map<String, BudgetModel> budgets;
  final EditBudgetStatus status;
  final String? errorMessage;
  final double totalBudget;

  const EditBudgetState({
    this.budgets = const {},
    this.status = EditBudgetStatus.initial,
    this.errorMessage,
    this.totalBudget = 0.0,
  });

  EditBudgetState copyWith({
    Map<String, BudgetModel>? budgets,
    EditBudgetStatus? status,
    String? errorMessage,
    double? totalBudget,
  }) {
    return EditBudgetState(
      budgets: budgets ?? this.budgets,
      status: status ?? this.status,
      errorMessage: errorMessage,
      totalBudget: totalBudget ?? this.totalBudget,
    );
  }
}
