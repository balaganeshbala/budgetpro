import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';

class AppNameBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Budget',
            style: TextStyle(
              fontFamily: "Sora",
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          TextSpan(
            text: 'Pro',
            style: TextStyle(
              fontFamily: "Sora",
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
