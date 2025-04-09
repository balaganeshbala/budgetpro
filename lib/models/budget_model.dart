import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/models/expenses_model.dart';

class CategorizedBudgetModel {
  ExpenseCategory category;
  int budgetAmount;
  double spentAmount;
  List<ExpenseModel> expenses = [];

  CategorizedBudgetModel({
    required this.category,
    required this.budgetAmount,
    required this.spentAmount,
    required this.expenses,
  });
}

class BudgetModel {
  int id;
  String category;
  double amount;

  BudgetModel({
    required this.id,
    required this.category,
    required this.amount,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
        id: json["id"],
        category: json["category"],
        amount: json["amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "amount": amount,
      };
}

class MonthlyBudgetModel {
  String month;
  int budgetAmount;
  double spentAmount;

  MonthlyBudgetModel({
    required this.month,
    required this.budgetAmount,
    required this.spentAmount,
  });

  factory MonthlyBudgetModel.fromJson(Map<String, dynamic> json) =>
      MonthlyBudgetModel(
        month: json["month"],
        budgetAmount: json["budgetAmount"],
        spentAmount: json["spentAmount"]?.toDouble(),
      );
}
