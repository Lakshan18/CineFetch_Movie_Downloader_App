// import 'package:cinefetch_app/animation/custom_animation.dart';
// import 'package:cinefetch_app/components/custom_message.dart';
// import 'package:cinefetch_app/components/custom_textfield.dart';
// import 'package:cinefetch_app/routes/custom_page_route.dart';
// import 'package:cinefetch_app/screens/home_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:cinefetch_app/screens/register_screen.dart';
// import 'package:flutter/services.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:crypto/crypto.dart';
// import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';

// class LoginProcess extends StatefulWidget {
//   const LoginProcess({super.key});

//   @override
//   State<LoginProcess> createState() => _LoginScreenState();
// }

// class UserLoginProcess {

//   final prefs = SharedPreferences.getInstance();

//   // Password hashing function
//   String _hashPassword(String plainText) {
//     return sha256.convert(utf8.encode(plainText)).toString();
//   }

//   Future<void> loginWithFirestore(
//     BuildContext context,
//     String username,
//     String password,
//   ) async {
//     try {
//       // Initialize Firebase if not already done
//       if (Firebase.apps.isEmpty) {
//         await Firebase.initializeApp();
//       }

//       // Validate inputs
//       if (username.isEmpty || password.isEmpty) {
//         throw Exception('Please enter both username and password');
//       }

//       if (password.length < 8) {
//         throw Exception('Password must be at least 8 characters');
//       }

//       // Show loading
//       CustomMessage.show(
//         context: context,
//         message: "Verifying credentials...",
//         type: MessageType.info,
//       );

//       // Query Firestore for username
//       final query = await FirebaseFirestore.instance
//           .collection('user') // Changed from 'user' to 'users' for consistency
//           .where('username', isEqualTo: username)
//           .limit(1)
//           .get();

//       if (query.docs.isEmpty) {
//         throw Exception('Invalid Credentials!');
//       }

//       final userDoc = query.docs.first;
//       final storedPassword = userDoc['password'] as String?;
//       final inputHash = _hashPassword(password);

//       // Compare hashed passwords
//       if (storedPassword != inputHash) {
//         throw Exception('Invalid Credentials!');
//       }

//       // Login success
//       CustomMessage.show(
//         context: context,
//         message: "Welcome back, ${userDoc['firstName']}!",
//         type: MessageType.success,
//       );

