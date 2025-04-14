import 'package:equatable/equatable.dart';

abstract class CreateBudgetEvent extends Equatable {
  const CreateBudgetEvent();

  @override
  List<Object> get props => [];
}

class BudgetAmountChanged extends CreateBudgetEvent {
  final String category;
  final double amount;

  const BudgetAmountChanged({required this.category, required this.amount});

  @override
  List<Object> get props => [category, amount];
}

class SaveBudget extends CreateBudgetEvent {
  final String month;
  final String year;

  const SaveBudget({required this.month, required this.year});

  @override
  List<Object> get props => [month, year];
}
