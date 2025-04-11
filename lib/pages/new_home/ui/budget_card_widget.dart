import 'package:budgetpro/pages/new_home/ui/amount_with_title_widget.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetCardWidget extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final double remaining;

  const BudgetCardWidget(
      {super.key,
      required this.totalBudget,
      required this.totalSpent,
      required this.remaining});

  @override
  Widget build(BuildContext context) {
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
                        Text(Utils.formatRupees(remaining),
                            style: TextStyle(
                                fontFamily: "Sora",
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: remaining < 0
                                    ? AppColors.dangerColor
                                    : AppColors.primaryColor)),
                        Text(
                          remaining < 0 ? 'Overspent' : 'Remaining',
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
                  )
                ]),
          ),
        ));
  }
}
