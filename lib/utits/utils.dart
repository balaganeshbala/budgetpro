import 'package:intl/intl.dart';

class Utils {
  static List<String> getYearsList() {
    final currentYear = DateTime.now().year;
    List<String> years = [];
    for (int year = currentYear; year >= 2023; year--) {
      years.add('$year');
    }
    return years;
  }

  static String getMonthAsShortText(DateTime date) {
    final formatter = DateFormat('MMM');
    return formatter.format(date);
  }

  static List<String> getMonthsListForYear(int year) {
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;

    List<String> monthNames = [];
    for (int month = 12; month >= 1; month--) {
      final dateTime = DateTime(year, month);
      if (year == currentYear && month > currentMonth) {
        continue;
      }

      monthNames.add(getMonthAsShortText(dateTime));
    }
    return monthNames;
  }

  static Map<String, DateTime> getMonthStartAndEndDate(String month) {
    final inputFormat = DateFormat('MMM-yyyy');
    final dateTime = inputFormat.parse(month);
    final startDate = DateTime(dateTime.year, dateTime.month, 1);
    final endDate = DateTime(dateTime.year, dateTime.month + 1, 0);

    // Return the formatted start and end dates
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
