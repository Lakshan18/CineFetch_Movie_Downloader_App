import 'package:flutter/material.dart';

class CustomActionMessage {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String yesText = "Yes",
    String noText = "No",
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(noText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(yesText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}