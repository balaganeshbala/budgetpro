import 'package:budgetpro/components/app_theme_button.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BudgetInputField extends StatelessWidget {
  final ExpenseCategory category;
  final TextEditingController controller;

  const BudgetInputField({
    Key? key,
    required this.category,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                category.icon,
                size: 20,
                color: category.color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category.displayName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Sora",
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  isDense: true,
                  prefixText: '₹ ',
                  hintText: '0',
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Sora",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetTotalCard extends StatelessWidget {
  final double totalBudget;

  const BudgetTotalCard({
    Key? key,
    required this.totalBudget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Budget',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Sora",
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                Utils.formatRupees(totalBudget),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Sora",
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.pie_chart,
              size: 24,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetFormButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final bool isLoading;
  final String submitText;

  const BudgetFormButtons({
    Key? key,
    required this.onCancel,
    required this.onSubmit,
    required this.isLoading,
    required this.submitText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: AppThemeButton(
              onPressed: onCancel,
              text: 'Cancel',
              primary: false,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppThemeButton(
              text: isLoading ? 'Processing...' : submitText,
              onPressed: isLoading ? null : onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> showBudgetConfirmationDialog(
    BuildContext context, String title, String message) async {
  return await UIUtils.showConfirmationDialog(
    context,
    title,
    message,
  );
}
