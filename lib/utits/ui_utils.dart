import 'package:intl/intl.dart';

class UIUtils {
  static String formatRupees(double amount) {
    NumberFormat rupeeFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return rupeeFormat.format(amount);
  }
}
