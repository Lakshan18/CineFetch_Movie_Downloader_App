// import 'dart:async';
// import 'dart:math';
// import 'package:cinefetch_app/screens/create_profile.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:cinefetch_app/components/custom_message.dart';
// import 'package:cinefetch_app/routes/custom_page_route.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class EmailVerificationScreen extends StatefulWidget {
//   final String email;
//   final String userId;

//   const EmailVerificationScreen({
//     super.key,
//     required this.email,
//     required this.userId,
//   });

//   @override
//   State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
// }

// class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
//   final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
//   final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
//   bool _isVerifying = false;
//   bool _isResending = false;
//   int _resendTimer = 30;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startResendTimer();
//     _focusNodes[0].requestFocus(); // Auto-focus first field
//   }

//   @override
//   void dispose() {
//     for (var c in _controllers) c.dispose();
//     for (var f in _focusNodes) f.dispose();
//     _timer.cancel();
//     super.dispose();
//   }

//   void _startResendTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_resendTimer > 0) {
//         setState(() => _resendTimer--);
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   void _handleInput(String value, int index) {
//     if (value.isNotEmpty) {
//       _controllers[index].text = value[value.length - 1]; // Take last character
//       if (index < 5) {
//         _focusNodes[index].unfocus();
//         _focusNodes[index + 1].requestFocus();
//       }
//     } else if (value.isEmpty && index > 0) {
//       _focusNodes[index].unfocus();
//       _focusNodes[index - 1].requestFocus();
//     }
//   }

//   Future<void> _verifyCode() async {
//     final code = _controllers.map((c) => c.text).join();
    
//     if (code.length != 6) {
//       CustomMessage.show(
//         context: context,
//         message: "Please enter a valid 6-digit code",
//         type: MessageType.error,
//       );
//       return;
//     }

//     setState(() => _isVerifying = true);

//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('user')
//           .doc(widget.userId)
//           .get();

//       if (doc.data()?['verificationCode'] == code) {
//         await FirebaseFirestore.instance
//             .collection('user')
//             .doc(widget.userId)
//             .update({
//               'emailVerified': true,
//               'verificationCode': FieldValue.delete(),
//             });

//         await FirebaseAuth.instance.currentUser?.reload();

//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             SlideFadePageRoute(page: const CreateProfileProcess()),
//           );
//         }
//       } else {
//         CustomMessage.show(
//           context: context,
//           message: "Invalid verification code",
//           type: MessageType.error,
//         );
//       }
//     } catch (e) {
//       CustomMessage.show(
//         context: context,
//         message: "Verification failed: ${e.toString()}",
//         type: MessageType.error,
//       );
//     } finally {
//       if (mounted) setState(() => _isVerifying = false);
//     }
//   }

//   Future<void> _resendCode() async {
//     setState(() {
//       _isResending = true;
//       _resendTimer = 30;
//     });

//     try {
//       final newCode = (100000 + Random().nextInt(900000)).toString();
//       await FirebaseFirestore.instance
//           .collection('user')
//           .doc(widget.userId)
//           .update({'verificationCode': newCode});

//       CustomMessage.show(
//         context: context,
//         message: "New verification code sent!",
//         type: MessageType.success,
//       );
//     } catch (e) {
//       CustomMessage.show(
//         context: context,
//         message: "Failed to resend code: ${e.toString()}",
//         type: MessageType.error,
//       );
//     } finally {
//       if (mounted) setState(() => _isResending = false);
//       _startResendTimer();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF020912),
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.09,
//               child: Image.asset(
//                 "assets/page_background.png",
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 30),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Image.asset(
//                         "assets/logo/cine_fetch_logo_tr.png",
//                         width: 100,
//                         height: 70,
//                         fit: BoxFit.contain,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 80),
//                   Text(
//                     "Verify Your Email",
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontFamily: "Rosario",
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   Text(
//                     "We sent a 6-digit code to ${widget.email}",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontFamily: "Quicksand",
//                       color: Colors.white70,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
                  
//                   // 6-Digit Code Input
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: List.generate(6, (index) {
//                       return SizedBox(
//                         width: 50,
//                         height: 60,
//                         child: TextField(
//                           controller: _controllers[index],
//                           focusNode: _focusNodes[index],
//                           textAlign: TextAlign.center,
//                           keyboardType: TextInputType.number,
//                           maxLength: 1,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             color: Colors.white,
//                             fontFamily: "Quicksand",
//                             fontWeight: FontWeight.w600,
//                           ),
//                           decoration: InputDecoration(
//                             counterText: '',
//                             filled: true,
//                             fillColor: Colors.white.withOpacity(0.1),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide.none,
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                 color: Colors.white.withOpacity(0.3),
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFF1A73E8),
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                           onChanged: (value) => _handleInput(value, index),
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
                  
//                   const SizedBox(height: 40),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _isVerifying ? null : _verifyCode,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF1A73E8),
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: _isVerifying
//                           ? const CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation(Colors.white),
//                             )
//                           : const Text(
//                               "VERIFY",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.white,
//                                 fontFamily: "Quicksand",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Center(
//                     child: TextButton(
//                       onPressed: _resendTimer > 0 || _isResending
//                           ? null
//                           : _resendCode,
//                       child: Text(
//                         _resendTimer > 0
//                             ? "Resend code in $_resendTimer seconds"
//                             : "Resend verification code",
//                         style: TextStyle(
//                           color: _resendTimer > 0
//                               ? Colors.white54
//                               : const Color(0xFF1A73E8),
//                           fontFamily: "Quicksand",
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'dart:async';
import 'dart:math';
import 'package:cinefetch_app/screens/create_profile.dart';
import 'package:cinefetch_app/screens/new_password_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cinefetch_app/components/custom_message.dart';
import 'package:cinefetch_app/routes/custom_page_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String userId;
  final bool isPasswordReset;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.userId,
    this.isPasswordReset = false,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;
  bool _isResending = false;
  int _resendTimer = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  void _handleInput(String value, int index) {
    if (value.isNotEmpty) {
      _controllers[index].text = value[value.length - 1];
      if (index < 5) {
        _focusNodes[index].unfocus();
        _focusNodes[index + 1].requestFocus();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index].unfocus();
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyCode() async {
    final code = _controllers.map((c) => c.text).join();
    
    if (code.length != 6) {
      CustomMessage.show(
        context: context,
        message: "Please enter a valid 6-digit code",
        type: MessageType.error,
      );
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final doc = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.userId)
          .get();

      if (doc.data()?['verificationCode'] == code) {
        // Clear verification code
        await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.userId)
            .update({
              'verificationCode': FieldValue.delete(),
              if (!widget.isPasswordReset) 'emailVerified': true,
            });

        if (widget.isPasswordReset) {
          // Navigate to password reset screen
          if (mounted) {
            Navigator.pushReplacement(
              context,
              SlideFadePageRoute(
                page: NewPasswordScreen(
                  userId: widget.userId,
                  email: widget.email,
                ),
              ),
            );
          }
        } else {
          // Original registration flow
          await FirebaseAuth.instance.currentUser?.reload();
          if (mounted) {
            Navigator.pushReplacement(
              context,
              SlideFadePageRoute(page: const CreateProfileProcess()),
            );
          }
        }
      } else {
        CustomMessage.show(
          context: context,
          message: "Invalid verification code",
          type: MessageType.error,
        );
      }
    } catch (e) {
      CustomMessage.show(
        context: context,
        message: "Verification failed: ${e.toString()}",
        type: MessageType.error,
      );
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      _isResending = true;
      _resendTimer = 30;
    });

    try {
      final newCode = (100000 + Random().nextInt(900000)).toString();
      await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.userId)
          .update({'verificationCode': newCode});

      CustomMessage.show(
        context: context,
        message: "New verification code sent!",
        type: MessageType.success,
      );
    } catch (e) {
      CustomMessage.show(
        context: context,
        message: "Failed to resend code: ${e.toString()}",
        type: MessageType.error,
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
      _startResendTimer();
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
                    widget.isPasswordReset 
                        ? "Verify Your Identity" 
                        : "Verify Your Email",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: "Rosario",
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.isPasswordReset
                        ? "We sent a 6-digit code to ${widget.email} to verify your identity"
                        : "We sent a 6-digit code to ${widget.email}",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Quicksand",
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // 6-Digit Code Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50,
                        height: 60,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF1A73E8),
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) => _handleInput(value, index),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      );
                    }),
                  ),
                  
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isVerifying ? null : _verifyCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A73E8),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isVerifying
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : Text(
                              widget.isPasswordReset ? "VERIFY IDENTITY" : "VERIFY EMAIL",
                              style: const TextStyle(
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
                      onPressed: _resendTimer > 0 || _isResending
                          ? null
                          : _resendCode,
                      child: Text(
                        _resendTimer > 0
                            ? "Resend code in $_resendTimer seconds"
                            : "Resend verification code",
                        style: TextStyle(
                          color: _resendTimer > 0
                              ? Colors.white54
                              : const Color(0xFF1A73E8),
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