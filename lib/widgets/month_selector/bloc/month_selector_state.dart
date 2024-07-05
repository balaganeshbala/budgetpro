part of 'month_selector_bloc.dart';

final class MonthSelectorState {
  final String selectedMonth;
  final String selectedYear;
  final DateTime selectedValue;

  MonthSelectorState({
    required this.selectedMonth,
    required this.selectedYear,
    required this.selectedValue,
  });
}
