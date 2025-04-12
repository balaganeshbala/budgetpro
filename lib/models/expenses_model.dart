import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/utits/utils.dart';

class ExpenseModel {
  final int id;
  final String date;
  final String name;
  final ExpenseCategory category;
  final double amount;

  ExpenseModel(
      {required this.id,
      required this.date,
      required this.name,
      required this.category,
      required this.amount});

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
        id: json['id'],
        date: Utils.formatDate(json['date']),
        name: json['name'],
        category: ExpenseCategoryExtension.fromString(json['category']),
        amount: json['amount'].toDouble());
  }
}
