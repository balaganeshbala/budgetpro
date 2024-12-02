import 'package:budgetpro/pages/home/ui/amount_with_title_widget.dart';
import 'package:budgetpro/utits/colors.dart';
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

  String _formatRupees(double amount) {
    NumberFormat rupeeFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return rupeeFormat.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
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
                        Text(_formatRupees(remaining),
                            style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: remaining < 0
                                    ? AppColors.dangerColor
                                    : AppColors.primaryColor)),
                        Text(
                          remaining < 0 ? 'Overspent' : 'Remaining',
                          style: const TextStyle(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500),
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
