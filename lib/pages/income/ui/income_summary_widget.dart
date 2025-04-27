import 'package:flutter/material.dart';
import 'package:budgetpro/models/income_model.dart';
import 'package:budgetpro/models/income_category_enum.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';

class IncomeSummaryWidget extends StatelessWidget {
  final List<IncomeModel> incomes;

  const IncomeSummaryWidget({Key? key, required this.incomes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate total income
    double totalIncome = incomes.fold(0, (sum, income) => sum + income.amount);

    // Process incomes by category
    Map<IncomeCategory, double> categoryTotals = {};
    for (var income in incomes) {
      if (categoryTotals.containsKey(income.category)) {
        categoryTotals[income.category] =
            categoryTotals[income.category]! + income.amount;
      } else {
        categoryTotals[income.category] = income.amount;
      }
    }

    // Sort categories by amount (descending)
    List<MapEntry<IncomeCategory, double>> sortedCategories =
        categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total income section
          Text(
            'Total Income',
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Sora",
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Utils.formatRupees(totalIncome),
            style: const TextStyle(
              fontSize: 24,
              fontFamily: "Sora",
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 24),

          // Category breakdown header
          Text(
            'Income by Category',
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Sora",
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),

          // Category breakdown list
          if (incomes.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'No income data to display',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Sora",
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sortedCategories.length,
              itemBuilder: (context, index) {
                final category = sortedCategories[index].key;
                final amount = sortedCategories[index].value;
                final percent = (amount / totalIncome) * 100;

                return _buildCategoryItem(
                  category: category,
                  amount: amount,
                  percent: percent,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required IncomeCategory category,
    required double amount,
    required double percent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Category icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              category.icon,
              size: 18,
              color: category.color,
            ),
          ),
          const SizedBox(width: 12),

          // Category name
          Expanded(
            flex: 3,
            child: Text(
              category.displayName,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Sora",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Amount
          Expanded(
            flex: 3,
            child: Text(
              Utils.formatRupees(amount),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Sora",
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),

          // Percentage
          Expanded(
            flex: 2,
            child: Text(
              '${percent.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Sora",
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
