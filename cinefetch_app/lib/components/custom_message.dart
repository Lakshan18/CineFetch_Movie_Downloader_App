import 'package:flutter/material.dart';

enum MessageType { error, success, warning, info }

class CustomMessage {
  static void show({
    required BuildContext context,
    required String message,
    required MessageType type,
    int duration = 3,
  }) {
    final Color backgroundColor;
    final Color textColor;
    final IconData icon;

    switch (type) {
      case MessageType.error:
        backgroundColor = const Color(0xFFF44336);
        textColor = Colors.white;
        icon = Icons.error_outline;
        break;
      case MessageType.success:
        backgroundColor = const Color(0xFF4CAF50);
        textColor = Colors.white;
        icon = Icons.check_circle_outline;
        break;
      case MessageType.warning:
        backgroundColor = const Color(0xFFFF9800);
        textColor = Colors.black;
        icon = Icons.warning_amber_outlined;
        break;
      case MessageType.info:
        backgroundColor = const Color(0xFF2196F3);
        textColor = Colors.white;
        icon = Icons.info_outline;
        break;
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    scaffoldMessenger.hideCurrentSnackBar();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
        padding: EdgeInsets.zero,
        content: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: textColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: textColor,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: textColor, size: 20),
                  onPressed: () {
                    scaffoldMessenger.hideCurrentSnackBar();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}