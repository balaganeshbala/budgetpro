import 'package:flutter/material.dart';

enum ExpenseCategory {
  emi,
  food,
  holidayTrip,
  housing,
  shopping,
  travel,
  home,
  chargesFees,
  groceries,
  healthBeauty,
  entertainment,
  charityGift,
  education,
  vehicle,
  unknown,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.emi:
        return 'EMI';
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.holidayTrip:
        return 'Holiday/Trip';
      case ExpenseCategory.housing:
        return 'Housing';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.travel:
        return 'Travel';
      case ExpenseCategory.home:
        return 'Home';
      case ExpenseCategory.chargesFees:
        return 'Charges/Fees';
      case ExpenseCategory.groceries:
        return 'Groceries';
      case ExpenseCategory.healthBeauty:
        return 'Health/Beauty';
      case ExpenseCategory.entertainment:
        return 'Entertainment';
      case ExpenseCategory.charityGift:
        return 'Charity/Gift';
      case ExpenseCategory.education:
        return 'Education';
      case ExpenseCategory.vehicle:
        return 'Vehicle';
      default:
        return 'Unknown';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.emi:
        return Icons.account_balance_outlined;
      case ExpenseCategory.holidayTrip:
        return Icons.beach_access;
      case ExpenseCategory.housing:
        return Icons.house_outlined;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag_outlined;
      case ExpenseCategory.travel:
        return Icons.directions_car_outlined;
      case ExpenseCategory.vehicle:
        return Icons.directions_bike_outlined;
      case ExpenseCategory.food:
        return Icons.restaurant_rounded;
      case ExpenseCategory.home:
        return Icons.people_outline;
      case ExpenseCategory.chargesFees:
        return Icons.attach_money;
      case ExpenseCategory.groceries:
        return Icons.local_grocery_store_outlined;
      case ExpenseCategory.healthBeauty:
        return Icons.spa_outlined;
      case ExpenseCategory.entertainment:
        return Icons.theaters_outlined;
      case ExpenseCategory.charityGift:
        return Icons.card_giftcard;
      case ExpenseCategory.education:
        return Icons.school_outlined;
      default:
        return Icons.note_outlined;
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.emi:
        return Colors.blueAccent;
      case ExpenseCategory.holidayTrip:
        return Colors.orange;
      case ExpenseCategory.housing:
        return Colors.purple;
      case ExpenseCategory.shopping:
        return Colors.green;
      case ExpenseCategory.travel:
        return Colors.red;
      case ExpenseCategory.vehicle:
        return Colors.blueGrey;
      case ExpenseCategory.food:
        return Colors.deepOrange;
      case ExpenseCategory.home:
        return Colors.indigo;
      case ExpenseCategory.chargesFees:
        return Colors.teal;
      case ExpenseCategory.groceries:
        return Colors.brown;
      case ExpenseCategory.healthBeauty:
        return Colors.pink;
      case ExpenseCategory.entertainment:
        return Colors.lightBlue;
      case ExpenseCategory.charityGift:
        return Colors.deepPurple;
      case ExpenseCategory.education:
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  static ExpenseCategory fromString(String category) {
    switch (category) {
      case 'emi':
        return ExpenseCategory.emi;
      case 'food':
        return ExpenseCategory.food;
      case 'holidayTrip':
        return ExpenseCategory.holidayTrip;
      case 'housing':
        return ExpenseCategory.housing;
      case 'shopping':
        return ExpenseCategory.shopping;
      case 'travel':
        return ExpenseCategory.travel;
      case 'home':
        return ExpenseCategory.home;
      case 'chargesFees':
        return ExpenseCategory.chargesFees;
      case 'groceries':
        return ExpenseCategory.groceries;
      case 'healthBeauty':
        return ExpenseCategory.healthBeauty;
      case 'entertainment':
        return ExpenseCategory.entertainment;
      case 'charityGift':
        return ExpenseCategory.charityGift;
      case 'education':
        return ExpenseCategory.education;
      case 'vehicle':
        return ExpenseCategory.vehicle;
      default:
        return ExpenseCategory.unknown; // Handle unknown categories
    }
  }

  static List<ExpenseCategory> getAllCategories() {
    return ExpenseCategory.values
        .where((category) => category != ExpenseCategory.unknown)
        .toList();
  }

  static List<String> getAllCategoriesAsString() {
    return ExpenseCategory.values
        .where((category) => category != ExpenseCategory.unknown)
        .map((category) => category.displayName)
        .toList();
  }
}
