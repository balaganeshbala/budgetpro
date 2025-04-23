import 'package:budgetpro/components/amount_with_title_widget.dart';
import 'package:budgetpro/pages/create_budget/ui/create_budget_screen.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_bloc.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_event.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BudgetCardWidget extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  bool? showEditButton;
  VoidCallback? onEditTap;

  BudgetCardWidget(
      {super.key,
      required this.totalBudget,
      required this.totalSpent,
      this.showEditButton = false,
      this.onEditTap});

  @override
  Widget build(BuildContext context) {
    final remainingAmount = totalBudget - totalSpent;
    final spentPercentage =
        totalBudget > 0 ? (totalSpent / totalBudget) * 100 : 0;

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
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(Utils.formatRupees(remainingAmount),
                            style: TextStyle(
                                fontFamily: "Sora",
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: remainingAmount < 0
                                    ? AppColors.dangerColor
                                    : AppColors.primaryColor)),
                        Text(
                          remainingAmount < 0 ? 'Overspent' : 'Remaining',
                          style: const TextStyle(
                              fontFamily: "Sora", fontWeight: FontWeight.w500),
                        )
                      ]),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      AmountWithTitleWidget(
                          amount: totalBudget, title: 'Allocated'),
                      const SizedBox(width: 20),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.black12,
                      ),
                      const SizedBox(width: 20),
                      AmountWithTitleWidget(amount: totalSpent, title: 'Spent'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: spentPercentage / 100,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        spentPercentage > 100
                            ? AppColors.dangerColor
                            : spentPercentage > 75
                                ? Colors.orange
                                : AppColors.primaryColor,
                      ),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${spentPercentage.toStringAsFixed(1)}% spent',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.9),
                          fontFamily: "Sora",
                        ),
                      ),
                      Text(
                        remainingAmount < 0
                            ? 'Over budget!'
                            : '${(100 - spentPercentage).toStringAsFixed(1)}% remaining',
                        style: TextStyle(
                          fontSize: 12,
                          color: remainingAmount < 0
                              ? AppColors.dangerColor
                              : AppColors.primaryColor,
                          fontWeight: remainingAmount < 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontFamily: "Sora",
                        ),
                      ),
                    ],
                  ),
                  if (showEditButton == true)
                    InkWell(
                      onTap: onEditTap,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min, // To wrap content tightly
                            children: [
                              Icon(
                                Icons.edit, // Or any other edit-related icon
                                color: AppColors.accentColor,
                                size: 16, // Adjust size as needed
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some spacing between the icon and text
                              Text(
                                'Edit Budget',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Sora",
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ]),
          ),
        ));
  }
}
