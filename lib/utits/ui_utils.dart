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
}
