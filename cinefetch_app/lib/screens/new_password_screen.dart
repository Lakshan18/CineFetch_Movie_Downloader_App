import 'dart:async';

import 'package:cinefetch_app/services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:cinefetch_app/components/custom_message.dart';
import 'package:cinefetch_app/components/custom_textfield.dart';
import 'package:cinefetch_app/routes/custom_page_route.dart';
import 'package:cinefetch_app/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class NewPasswordScreen extends StatefulWidget {
  final String userId;
  final String email;

  const NewPasswordScreen({
    super.key,
    required this.userId,
    required this.email,
  });

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  late StreamSubscription<bool> _connectionSubscription;
  bool _dialogShowing = false;

  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  final _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~_.,;:]).{5,10}$',
  );

  String _hashPassword(String plainText) {
    return sha256.convert(utf8.encode(plainText)).toString();
  }

  @override
  void initState() {
    super.initState();
    final networkService = Provider.of<NetworkService>(context, listen: false);

    _connectionSubscription = networkService.connectionChanges.listen((
      isConnected,
    ) {
      if (isConnected) {
        if (_dialogShowing) {
          Navigator.of(context).pop();
          _dialogShowing = false;
        }
      } else {
        _handleNoConnection(networkService);
      }
    });

    if (!networkService.isConnected) {
      _handleNoConnection(networkService);
    }
  }

  void _handleNoConnection(NetworkService networkService) {
    if (!_dialogShowing) {
      _dialogShowing = true;
      networkService.showNoInternetDialog(context).then((_) {
        _dialogShowing = false;
      });
    }
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      CustomMessage.show(
        context: context,
        message: "Please enter and confirm your new password",
        type: MessageType.error,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      CustomMessage.show(
        context: context,
        message: "Passwords don't match",
        type: MessageType.error,
      );
      return;
    }

    if (!_passwordRegex.hasMatch(newPassword)) {
      CustomMessage.show(
        context: context,
        message:
            "Password must be 5-10 chars with uppercase, lowercase, number and symbol",
        type: MessageType.warning,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final hashedPassword = _hashPassword(newPassword);

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.userId)
          .update({
            'password': hashedPassword,
            'isPasswordReset': FieldValue.delete(),
          });

      // Update Firebase Auth if email/password user exists
      try {
        final authUser = FirebaseAuth.instance.currentUser;
        if (authUser != null && authUser.email == widget.email) {
          await authUser.updatePassword(newPassword);
        }
      } catch (e) {
        // Continue even if Firebase Auth update fails
      }

      CustomMessage.show(
        context: context,
        message: "Password updated successfully!",
        type: MessageType.success,
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          SlideFadePageRoute(page: const LoginProcess()),
          (route) => false,
        );
      }
    } catch (e) {
      CustomMessage.show(
        context: context,
        message: "Failed to update password: ${e.toString()}",
        type: MessageType.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020912),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.09,
              child: Image.asset(
                "assets/page_background.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/logo/cine_fetch_logo_tr.png",
                        width: 100,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "Create New Password",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: "Rosario",
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Your new password must be different from previous ones",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Quicksand",
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // New Password Field
                  MyTextField(
                    controller: _newPasswordController,
                    hinttext: "New Password",
                    obsecuretext: _obscureNewPassword,
                    suffixIcon: true,
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password Field
                  MyTextField(
                    controller: _confirmPasswordController,
                    hinttext: "Confirm Password",
                    obsecuretext: _obscureConfirmPassword,
                    suffixIcon: true,
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A73E8),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              "UPDATE PASSWORD",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
