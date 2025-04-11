import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';

class AmountWithTitleWidget extends StatelessWidget {
  final double amount;
  final String title;

  const AmountWithTitleWidget({
    super.key,
    required this.amount,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(Utils.formatRupees(amount),
            style: const TextStyle(
                fontFamily: "Sora",
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor)),
        Text(
          title,
          style:
              const TextStyle(fontFamily: "Sora", fontWeight: FontWeight.w500),
        )
      ]),
    );
  }
}
