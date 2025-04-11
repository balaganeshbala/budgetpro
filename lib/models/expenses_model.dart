import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/pages/expenses/bloc/expenses_bloc.dart';
import 'package:budgetpro/utits/utils.dart';

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
