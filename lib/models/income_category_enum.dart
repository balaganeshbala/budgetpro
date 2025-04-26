import 'package:flutter/material.dart';

enum IncomeCategory {
  salary,
  investment,
  business,
  rental,
  sideHustle,
  freelance,
  gift,
  pension,
  interest,
  dividend,
  other,
  unknown,
}

extension IncomeCategoryExtension on IncomeCategory {
  String get displayName {
    switch (this) {
      case IncomeCategory.salary:
        return 'Salary';
      case IncomeCategory.investment:
        return 'Investment';
      case IncomeCategory.business:
        return 'Business';
      case IncomeCategory.rental:
        return 'Rental';
      case IncomeCategory.sideHustle:
        return 'Side Hustle';
      case IncomeCategory.freelance:
        return 'Freelance';
      case IncomeCategory.gift:
        return 'Gift';
      case IncomeCategory.pension:
        return 'Pension';
      case IncomeCategory.interest:
        return 'Interest';
      case IncomeCategory.dividend:
        return 'Dividend';
      default:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case IncomeCategory.salary:
        return Icons.monetization_on;
      case IncomeCategory.investment:
        return Icons.pie_chart;
      case IncomeCategory.business:
        return Icons.business_center;
      case IncomeCategory.rental:
        return Icons.home_work;
      case IncomeCategory.sideHustle:
        return Icons.work_outline;
      case IncomeCategory.freelance:
        return Icons.work;
      case IncomeCategory.gift:
        return Icons.card_giftcard;
      case IncomeCategory.pension:
        return Icons.account_balance;
      case IncomeCategory.interest:
        return Icons.money_off;
      case IncomeCategory.dividend:
        return Icons.attach_money;
      default:
        return Icons.note_outlined;
    }
  }

  Color get color {
    switch (this) {
      case IncomeCategory.salary:
        return Colors.green;
      case IncomeCategory.investment:
        return Colors.blue;
      case IncomeCategory.business:
        return Colors.orange;
      case IncomeCategory.rental:
        return Colors.purple;
      case IncomeCategory.sideHustle:
        return Colors.red;
      case IncomeCategory.freelance:
        return Colors.teal;
      case IncomeCategory.gift:
        return Colors.amber;
      case IncomeCategory.pension:
        return Colors.indigo;
      case IncomeCategory.interest:
        return Colors.brown;
      case IncomeCategory.dividend:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  static IncomeCategory fromString(String category) {
    switch (category) {
      case 'salary':
        return IncomeCategory.salary;
      case 'investment':
        return IncomeCategory.investment;
      case 'business':
        return IncomeCategory.business;
      case 'rental':
        return IncomeCategory.rental;
      case 'sideHustle':
        return IncomeCategory.sideHustle;
      case 'freelance':
        return IncomeCategory.freelance;
      case 'gift':
        return IncomeCategory.gift;
      case 'pension':
        return IncomeCategory.pension;
      case 'interest':
        return IncomeCategory.interest;
      case 'dividend':
        return IncomeCategory.dividend;
      default:
        return IncomeCategory.unknown; // Handle unknown categories
    }
  }

  static List<IncomeCategory> getAllCategories() {
    return IncomeCategory.values
        .where((category) => category != IncomeCategory.unknown)
        .toList();
  }

  static List<String> getAllCategoriesAsString() {
    return IncomeCategory.values
        .where((category) => category != IncomeCategory.unknown)
        .map((category) => category.displayName)
        .toList();
  }
}
