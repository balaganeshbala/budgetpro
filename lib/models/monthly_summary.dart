import 'package:intl/intl.dart';

class MonthlySummary {
  final int year;
  final int month;
  final double amount;
  final String? categoryName;
  final String? categoryType;

  MonthlySummary({
    required this.year,
    required this.month,
    required this.amount,
    this.categoryName,
    this.categoryType,
  });

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      year: json['year'],
      month: json['month'],
      amount: json['total_amount'].toDouble(),
      categoryName: json['category_name'],
      categoryType: json['category_type'],
    );
  }

  String get monthName {
    final date = DateTime(year, month);
    return DateFormat('MMM').format(date);
  }

  DateTime get date {
    return DateTime(year, month, 1);
  }
}
