import 'package:cinefetch_app/animation/custom_animation.dart';
import 'package:cinefetch_app/components/custom_textfield.dart';
import 'package:cinefetch_app/routes/custom_page_route.dart';
import 'package:cinefetch_app/screens/create_profile.dart';
import 'package:cinefetch_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final scrollController = ScrollController();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final bool isPasswordVisible = false;
  final bool isConfirmPasswordVisible = false;
  bool agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xFF020912), // Match your background
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFF020912),
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.09,
                child: Image.asset(
                  "assets/page_background.png",
                  fit: BoxFit.cover,
                  // width: double.infinity,
                  // height: double.infinity,
                ),
              ),
            ),

            SafeArea(
              top: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30.0),
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
                    const SizedBox(height: 70.0),

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

                    const SizedBox(height: 15.0),

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

                    const SizedBox(height: 10.0),

                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomAnimation(
                                0.52,
                                type: AnimationType.bounce,
                                MyTextField(
                                  controller: firstNameController,
                                  hinttext: "First Name",
                                  obsecuretext: false,
                                  suffixIcon: false,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              CustomAnimation(
                                0.52,
                                type: AnimationType.bounce,
                                MyTextField(
                                  controller: lastNameController,
                                  hinttext: "Last Name",
                                  obsecuretext: false,
                                  suffixIcon: false,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              CustomAnimation(
                                0.52,
                                type: AnimationType.bounce,
                                MyTextField(
                                  controller: emailController,
                                  hinttext: "Email",
                                  obsecuretext: false,
                                  suffixIcon: false,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              CustomAnimation(
                                0.55,
                                type: AnimationType.bounce,
                                MyTextField(
                                  controller: passwordController,
                                  hinttext: "Password",
                                  obsecuretext: true,
                                  suffixIcon: true,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              CustomAnimation(
                                0.55,
                                type: AnimationType.bounce,
                                MyTextField(
                                  controller: confirmPasswordController,
                                  hinttext: "Confirm Password",
                                  obsecuretext: true,
                                  suffixIcon: true,
                                ),
                              ),
                              const SizedBox(height: 20.0),
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
                                            >((Set<WidgetState> states) {
                                              if (states.contains(
                                                WidgetState.selected,
                                              )) {
                                                return const Color.fromARGB(
                                                  255,
                                                  21,
                                                  121,
                                                  252,
                                                );
                                              }
                                              return Colors.transparent;
                                            }),
                                        checkColor:
                                            WidgetStateProperty.all<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                      child: Checkbox(
                                        value: agreeToTerms,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            agreeToTerms = value ?? false;
                                          });
                                        },
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
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
                              const SizedBox(height: 20.0),
                              CustomAnimation(
                                0.6,
                                type: AnimationType.swing,
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        SlideFadePageRoute(
                                          page: const CreateProfileProcess(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1A73E8),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14.0,
                                        horizontal: 24.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      "REGISTER",
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
                                      onTap: () {
                                        Navigator.of(context).push(
                                          SlideFadePageRoute(
                                            page: const LoginProcess(),
                                          ),
                                        );
                                      },
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
                              const SizedBox(height: 20.0),
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
