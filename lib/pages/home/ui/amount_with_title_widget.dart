import 'package:budgetpro/utits/ui_utils.dart';
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
        Text(UIUtils.formatRupees(amount),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 66, 143, 125))),
        Text(title)
      ]),
    );
  }
}
