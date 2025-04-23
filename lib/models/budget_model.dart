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
  ExpenseCategory category;
  double amount;
  String userId;

  BudgetModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.userId,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
      id: json["id"],
      category: ExpenseCategoryExtension.fromString(json["category"]),
      amount: json["amount"]?.toDouble(),
      userId: json["user_id"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "amount": amount,
        "user_id": userId,
      };

  BudgetModel copyWith({required double amount}) {
    return BudgetModel(
      id: id,
      category: category,
      amount: amount,
      userId: userId,
    );
  }
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
