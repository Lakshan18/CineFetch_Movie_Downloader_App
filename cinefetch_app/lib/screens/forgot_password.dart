// import 'package:cinefetch_app/components/custom_message.dart';
// import 'package:cinefetch_app/components/custom_textfield.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final _emailController = TextEditingController();
//   final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

//   Future<void> _verifyEmailProcess() async {
//     if (_emailController.text.isEmpty) {
//       CustomMessage.show(
//         context: context,
//         message: "Please enter your email!",
//         type: MessageType.error,
//       );
//       return;
//     }

//     if (!emailRegex.hasMatch(_emailController.text)) {
//       CustomMessage.show(
//         context: context,
//         message: "Please enter valid email!",
//         type: MessageType.error,
//       );
//       return;
//     }

//     try {
//       final query = await FirebaseFirestore.instance
//           .collection("user")
//           .where("email", isEqualTo: _emailController.text)
//           .limit(1)
//           .get();

//       if (query.docs.isEmpty) {
//         CustomMessage.show(
//           context: context,
//           message: "No user found with this email address!",
//           type: MessageType.error,
//         );
//       }


//     } catch (e) {
//       CustomMessage.show(
//         context: context,
//         message:
//             "Invalid user, if you are not registered, please register first! $e",
//         type: MessageType.error,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF020912),
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

//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         "assets/logo/cine_fetch_logo_tr.png",
//                         width: 100,
//                         height: 70,
//                         fit: BoxFit.contain,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   flex: 5,
//                   child: Center(
//                     child: Container(
//                       width: double.infinity,
//                       height: 300.0,
//                       decoration: BoxDecoration(
//                         color: Color.fromARGB(122, 16, 35, 54),
//                         border: Border.all(
//                           color: Color.fromARGB(225, 159, 207, 255),
//                           width: 1,
//                           style: BorderStyle.solid,
//                         ),
//                         borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                       ),
//                       padding: const EdgeInsets.all(0),
//                       child: Column(
//                         // mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 25.0),
//                           Text(
//                             "Forgot Passowrd",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontFamily: "Rosario",
//                               fontWeight: FontWeight.w600,
//                               color: Color.fromARGB(255, 152, 205, 255),
//                             ),
//                           ),
//                           const SizedBox(height: 55.0),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20.0,
//                             ),
//                             child: MyTextField(
//                               controller: _emailController,
//                               hinttext: "Email Address",
//                               obsecuretext: false,
//                               suffixIcon: false,
//                             ),
//                           ),
//                           const SizedBox(height: 30.0),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20.0,
//                             ),
//                             child: SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   _verifyEmailProcess();
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFF1A73E8),
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 16,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   "VERIFY",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.white,
//                                     fontFamily: "Quicksand",
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




// import 'dart:async';
// import 'dart:math';
// import 'package:cinefetch_app/components/custom_message.dart';
// import 'package:cinefetch_app/components/custom_textfield.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final _emailController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final List<TextEditingController> _digitControllers = 
//       List.generate(6, (index) => TextEditingController());
//   final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  
//   final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//   int _resendTimer = 30;
//   late Timer _timer;
//   String? _userId;
//   int _currentStep = 0; // 0 = email, 1 = verification, 2 = password reset
//   bool _isSending = false;
//   bool _isVerifying = false;
//   bool _isResetting = false;

//   @override
//   void initState() {
//     super.initState();
//     // Set up focus nodes for verification code
//     for (int i = 0; i < 5; i++) {
//       _focusNodes[i].addListener(() {
//         if (_focusNodes[i].hasFocus && _digitControllers[i].text.isEmpty) {
//           _digitControllers[i].text = " ";
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     for (var controller in _digitControllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
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

//   void _onDigitChanged(String value, int index) {
//     if (value.length == 1 && index < 5) {
//       _focusNodes[index].unfocus();
//       FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
//     } else if (value.isEmpty && index > 0) {
//       _focusNodes[index].unfocus();
//       FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
//     }
//   }

//   Future<void> _verifyEmailProcess() async {
//     if (_emailController.text.isEmpty) {
//       CustomMessage.show(
//         context: context,
//         message: "Please enter your email!",
//         type: MessageType.error,
//       );
//       return;
//     }

//     if (!emailRegex.hasMatch(_emailController.text)) {
//       CustomMessage.show(
//         context: context,
//         message: "Please enter valid email!",
//         type: MessageType.error,
//       );
//       return;
//     }

//     setState(() => _isSending = true);

//     try {
//       final query = await FirebaseFirestore.instance
//           .collection("users")
//           .where("email", isEqualTo: _emailController.text)
//           .limit(1)
//           .get();

//       if (query.docs.isEmpty) {
//         CustomMessage.show(
//           context: context,
//           message: "No user found with this email address!",
//           type: MessageType.error,
//         );
//         return;
//       }

//       _userId = query.docs.first.id;
//       final newCode = (100000 + Random().nextInt(900000)).toString();

//       // Store verification code in Firestore
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(_userId)
//           .update({'verificationCode': newCode});

//       // In a real app, you would send this code to the user's email
//       print("Verification Code: $newCode"); // For testing

//       CustomMessage.show(
//         context: context,
//         message: "Verification code sent to your email!",
//         type: MessageType.success,
//       );

//       setState(() {
//         _currentStep = 1;
//         _resendTimer = 30;
//         _isSending = false;
//       });
      
//       _startResendTimer();
//     } catch (e) {
//       CustomMessage.show(
//         context: context,
//         message: "Error: ${e.toString()}",
//         type: MessageType.error,
//       );
//       setState(() => _isSending = false);
//     }
//   }

//   Future<void> _verifyCode() async {
//     final verificationCode = _digitControllers
//         .map((controller) => controller.text.trim())
//         .join("");

//     if (verificationCode.length != 6) {
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
//           .collection('users')
//           .doc(_userId)
//           .get();

//       final storedCode = doc.data()?['verificationCode'] ?? '';

//       if (storedCode == verificationCode) {
//         // Clear verification code
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(_userId)
//             .update({'verificationCode': FieldValue.delete()});

//         setState(() {
//           _currentStep = 2;
//           _isVerifying = false;
//         });
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

//   Future<void> _resetPassword() async {
//     if (_newPasswordController.text.isEmpty) {
//       CustomMessage.show(
//         context: context,
//         message: "Please enter new password!",
//         type: MessageType.error,
//       );
//       return;
//     }

//     if (_newPasswordController.text.length < 6) {
//       CustomMessage.show(
//         context: context,
//         message: "Password must be at least 6 characters",
//         type: MessageType.error,
//       );
//       return;
//     }

//     if (_newPasswordController.text != _confirmPasswordController.text) {
//       CustomMessage.show(
//         context: context,
//         message: "Passwords do not match!",
//         type: MessageType.error,
//       );
//       return;
//     }

//     setState(() => _isResetting = true);

//     try {
//       // Update password in Firestore
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(_userId)
//           .update({'password': _newPasswordController.text});

//       // Optional: Update in Firebase Auth if you're using it for login
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null && user.email == _emailController.text) {
//         await user.updatePassword(_newPasswordController.text);
//       }

//       CustomMessage.show(
//         context: context,
//         message: "Password reset successfully!",
//         type: MessageType.success,
//       );

//       Navigator.pop(context);
//     } catch (e) {
//       CustomMessage.show(
//         context: context,
//         message: "Password reset failed: ${e.toString()}",
//         type: MessageType.error,
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isResetting = false);
//       }
//     }
//   }

