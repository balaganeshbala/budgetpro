// edit_budget_event.dart
import 'package:budgetpro/models/budget_model.dart';

abstract class EditBudgetEvent {}

class EditBudgetInitialEvent extends EditBudgetEvent {
  final Map<String, BudgetModel> budgetItems;

  EditBudgetInitialEvent({required this.budgetItems});
}

class EditBudgetAmountChanged extends EditBudgetEvent {
  final String category;
  final double amount;

  EditBudgetAmountChanged({required this.category, required this.amount});
}

class UpdateBudget extends EditBudgetEvent {
  final List<BudgetModel> newBudgetItems;

  UpdateBudget({required this.newBudgetItems});
}
