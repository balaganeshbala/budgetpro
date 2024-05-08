import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum SnackbarType { INFO, SUCCESS, ERROR, WARNING }

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

  static Color colorForCategory(String category) {
    switch (category) {
      case "Loan":
        return Colors.blueAccent;
      case "Holiday/Trip":
        return Colors.orange;
      case "Housing":
        return Colors.purple;
      case "Shopping":
        return Colors.green;
      case "Travel":
        return Colors.red;
      case "Vehicle":
        return Colors.blueGrey;
      case "Food":
        return Colors.deepOrange;
      case "Home":
        return Colors.indigo;
      case "Charges/Fees":
        return Colors.teal;
      case "Groceries":
        return Colors.brown;
      case "Health/Beauty":
        return Colors.pink;
      case "Entertainment":
        return Colors.lightBlue;
      case "Charity/Gift":
        return Colors.deepPurple;
      case "Education":
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  static void showSnackbar(BuildContext context, String message,
      {SnackbarType type = SnackbarType.INFO}) {
    Color backgroundColor;
    IconData iconData;

    switch (type) {
      case SnackbarType.INFO:
        backgroundColor = Colors.blue;
        iconData = Icons.info;
        break;
      case SnackbarType.SUCCESS:
        backgroundColor = Colors.green;
        iconData = Icons.check_circle;
        break;
      case SnackbarType.ERROR:
        backgroundColor = Colors.red;
        iconData = Icons.error;
        break;
      case SnackbarType.WARNING:
        backgroundColor = Colors.amber;
        iconData = Icons.warning;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(iconData, color: Colors.white),
            const SizedBox(width: 8),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
