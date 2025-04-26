import 'package:budgetpro/utits/utils.dart';

class IncomeModel {
  final int id;
  final String date;
  final String source;
  final double amount;

  IncomeModel({
    required this.id,
    required this.date,
    required this.source,
    required this.amount,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json['id'],
      date: Utils.formatDate(json['date']),
      source: json['source'],
      amount: json['amount'].toDouble(),
    );
  }
}