//   Widget _buildEmailStep() {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//             flex: 1,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   "assets/logo/cine_fetch_logo_tr.png",
//                   width: 100,
//                   height: 70,
//                   fit: BoxFit.contain,
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: Center(
//               child: Container(
//                 width: double.infinity,
//                 height: 300.0,
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(122, 16, 35, 54),
//                   border: Border.all(
//                     color: const Color.fromARGB(225, 159, 207, 255),
//                     width: 1,
//                     style: BorderStyle.solid,
//                   ),
//                   borderRadius: const BorderRadius.all(Radius.circular(8.0)),
//                 ),
//                 padding: const EdgeInsets.all(0),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 25.0),
//                     Text(
//                       "Forgot Password",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontFamily: "Rosario",
//                         fontWeight: FontWeight.w600,
//                         color: const Color.fromARGB(255, 152, 205, 255),
//                       ),
//                     ),
//                     const SizedBox(height: 55.0),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: MyTextField(
//                         controller: _emailController,
//                         hinttext: "Email Address",
//                         obsecuretext: false,
//                         suffixIcon: false,
//                       ),
//                     ),
//                     const SizedBox(height: 30.0),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: _isSending ? null : _verifyEmailProcess,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF1A73E8),
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: _isSending
//                               ? const CircularProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation(Colors.white),
//                                 )
//                               : Text(
//                                   "SEND CODE",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.white,
//                                     fontFamily: "Quicksand",
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVerificationStep() {
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
//                     "We sent a 6-digit code to ${_emailController.text}",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontFamily: "Quicksand",
//                       color: Colors.white70,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
                  
//                   // 6-Digit Code Input Boxes
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: List.generate(6, (index) {
//                       return SizedBox(
//                         width: 50,
//                         height: 60,
//                         child: TextField(
//                           controller: _digitControllers[index],
//                           focusNode: _focusNodes[index],
//                           textAlign: TextAlign.center,
//                           keyboardType: TextInputType.number,
//                           maxLength: 1,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
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
//                           onChanged: (value) => _onDigitChanged(value, index),
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
//                               "VERIFY CODE",
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
//                       onPressed: _resendTimer > 0
//                           ? null
//                           : () {
//                               setState(() => _resendTimer = 30);
//                               _verifyEmailProcess();
//                               _startResendTimer();
//                             },
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

//   Widget _buildPasswordResetStep() {
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
//                   const SizedBox(height: 50),
//                   Text(
//                     "Reset Your Password",
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontFamily: "Rosario",
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   Text(
//                     "Create a new password for your account",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontFamily: "Quicksand",
//                       color: Colors.white70,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
                  
//                   // New Password Field
//                   MyTextField(
//                     controller: _newPasswordController,
//                     hinttext: "New Password",
//                     obsecuretext: true,
//                     suffixIcon: true,
//                   ),
//                   const SizedBox(height: 20),
                  
//                   // Confirm Password Field
//                   MyTextField(
//                     controller: _confirmPasswordController,
//                     hinttext: "Confirm Password",
//                     obsecuretext: true,
//                     suffixIcon: true,
//                   ),
                  
//                   const SizedBox(height: 40),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _isResetting ? null : _resetPassword,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF1A73E8),
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: _isResetting
//                           ? const CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation(Colors.white),
//                             )
//                           : const Text(
//                               "RESET PASSWORD",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.white,
//                                 fontFamily: "Quicksand",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
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
//           if (_currentStep == 0) _buildEmailStep(),
//           if (_currentStep == 1) _buildVerificationStep(),
//           if (_currentStep == 2) _buildPasswordResetStep(),
//         ],
//       ),
//     );
//   }
// }