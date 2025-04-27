import 'package:flutter/material.dart';

enum IncomeCategory {
  salary,
  investment,
  business,
  rental,
  sideHustle,
  service,
  gift,
  pension,
  interest,
  dividend,
  royalties,
  refund,
  benefits,
  other
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
      case IncomeCategory.service:
        return 'Service';
      case IncomeCategory.gift:
        return 'Gift';
      case IncomeCategory.pension:
        return 'Pension';
      case IncomeCategory.interest:
        return 'Interest';
      case IncomeCategory.dividend:
        return 'Dividend';
      case IncomeCategory.royalties:
        return 'Royalties';
      case IncomeCategory.refund:
        return 'Refund';
      case IncomeCategory.benefits:
        return 'Benefits';
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
      case IncomeCategory.service:
        return Icons.handyman;
      case IncomeCategory.gift:
        return Icons.card_giftcard;
      case IncomeCategory.pension:
        return Icons.account_balance;
      case IncomeCategory.interest:
        return Icons.account_balance_wallet;
      case IncomeCategory.dividend:
        return Icons.attach_money;
      case IncomeCategory.royalties:
        return Icons.music_note;
      case IncomeCategory.refund:
        return Icons.receipt_long;
      case IncomeCategory.benefits:
        return Icons.location_city;
      default:
        return Icons.post_add_rounded;
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
      case IncomeCategory.service:
        return Colors.lime;
      case IncomeCategory.gift:
        return Colors.amber;
      case IncomeCategory.pension:
        return Colors.indigo;
      case IncomeCategory.interest:
        return Colors.brown;
      case IncomeCategory.dividend:
        return Colors.cyan;
      case IncomeCategory.royalties:
        return Colors.deepPurple;
      case IncomeCategory.refund:
        return Colors.lightGreen;
      case IncomeCategory.benefits:
        return Colors.blueGrey;
      default:
        return Colors.black87;
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
      case 'service':
        return IncomeCategory.service;
      case 'gift':
        return IncomeCategory.gift;
      case 'pension':
        return IncomeCategory.pension;
      case 'interest':
        return IncomeCategory.interest;
      case 'dividend':
        return IncomeCategory.dividend;
      case 'royalties':
        return IncomeCategory.royalties;
      case 'refund':
        return IncomeCategory.refund;
      case 'benefits':
        return IncomeCategory.benefits;
      default:
        return IncomeCategory.other;
    }
  }

  static List<IncomeCategory> getAllCategories() {
    return IncomeCategory.values.toList();
  }

  static List<String> getAllCategoriesAsString() {
    return IncomeCategory.values
        .map((category) => category.displayName)
        .toList();
  }
}
