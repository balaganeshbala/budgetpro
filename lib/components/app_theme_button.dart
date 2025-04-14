import 'package:flutter/material.dart';
import 'package:budgetpro/utits/colors.dart';

class AppThemeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool primary;

  const AppThemeButton({
    super.key,
    required this.text,
    this.onPressed,
    this.primary = true,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = primary ? AppColors.accentColor : Colors.white;
    Color foregroundColor = primary ? Colors.white : AppColors.accentColor;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: onPressed != null ? 1 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: primary == false
              ? BorderSide(color: foregroundColor)
              : BorderSide.none,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: "Sora",
            color: foregroundColor),
      ),
    );
  }
}
