import 'package:budgetpro/utits/utils.dart';

class MajorExpenseModel {
  final int id;
  final String name;
  final String category;
  final String date;
  final double amount;
  final String? notes;

  MajorExpenseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.amount,
    this.notes,
  });

  factory MajorExpenseModel.fromJson(Map<String, dynamic> json) {
    return MajorExpenseModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      date: Utils.formatDate(json['date']),
      amount: json['amount'].toDouble(),
      notes: json['notes'],
    );
  }
}
