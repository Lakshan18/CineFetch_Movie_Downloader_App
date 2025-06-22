import 'dart:async';

import 'package:cinefetch_app/services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:cinefetch_app/components/custom_message.dart';
import 'package:cinefetch_app/components/custom_textfield.dart';
import 'package:cinefetch_app/routes/custom_page_route.dart';
import 'package:cinefetch_app/screens/email_verification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late StreamSubscription<bool> _connectionSubscription;
  bool _dialogShowing = false;

  final _emailController = TextEditingController();
  bool _isLoading = false;
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

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
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      CustomMessage.show(
        context: context,
        message: "Please enter your email",
        type: MessageType.error,
      );
      return;
    }

    if (!_emailRegex.hasMatch(email)) {
      CustomMessage.show(
        context: context,
        message: "Please enter a valid email address",
        type: MessageType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final query = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception("No account found with that email");
      }

      final userDoc = query.docs.first;
      final verificationCode = (100000 + Random().nextInt(900000)).toString();

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userDoc.id)
          .update({
            'verificationCode': verificationCode,
            'isPasswordReset': true,
            'verificationCreated': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          SlideFadePageRoute(
            page: EmailVerificationScreen(
              email: email,
              userId: userDoc.id,
              isPasswordReset: true,
            ),
          ),
        );
      }
    } catch (e) {
      CustomMessage.show(
        context: context,
        message: e.toString().replaceFirst('Exception: ', ''),
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
                  const SizedBox(height: 80),
                  Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: "Rosario",
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Enter your email to receive a verification code",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Quicksand",
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),

                  MyTextField(
                    controller: _emailController,
                    hinttext: "Your email address",
                    obsecuretext: false,
                    suffixIcon: false,
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendResetCode,
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
                              "SEND VERIFICATION CODE",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Back to login",
                        style: TextStyle(
                          color: Color(0xFF1A73E8),
                          fontFamily: "Quicksand",
                          fontSize: 14,
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
