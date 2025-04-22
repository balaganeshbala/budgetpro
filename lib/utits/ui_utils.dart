import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum SnackbarType { info, success, error, warning }

class UIUtils {
  static void showSnackbar(BuildContext context, String message,
      {SnackbarType type = SnackbarType.info}) {
    Color backgroundColor;
    IconData iconData;

    switch (type) {
      case SnackbarType.info:
        backgroundColor = Colors.blue;
        iconData = Icons.info;
        break;
      case SnackbarType.success:
        backgroundColor = Colors.green;
        iconData = Icons.check_circle;
        break;
      case SnackbarType.error:
        backgroundColor = Colors.red;
        iconData = Icons.error;
        break;
      case SnackbarType.warning:
        backgroundColor = Colors.amber;
        iconData = Icons.warning;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(iconData, color: Colors.white),
            const SizedBox(width: 8),
            Text(message,
                style: const TextStyle(
                    fontFamily: "Sora",
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  static Future<bool> showConfirmationDialog(
      BuildContext context, String title, String message) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: const TextStyle(
              fontFamily: "Sora", fontSize: 22, color: AppColors.primaryColor),
          contentTextStyle: TextStyle(
              fontFamily: "Sora", fontSize: 16, color: Colors.grey.shade700),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                "No",
                style: TextStyle(
                  color: AppColors.accentColor,
                  fontFamily: "Sora", // Add the "Sora" font
                  fontWeight: FontWeight.w500, // Optional: Adjust weight
                  fontSize: 16, // Optional: Adjust size
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: AppColors.accentColor,
                  fontFamily: "Sora", // Add the "Sora" font
                  fontWeight: FontWeight.w500, // Optional: Adjust weight
                  fontSize: 16, // Optional: Adjust size
                ),
              ),
            ),
          ],
        );
      },
    );

    return confirm ?? false;
  }
}
