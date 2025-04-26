import 'package:flutter/material.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';

class BudgetCardWidget extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final bool showEditButton;
  final VoidCallback? onEditTap;
  final VoidCallback? onMoreDetailsTap;

  const BudgetCardWidget({
    super.key,
    required this.totalBudget,
    required this.totalSpent,
    this.showEditButton = false,
    this.onEditTap,
    this.onMoreDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final remainingAmount = totalBudget - totalSpent;
    final spentPercentage =
        totalBudget > 0 ? (totalSpent / totalBudget) * 100 : 0;
    final isOverBudget = remainingAmount < 0;

    // Colors based on budget status
    final Color progressColor = isOverBudget
        ? AppColors.dangerColor
        : spentPercentage > 75
            ? Colors.orange
            : AppColors.primaryColor;

    final Color remainingTextColor =
        isOverBudget ? AppColors.dangerColor : AppColors.primaryColor;

    // Keep the original container with its shadow
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          )
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with monthly budget and edit button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Budget',
                        style: TextStyle(
                          fontFamily: "Sora",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Utils.formatRupees(totalBudget),
                        style: const TextStyle(
                          fontFamily: "Sora",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  if (showEditButton)
                    InkWell(
                      onTap: onEditTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit,
                              color: AppColors.accentColor,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Edit',
                              style: TextStyle(
                                fontFamily: "Sora",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Progress indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Spent: ${Utils.formatRupees(totalSpent)}',
                        style: const TextStyle(
                          fontFamily: "Sora",
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${spentPercentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontFamily: "Sora",
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: progressColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (spentPercentage / 100).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Remaining amount section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isOverBudget
                      ? AppColors.dangerColor.withOpacity(0.1)
                      : AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isOverBudget
                        ? AppColors.dangerColor.withOpacity(0.3)
                        : AppColors.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOverBudget ? 'Overspent' : 'Remaining',
                          style: TextStyle(
                            fontFamily: "Sora",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: remainingTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Utils.formatRupees(isOverBudget
                              ? remainingAmount.abs()
                              : remainingAmount),
                          style: TextStyle(
                            fontFamily: "Sora",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: remainingTextColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isOverBudget
                            ? AppColors.dangerColor.withOpacity(0.2)
                            : AppColors.primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isOverBudget
                            ? Icons.warning_amber_rounded
                            : Icons.payments_outlined,
                        color: remainingTextColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // New More Details button
              if (totalBudget > 0 && onMoreDetailsTap != null)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: onMoreDetailsTap,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Center(
                          child: Text(
                            'More Details',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Sora",
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
