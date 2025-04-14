import 'package:equatable/equatable.dart';

enum BudgetStatus { initial, loading, success, failure }

class CreateBudgetState extends Equatable {
  final Map<String, double> categoryBudgets;
  final double totalBudget;
  final BudgetStatus status;
  final String? errorMessage;

  const CreateBudgetState({
    this.categoryBudgets = const {},
    this.totalBudget = 0.0,
    this.status = BudgetStatus.initial,
    this.errorMessage,
  });

  CreateBudgetState copyWith({
    Map<String, double>? categoryBudgets,
    double? totalBudget,
    BudgetStatus? status,
    String? errorMessage,
  }) {
    return CreateBudgetState(
      categoryBudgets: categoryBudgets ?? this.categoryBudgets,
      totalBudget: totalBudget ?? this.totalBudget,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [categoryBudgets, totalBudget, status, errorMessage];
}
