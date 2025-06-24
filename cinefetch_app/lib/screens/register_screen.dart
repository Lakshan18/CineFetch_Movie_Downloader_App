import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cinefetch_app/animation/custom_animation.dart';
import 'package:cinefetch_app/components/custom_message.dart';
import 'package:cinefetch_app/components/custom_textfield.dart';
import 'package:cinefetch_app/routes/custom_page_route.dart';
import 'package:cinefetch_app/screens/email_verification_screen.dart';
import 'package:cinefetch_app/screens/login_screen.dart';
import 'package:cinefetch_app/services/network_service.dart';
import 'package:cinefetch_app/services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class UserRegisterProcess {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~_.,;:]).{5,10}$',
  );

  String _hashPassword(String plainText) {
    return sha256.convert(utf8.encode(plainText)).toString();
  }

  String _generateRandomCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<void> registerWithFirestore(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String password,
    String confPassword,
  ) async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      if (firstName.isEmpty ||
          lastName.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confPassword.isEmpty) {
        CustomMessage.show(
          context: context,
          message: "All fields are required!",
          type: MessageType.error,
        );
        return;
      }

      if (!emailRegex.hasMatch(email)) {
        CustomMessage.show(
          context: context,
          message: "Please enter a valid email address!",
          type: MessageType.error,
        );
        return;
      }

      if (!passwordRegex.hasMatch(password)) {
        CustomMessage.show(
          context: context,
          message:
              "Password must be 5-10 chars with uppercase, lowercase, number and symbol",
          type: MessageType.warning,
        );
        return;
      }

      if (confPassword != password) {
        CustomMessage.show(
          context: context,
          message: "Passwords don't match!",
          type: MessageType.error,
        );
        return;
      }

      CustomMessage.show(
        context: context,
        message: "Creating account...",
        type: MessageType.info,
      );

      final auth = FirebaseAuth.instance;
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final verificationCode = _generateRandomCode();
      final userId = credential.user?.uid ?? "";

      await FirebaseFirestore.instance.collection('user').doc(userId).set({
        "email": email,
        "verificationCode": verificationCode,
        "createdAt": FieldValue.serverTimestamp(),
        "emailVerified": false,
      });

      await SessionManager.setTempUserData({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "passwordHash": _hashPassword(password),
      });

      await SessionManager.setUserId(userId);

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          SlideFadePageRoute(
            page: EmailVerificationScreen(email: email, userId: userId),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "Email already in use";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email format";
          break;
        case 'weak-password':
          errorMessage = "Password is too weak";
          break;
        default:
          errorMessage = "Registration failed: ${e.code}";
      }
      if (context.mounted) {
        CustomMessage.show(
          context: context,
          message: errorMessage,
          type: MessageType.error,
        );
      }
    } catch (e) {
      if (context.mounted) {
        CustomMessage.show(
          context: context,
          message: "Registration failed. Please try again.",
          type: MessageType.error,
        );
      }
    }
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  late StreamSubscription<bool> _connectionSubscription;
  bool _dialogShowing = false;

  final scrollController = ScrollController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool agreeToTerms = false;
  bool isLoading = false;

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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: const Color(0xFF020912),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
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
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    CustomAnimation(
                      0.4,
                      type: AnimationType.fadeSlide,
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
                    ),
                    const SizedBox(height: 70),
                    CustomAnimation(
                      0.44,
                      type: AnimationType.fade,
                      Text(
                        "Create An Account",
                        style: TextStyle(
                          fontSize: 36,
                          fontFamily: "Rosario",
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomAnimation(
                      0.45,
                      type: AnimationType.fade,
                      Text(
                        "Please fill in the details below to create your account.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 224, 224, 224),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomAnimation(
                                0.52,
                                type: AnimationType.bounce,
                                MyTextField(
                                  controller: _firstNameController,
                                  hinttext: "First Name",
                                  obsecuretext: false,
                                  suffixIcon: false,
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomAnimation(
                                0.52,
                                type: AnimationType.bounce,
                                MyTextField(
                                  controller: _lastNameController,
                                  hinttext: "Last Name",
                                  obsecuretext: false,
                                  suffixIcon: false,
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomAnimation(
                                0.52,
                                type: AnimationType.bounce,
                                MyTextField(
                                  controller: _emailController,
                                  hinttext: "Email",
                                  obsecuretext: false,
                                  suffixIcon: false,
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomAnimation(
                                0.55,
                                type: AnimationType.bounce,
                                MyTextField(
                                  controller: _passwordController,
                                  hinttext: "Password",
                                  obsecuretext: true,
                                  suffixIcon: true,
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomAnimation(
                                0.55,
                                type: AnimationType.bounce,
                                MyTextField(
                                  controller: _confirmPasswordController,
                                  hinttext: "Confirm Password",
                                  obsecuretext: true,
                                  suffixIcon: true,
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomAnimation(
                                0.59,
                                type: AnimationType.swing,
                                Row(
                                  children: [
                                    CheckboxTheme(
                                      data: CheckboxThemeData(
                                        side: WidgetStateBorderSide.resolveWith(
                                          (states) => const BorderSide(
                                            color: Color(0xFF91ABCE),
                                            width: 1,
                                          ),
                                        ),
                                        fillColor:
                                            WidgetStateProperty.resolveWith<
                                              Color
                                            >(
                                              (states) =>
                                                  states.contains(
                                                    WidgetState.selected,
                                                  )
                                                  ? const Color(0xFF1A73E8)
                                                  : Colors.transparent,
                                            ),
                                        checkColor: WidgetStateProperty.all(
                                          Colors.white,
                                        ),
                                      ),
                                      child: Checkbox(
                                        value: agreeToTerms,
                                        onChanged: (value) => setState(
                                          () => agreeToTerms = value ?? false,
                                        ),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "I agree to the Terms and Conditions",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Quicksand",
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomAnimation(
                                0.6,
                                type: AnimationType.swing,
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () async {
                                            if (!agreeToTerms) {
                                              CustomMessage.show(
                                                context: context,
                                                message:
                                                    "You must agree to the terms",
                                                type: MessageType.warning,
                                              );
                                              return;
                                            }
                                            setState(() => isLoading = true);
                                            await UserRegisterProcess()
                                                .registerWithFirestore(
                                                  context,
                                                  _firstNameController.text
                                                      .trim(),
                                                  _lastNameController.text
                                                      .trim(),
                                                  _emailController.text.trim(),
                                                  _passwordController.text,
                                                  _confirmPasswordController
                                                      .text,
                                                );
                                            if (context.mounted) {
                                              setState(() => isLoading = false);
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: agreeToTerms
                                          ? const Color(0xFF1A73E8)
                                          : const Color(0xFF5A6B7B),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Text(
                                            "REGISTER",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontFamily: "Quicksand",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomAnimation(
                                    0.62,
                                    type: AnimationType.fadeSlide,
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Quicksand",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  CustomAnimation(
                                    0.62,
                                    type: AnimationType.bounce,
                                    GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                        SlideFadePageRoute(
                                          page: const LoginProcess(),
                                        ),
                                      ),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Quicksand",
                                          color: const Color(0xFF1A73E8),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
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
      ),
    );
  }
}