//       if (context.mounted) {
//         Navigator.pushReplacement(
//           context,
//           SlideFadePageRoute(page: const HomeScreen()),
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         CustomMessage.show(
//           context: context,
//           message: e.toString().replaceFirst('Exception: ', ''),
//           type: MessageType.error,
//         );
//       }
//     }
//   }
// }

// class _LoginScreenState extends State<LoginProcess> {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Color.fromARGB(255, 43, 100, 147),
//         statusBarIconBrightness: Brightness.light,
//         systemNavigationBarColor: Color.fromARGB(255, 11, 101, 219),
//         systemNavigationBarIconBrightness: Brightness.light,
//       ),
//     );
//   }

//   bool _rememberMe = false;
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final scrollController = ScrollController();

//   @override
//   void dispose() {
//     usernameController.dispose();
//     passwordController.dispose();
//     scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Color(0xFF020912),
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: Scaffold(
//         backgroundColor: const Color(0xFF020912),
//         body: Stack(
//           children: [
//             Positioned.fill(
//               child: Opacity(
//                 opacity: 0.09,
//                 child: Image.asset(
//                   "assets/page_background.png",
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             LayoutBuilder(
//               builder: (context, constraints) {
//                 return SingleChildScrollView(
//                   controller: scrollController,
//                   physics: const ClampingScrollPhysics(),
//                   padding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom,
//                   ),
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minHeight: constraints.maxHeight,
//                     ),
//                     child: IntrinsicHeight(
//                       child: SafeArea(
//                         top: true,
//                         bottom: false,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Column(
//                             children: [
//                               const SizedBox(height: 25.0),
//                               const Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Image(
//                                     image: AssetImage(
//                                       "assets/logo/cine_fetch_logo_tr.png",
//                                     ),
//                                     width: 100,
//                                     height: 70,
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 75.0),
//                               Row(
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       CustomAnimation(
//                                         0.6,
//                                         type: AnimationType.fadeSlide,
//                                         const Text(
//                                           "Welcome Back!",
//                                           style: TextStyle(
//                                             fontSize: 36,
//                                             fontFamily: "Rosario",
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 10.0),
//                                       CustomAnimation(
//                                         0.62,
//                                         type: AnimationType.fadeSlide,
//                                         const Text(
//                                           "Please login to continue",
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             fontFamily: "Quicksand",
//                                             color: Color(0xFFAAAAAA),
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 50.0),
//                               CustomAnimation(
//                                 0.65,
//                                 type: AnimationType.bounce,
//                                 MyTextField(
//                                   controller: usernameController,
//                                   hinttext: "Username",
//                                   obsecuretext: false,
//                                   suffixIcon: false,
//                                 ),
//                               ),
//                               const SizedBox(height: 20.0),
//                               CustomAnimation(
//                                 0.66,
//                                 type: AnimationType.bounce,
//                                 MyTextField(
//                                   controller: passwordController,
//                                   hinttext: "Password",
//                                   obsecuretext: true,
//                                   suffixIcon: true,
//                                 ),
//                               ),
//                               const SizedBox(height: 25.0),
//                               CustomAnimation(
//                                 0.7,
//                                 type: AnimationType.swing,
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Checkbox(
//                                           value: _rememberMe,
//                                           onChanged: (value) => setState(
//                                             () => _rememberMe = value ?? false,
//                                           ),
//                                           fillColor:
//                                               WidgetStateProperty.resolveWith<
//                                                 Color
//                                               >(
//                                                 (states) =>
//                                                     states.contains(
//                                                       WidgetState.selected,
//                                                     )
//                                                     ? const Color(0xFF1579FC)
//                                                     : Colors.transparent,
//                                               ),
//                                         ),
//                                         const Text(
//                                           "Remember me",
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontFamily: "Quicksand",
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     TextButton(
//                                       onPressed: () => print("Forgot Password"),
//                                       child: const Text(
//                                         "Forgot Password?",
//                                         style: TextStyle(
//                                           color: Color(0xFFA2CFF6),
//                                           fontFamily: "Quicksand",
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 20.0),
//                               CustomAnimation(
//                                 0.72,
//                                 type: AnimationType.fadeSlide,
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: ElevatedButton(
//                                     onPressed: () =>
//                                         UserLoginProcess().loginWithFirestore(
//                                           context,
//                                           usernameController.text,
//                                           passwordController.text,
//                                         ),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: const Color(0xFF1A73E8),
//                                       padding: const EdgeInsets.symmetric(
//                                         vertical: 14.0,
//                                       ),
//                                     ),
//                                     child: const Text(
//                                       "LOGIN",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontFamily: "Quicksand",
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 20.0),
//                               CustomAnimation(
//                                 0.75,
//                                 type: AnimationType.swing,
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     const Text(
//                                       "Not a member?",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontFamily: "Quicksand",
//                                       ),
//                                     ),
//                                     const SizedBox(width: 5.0),
//                                     GestureDetector(
//                                       onTap: () => Navigator.push(
//                                         context,
//                                         SlideFadePageRoute(
//                                           page: const RegisterScreen(),
//                                         ),
//                                       ),
//                                       child: const Text(
//                                         "Register Now",
//                                         style: TextStyle(
//                                           color: Color(0xFFA2CFF6),
//                                           fontSize: 16,
//                                           fontFamily: "Quicksand",
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height:
//                                     MediaQuery.of(context).viewInsets.bottom > 0
//                                     ? MediaQuery.of(context).viewInsets.bottom
//                                     : 20.0,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cinefetch_app/animation/custom_animation.dart';
import 'package:cinefetch_app/components/custom_message.dart';
import 'package:cinefetch_app/components/custom_textfield.dart';
import 'package:cinefetch_app/routes/custom_page_route.dart';
import 'package:cinefetch_app/screens/home_screen.dart';
import 'package:cinefetch_app/screens/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProcess extends StatefulWidget {
  const LoginProcess({super.key});

  @override
  State<LoginProcess> createState() => _LoginScreenState();
}

class UserLoginProcess {
  // Password hashing function
  String _hashPassword(String plainText) {
    return sha256.convert(utf8.encode(plainText)).toString();
  }

  Future<void> _saveCredentials(String username, String hashedPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('remembered_username', username);
    await prefs.setString('remembered_hashed_password', hashedPassword);
  }

  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remembered_username');
    await prefs.remove('remembered_hashed_password');
  }

  Future<(String?, String?)> getRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('remembered_username');
    final hashedPassword = prefs.getString('remembered_hashed_password');
    return (username, hashedPassword);
  }

  Future<void> loginWithFirestore(
    BuildContext context,
    String username,
    String password,
    bool rememberMe,
  ) async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      if (username.isEmpty || password.isEmpty) {
        throw Exception('Please enter both username and password');
      }

      if (password.length < 8) {
        throw Exception('Password must be at least 8 characters');
      }

      CustomMessage.show(
        context: context,
        message: "Verifying credentials...",
        type: MessageType.info,
      );

      // Hash the input password
      final inputHash = _hashPassword(password);

      // Handle remember me functionality
      if (rememberMe) {
        await _saveCredentials(username, inputHash);
      } else {
        await _clearCredentials();
      }

      // Query Firestore for username
      final query = await FirebaseFirestore.instance
          .collection('user')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('Invalid Credentials!');
      }

      final userDoc = query.docs.first;
      final storedPassword = userDoc['password'] as String?;

      // Compare hashed passwords
      if (storedPassword != inputHash) {
        throw Exception('Invalid Credentials!');
      }

      // Login success
      CustomMessage.show(
        context: context,
        message: "Welcome back, ${userDoc['firstName']}!",
        type: MessageType.success,
      );

      print(getRememberedCredentials().toString());

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          SlideFadePageRoute(page: const HomeScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        CustomMessage.show(
          context: context,
          message: e.toString().replaceFirst('Exception: ', ''),
          type: MessageType.error,
        );
      }
    }
  }
}

