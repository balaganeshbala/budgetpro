class BudgetModel {
  String category;
  int budgetAmount;
  double spentAmount;

  BudgetModel({
    required this.category,
    required this.budgetAmount,
    required this.spentAmount,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
        category: json["category"],
        budgetAmount: json["budgetAmount"],
        spentAmount: json["spentAmount"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "budgetAmount": budgetAmount,
        "spentAmount": spentAmount,
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
