import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UIUtils {
  static String formatRupees(double amount) {
    NumberFormat rupeeFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return rupeeFormat.format(amount);
  }

  static IconData iconForCategory(String category) {
    switch (category) {
      case "Loan":
        return Icons.account_balance_outlined;
      case "Holiday/Trip":
        return Icons.beach_access;
      case "Housing":
        return Icons.house_outlined;
      case "Shopping":
        return Icons.shopping_bag_outlined;
      case "Travel":
        return Icons.directions_car_outlined;
      case "Vehicle":
        return Icons.directions_bike_outlined;
      case "Food":
        return Icons.restaurant_rounded;
      case "Home":
        return Icons.people_outline;
      case "Charges/Fees":
        return Icons.attach_money;
      case "Groceries":
        return Icons.local_grocery_store_outlined;
      case "Health/Beauty":
        return Icons.spa_outlined;
      case "Entertainment":
        return Icons.theaters_outlined;
      case "Charity/Gift":
        return Icons.card_giftcard;
      case "Education":
        return Icons.school_outlined;
      default:
        return Icons.note_outlined;
    }
  }
}