class _LoginScreenState extends State<LoginProcess> {
  bool _rememberMe = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final scrollController = ScrollController();
  final UserLoginProcess _userLoginProcess = UserLoginProcess();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 43, 100, 147),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color.fromARGB(255, 11, 101, 219),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    _loadRememberedCredentials();
  }

  Future<void> _loadRememberedCredentials() async {
    final (username, hashedPassword) = await _userLoginProcess
        .getRememberedCredentials();
    if (username != null && hashedPassword != null) {
      setState(() {
        usernameController.text = username;
        _rememberMe = true;
        // Note: We don't set the password here for security reasons
        // The password field will remain empty, but the checkbox will be checked
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF020912),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
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
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: SafeArea(
                        top: true,
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 25.0),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image(
                                    image: AssetImage(
                                      "assets/logo/cine_fetch_logo_tr.png",
                                    ),
                                    width: 100,
                                    height: 70,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 75.0),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomAnimation(
                                        0.6,
                                        type: AnimationType.fadeSlide,
                                        const Text(
                                          "Welcome Back!",
                                          style: TextStyle(
                                            fontSize: 36,
                                            fontFamily: "Rosario",
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      CustomAnimation(
                                        0.62,
                                        type: AnimationType.fadeSlide,
                                        const Text(
                                          "Please login to continue",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Quicksand",
                                            color: Color(0xFFAAAAAA),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 50.0),
                              CustomAnimation(
                                0.65,
                                type: AnimationType.bounce,
                                MyTextField(
                                  controller: usernameController,
                                  hinttext: "Username",
                                  obsecuretext: false,
                                  suffixIcon: false,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              CustomAnimation(
                                0.66,
                                type: AnimationType.bounce,
                                MyTextField(
                                  controller: passwordController,
                                  hinttext: "Password",
                                  obsecuretext: true,
                                  suffixIcon: true,
                                ),
                              ),
                              const SizedBox(height: 25.0),
                              CustomAnimation(
                                0.7,
                                type: AnimationType.swing,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _rememberMe,
                                          onChanged: (value) => setState(
                                            () => _rememberMe = value ?? false,
                                          ),
                                          fillColor:
                                              WidgetStateProperty.resolveWith<
                                                Color
                                              >(
                                                (states) =>
                                                    states.contains(
                                                      WidgetState.selected,
                                                    )
                                                    ? const Color(0xFF1579FC)
                                                    : Colors.transparent,
                                              ),
                                        ),
                                        const Text(
                                          "Remember me",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Quicksand",
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () => {
                                        // Navigator.push(
                                        //   context,
                                        //   SlideFadePageRoute(
                                        //     page: const ForgotPasswordScreen(),
                                        //   ),
                                        // ),
                                      },
                                      child: const Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          color: Color(0xFFA2CFF6),
                                          fontFamily: "Quicksand",
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              CustomAnimation(
                                0.72,
                                type: AnimationType.fadeSlide,
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // Show loading indicator
                                      CustomMessage.show(
                                        context: context,
                                        message: "Logging in...",
                                        type: MessageType.info,
                                      );

                                      try {
                                        await _userLoginProcess
                                            .loginWithFirestore(
                                              context,
                                              usernameController.text,
                                              passwordController.text,
                                              _rememberMe,
                                            );
                                      } catch (e) {
                                        if (context.mounted) {
                                          CustomMessage.show(
                                            context: context,
                                            message: e.toString(),
                                            type: MessageType.error,
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1A73E8),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    child: const Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              CustomAnimation(
                                0.75,
                                type: AnimationType.swing,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Not a member?",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: "Quicksand",
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        SlideFadePageRoute(
                                          page: const RegisterScreen(),
                                        ),
                                      ),
                                      child: const Text(
                                        "Register Now",
                                        style: TextStyle(
                                          color: Color(0xFFA2CFF6),
                                          fontSize: 16,
                                          fontFamily: "Quicksand",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).viewInsets.bottom > 0
                                    ? MediaQuery.of(context).viewInsets.bottom
                                    : 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
