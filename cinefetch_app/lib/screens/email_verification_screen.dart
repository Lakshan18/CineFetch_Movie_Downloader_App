// import 'dart:async';

// import 'package:cinefetch_app/screens/create_profile.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:cinefetch_app/components/custom_message.dart';
// import 'package:cinefetch_app/components/custom_pin_textfield.dart';
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
//   State<EmailVerificationScreen> createState() =>
//       _EmailVerificationScreenState();
// }

// class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
//   final _verificationCodeController = TextEditingController();
//   bool _isVerifying = false;
//   bool _isResending = false;
//   int _resendTimer = 30;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startResendTimer();
//   }

//   @override
//   void dispose() {
//     _verificationCodeController.dispose();
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

//   Future<void> _verifyEmail() async {
//     if (_verificationCodeController.text.length != 6) {
//       CustomMessage.show(
//         context: context,
//         message: "Please enter a valid 6-digit code",
//         type: MessageType.error,
//       );
//       return;
//     }

//     setState(() => _isVerifying = true);

//     try {
//       // Get the stored code from Firestore
//       final doc = await FirebaseFirestore.instance
//           .collection('user')
//           .doc(widget.userId)
//           .get();

//       final storedCode = doc.data()?['verificationCode'] ?? '';
//       final enteredCode = _verificationCodeController.text.trim();

//       if (storedCode == enteredCode) {
//         // Mark as verified
//         await FirebaseFirestore.instance
//             .collection('user')
//             .doc(widget.userId)
//             .update({
//               'emailVerified': true,
//               'verificationCode': FieldValue.delete(), // Remove the code
//             });

//         // Optional: Verify with Firebase Auth too
//         await FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(
//           widget.email,
//         );

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
//       if (mounted) {
//         setState(() => _isVerifying = false);
//       }
//     }
//   }

//   // Future<void> _verifyEmail() async {
//   //   if (_verificationCodeController.text.length != 6) {
//   //     CustomMessage.show(
//   //       context: context,
//   //       message: "Please enter a valid 6-digit code",
//   //       type: MessageType.error,
//   //     );
//   //     return;
//   //   }

//   //   setState(() => _isVerifying = true);

//   //   try {
//   //     // In a real app, you would verify the code with your backend
//   //     // For Firebase Email Link verification, we check if email is verified
//   //     final user = FirebaseAuth.instance.currentUser;

//   //     if (user != null && user.emailVerified) {
//   //       // Update Firestore that email is verified
//   //       await FirebaseFirestore.instance
//   //           .collection('user')
//   //           .doc(widget.userId)
//   //           .update({'emailVerified': true});

//   //       if (mounted) {
//   //         Navigator.pushReplacement(
//   //           context,
//   //           SlideFadePageRoute(page: const CreateProfileProcess()),
//   //         );
//   //       }
//   //     } else {
//   //       CustomMessage.show(
//   //         context: context,
//   //         message: "Email not verified yet. Please check your inbox.",
//   //         type: MessageType.error,
//   //       );
//   //     }
//   //   } catch (e) {
//   //     CustomMessage.show(
//   //       context: context,
//   //       message: "Verification failed: ${e.toString()}",
//   //       type: MessageType.error,
//   //     );
//   //   } finally {
//   //     if (mounted) {
//   //       setState(() => _isVerifying = false);
//   //     }
//   //   }
//   // }

//   Future<void> _resendVerificationCode() async {
//     setState(() {
//       _isResending = true;
//       _resendTimer = 30;
//     });

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await user.sendEmailVerification();
//         CustomMessage.show(
//           context: context,
//           message: "Verification email resent!",
//           type: MessageType.success,
//         );
//         _startResendTimer();
//       }
//     } catch (e) {
//       CustomMessage.show(
//         context: context,
//         message: "Failed to resend: ${e.toString()}",
//         type: MessageType.error,
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isResending = false);
//       }
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
//                   const SizedBox(height: 40),
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
//                   Center(
//                     child: MyPinTextField(
//                       textfieldinfo: "",
//                       controller: _verificationCodeController,
//                       hinttext: "Enter 6-digit code",
//                       obsecuretext: false,
//                       suffixIcon: false,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _isVerifying ? null : _verifyEmail,
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
//                           : _resendVerificationCode,
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cinefetch_app/components/custom_message.dart';
import 'package:cinefetch_app/components/custom_pin_textfield.dart';
import 'package:cinefetch_app/routes/custom_page_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String userId;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.userId,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _verificationCodeController = TextEditingController();
  bool _isVerifying = false;
  bool _isResending = false;
  int _resendTimer = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _verificationCodeController.dispose();
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

  Future<void> _verifyCode() async {
    if (_verificationCodeController.text.length != 6) {
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
          .collection('users')
          .doc(widget.userId)
          .get();

      final storedCode = doc.data()?['verificationCode'] ?? '';
      final enteredCode = _verificationCodeController.text.trim();

      if (storedCode == enteredCode) {
        // Mark as verified
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({
              'emailVerified': true,
              'verificationCode': FieldValue.delete(),
            });

        // Verify with Firebase Auth
        await FirebaseAuth.instance.currentUser?.reload();
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            SlideFadePageRoute(page: const CreateProfileProcess()),
          );
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
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  Future<void> _resendVerificationCode() async {
    setState(() {
      _isResending = true;
      _resendTimer = 30;
    });

    try {
      final newCode = (100000 + Random().nextInt(900000)).toString();
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
            'verificationCode': newCode,
          });

      CustomMessage.show(
        context: context,
        message: "New verification code sent!",
        type: MessageType.success,
      );
      _startResendTimer();
    } catch (e) {
      CustomMessage.show(
        context: context,
        message: "Failed to resend code: ${e.toString()}",
        type: MessageType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
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
                  const SizedBox(height: 40),
                  Text(
                    "Verify Your Email",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: "Rosario",
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "We sent a 6-digit code to ${widget.email}",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Quicksand",
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: MyPinTextField(
                      textfieldinfo: "",
                      controller: _verificationCodeController,
                      hinttext: "Enter 6-digit code",
                      obsecuretext: false,
                      suffixIcon: false,
                    ),
                  ),
                  const SizedBox(height: 30),
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
                          : const Text(
                              "VERIFY",
                              style: TextStyle(
                                fontSize: 18,
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
                          : _resendVerificationCode,
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