import 'package:flutter/material.dart';

enum MajorExpenseCategory {
  vehicle,
  homeRenovation,
  medical,
  education,
  appliances,
  electronics,
  furniture,
  event,
  travel,
  legal,
  disasterRecovery,
  relocation,
  family,
  gift,
  taxes,
  debtSettlement,
  other
}

extension MajorExpenseCategoryExtension on MajorExpenseCategory {
  String get displayName {
    switch (this) {
      case MajorExpenseCategory.vehicle:
        return 'Vehicle';
      case MajorExpenseCategory.homeRenovation:
        return 'Home Renovation';
      case MajorExpenseCategory.medical:
        return 'Medical';
      case MajorExpenseCategory.education:
        return 'Education';
      case MajorExpenseCategory.appliances:
        return 'Appliances';
      case MajorExpenseCategory.electronics:
        return 'Electronics';
      case MajorExpenseCategory.furniture:
        return 'Furniture';
      case MajorExpenseCategory.event:
        return 'Event';
      case MajorExpenseCategory.travel:
        return 'Travel';
      case MajorExpenseCategory.legal:
        return 'Legal';
      case MajorExpenseCategory.disasterRecovery:
        return 'Disaster Recovery';
      case MajorExpenseCategory.relocation:
        return 'Relocation';
      case MajorExpenseCategory.family:
        return 'Family';
      case MajorExpenseCategory.gift:
        return 'Gift';
      case MajorExpenseCategory.taxes:
        return 'Taxes';
      case MajorExpenseCategory.debtSettlement:
        return 'Debt Settlement';
      case MajorExpenseCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case MajorExpenseCategory.vehicle:
        return Icons.directions_car;
      case MajorExpenseCategory.homeRenovation:
        return Icons.home_repair_service;
      case MajorExpenseCategory.medical:
        return Icons.medical_services;
      case MajorExpenseCategory.education:
        return Icons.school;
      case MajorExpenseCategory.appliances:
        return Icons.kitchen;
      case MajorExpenseCategory.electronics:
        return Icons.devices;
      case MajorExpenseCategory.furniture:
        return Icons.chair;
      case MajorExpenseCategory.event:
        return Icons.celebration;
      case MajorExpenseCategory.travel:
        return Icons.flight;
      case MajorExpenseCategory.legal:
        return Icons.gavel;
      case MajorExpenseCategory.disasterRecovery:
        return Icons.warning;
      case MajorExpenseCategory.relocation:
        return Icons.moving;
      case MajorExpenseCategory.family:
        return Icons.family_restroom;
      case MajorExpenseCategory.gift:
        return Icons.card_giftcard;
      case MajorExpenseCategory.taxes:
        return Icons.receipt_long;
      case MajorExpenseCategory.debtSettlement:
        return Icons.money_off;
      case MajorExpenseCategory.other:
        return Icons.category;
    }
  }

  Color get color {
    switch (this) {
      case MajorExpenseCategory.vehicle:
        return Colors.blueAccent;
      case MajorExpenseCategory.homeRenovation:
        return Colors.brown;
      case MajorExpenseCategory.medical:
        return Colors.red;
      case MajorExpenseCategory.education:
        return Colors.amber;
      case MajorExpenseCategory.appliances:
        return Colors.teal;
      case MajorExpenseCategory.electronics:
        return Colors.deepPurple;
      case MajorExpenseCategory.furniture:
        return Colors.orange;
      case MajorExpenseCategory.event:
        return Colors.pink;
      case MajorExpenseCategory.travel:
        return Colors.lightBlue;
      case MajorExpenseCategory.legal:
        return Colors.indigo;
      case MajorExpenseCategory.disasterRecovery:
        return Colors.red.shade800;
      case MajorExpenseCategory.relocation:
        return Colors.deepOrange;
      case MajorExpenseCategory.family:
        return Colors.green;
      case MajorExpenseCategory.gift:
        return Colors.purple;
      case MajorExpenseCategory.taxes:
        return Colors.grey.shade800;
      case MajorExpenseCategory.debtSettlement:
        return Colors.lime;
      case MajorExpenseCategory.other:
        return Colors.blueGrey;
    }
  }

  static MajorExpenseCategory fromString(String category) {
    switch (category) {
      case 'vehicle':
        return MajorExpenseCategory.vehicle;
      case 'homeRenovation':
        return MajorExpenseCategory.homeRenovation;
      case 'medical':
        return MajorExpenseCategory.medical;
      case 'education':
        return MajorExpenseCategory.education;
      case 'appliances':
        return MajorExpenseCategory.appliances;
      case 'electronics':
        return MajorExpenseCategory.electronics;
      case 'furniture':
        return MajorExpenseCategory.furniture;
      case 'event':
        return MajorExpenseCategory.event;
      case 'travel':
        return MajorExpenseCategory.travel;
      case 'legal':
        return MajorExpenseCategory.legal;
      case 'disasterRecovery':
        return MajorExpenseCategory.disasterRecovery;
      case 'relocation':
        return MajorExpenseCategory.relocation;
      case 'family':
        return MajorExpenseCategory.family;
      case 'gift':
        return MajorExpenseCategory.gift;
      case 'taxes':
        return MajorExpenseCategory.taxes;
      case 'debtSettlement':
        return MajorExpenseCategory.debtSettlement;
      default:
        return MajorExpenseCategory.other;
    }
  }

  static List<MajorExpenseCategory> getAllCategories() {
    return MajorExpenseCategory.values.toList();
  }

  static List<String> getAllCategoriesAsString() {
    return MajorExpenseCategory.values
        .map((category) => category.displayName)
        .toList();
  }
}
