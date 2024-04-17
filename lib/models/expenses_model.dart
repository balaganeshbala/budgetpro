class DayWiseExpensesModel {
  final String id;
  final String date;
  final List<ExpenseModel> expenses;

  DayWiseExpensesModel(
      {required this.id, required this.date, required this.expenses});

  factory DayWiseExpensesModel.fromJson(Map<String, dynamic> json) {
    return DayWiseExpensesModel(
      id: json['id'],
      date: json['date'],
      expenses: (json['expenses'] as List<dynamic>)
          .map((item) => ExpenseModel.fromJson(item))
          .toList(),
    );
  }
}

class ExpenseModel {
  final int id;
  final String name;
  final String category;
  final double amount;

  ExpenseModel(
      {required this.id,
      required this.name,
      required this.category,
      required this.amount});

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        amount: json['amount'].toDouble());
  }
}
