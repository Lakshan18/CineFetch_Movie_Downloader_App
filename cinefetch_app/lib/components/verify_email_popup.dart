import 'package:flutter/material.dart';
import 'package:cinefetch_app/components/custom_message.dart';
import 'package:cinefetch_app/routes/custom_page_route.dart';
import 'package:cinefetch_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailPopup {
  static Future<void> show({
    required BuildContext context,
    required String email,
    required VoidCallback onResend,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF020912),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1A73E8), width: 1),
        ),
        title: const Text(
          "Verify Your Email",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Rosario",
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.mark_email_unread_outlined,
              size: 60,
              color: Color(0xFF1A73E8),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: "We've sent a verification email to ",
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: "Quicksand",
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please check your inbox and verify your email address to continue.",
              style: TextStyle(
                color: Colors.white70,
                fontFamily: "Quicksand",
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onResend();
            },
            child: const Text(
              "Resend Email",
              style: TextStyle(
                color: Color(0xFF1A73E8),
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A73E8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await Navigator.pushReplacement(
                context,
                SlideFadePageRoute(page: const LoginProcess()),
              );
            },
            child: const Text(
              "Continue to Login",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> resendVerificationEmail(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        CustomMessage.show(
          context: context,
          message: "Verification email resent successfully!",
          type: MessageType.success,
        );
      }
    } catch (e) {
      CustomMessage.show(
        context: context,
        message: "Failed to resend verification email: ${e.toString()}",
        type: MessageType.error,
      );
    }
  }
}