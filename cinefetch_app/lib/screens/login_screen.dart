import 'package:cinefetch_app/animation/custom_animation.dart';
import 'package:cinefetch_app/components/custom_message.dart';
import 'package:cinefetch_app/components/custom_textfield.dart';
import 'package:cinefetch_app/routes/custom_page_route.dart';
import 'package:cinefetch_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cinefetch_app/screens/register_screen.dart';
import 'package:flutter/services.dart';

class LoginProcess extends StatefulWidget {
  const LoginProcess({super.key});

  @override
  State<LoginProcess> createState() => _LoginScreenState();
}

class UserLoginProcess {
  final String username;
  final String password;

  const UserLoginProcess({required this.username, required this.password})
    : assert(username != '', 'Username cannot be empty'),
      assert(password != '', 'Password cannot be empty');

  // In your UserLoginProcess class
  Future<void> login(
    BuildContext context,
    String username,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    if (username.isEmpty || password.isEmpty) {
      CustomMessage.show(
        context: context,
        message: "Username and Password cannot be empty!",
        type: MessageType.error,
      );
    } else if (username == "Lakshan" && password == "12345678") {
      CustomMessage.show(
        context: context,
        message: "Login Successful! Redirecting...",
        type: MessageType.success,
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pushAndRemoveUntil(
        SlideFadePageRoute(page: const HomeScreen()),
        (route) => false,
      );
    } else if (password.length < 8) {
      CustomMessage.show(
        context: context,
        message: "Password must be at least 8 characters long!",
        type: MessageType.warning,
      );
    } else {
      CustomMessage.show(
        context: context,
        message: "Invalid username or password!",
        type: MessageType.error,
      );
    }
  }
}

class _LoginScreenState extends State<LoginProcess> {
  @override
  void initState() {
    super.initState();
    // Set initial status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 43, 100, 147), // Your desired color
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color.fromARGB(255, 11, 101, 219),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  bool _rememberMe = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF020912), // Match your background
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light, // For iOS
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF020912),
        body: Stack(
          children: [
            // Fixed background image (won't scroll)
            Positioned.fill(
              child: Opacity(
                opacity: 0.09,
                child: Image.asset(
                  "assets/page_background.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Keyboard-aware scrollable content
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 25.0),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image(
                                    image: AssetImage(
                                      "assets/logo/cine_fetch_logo_tr.png",
                                    ),
                                    fit: BoxFit.contain,
                                    width: 100,
                                    height: 70,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 75.0),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CustomAnimation(
                                        0.6,
                                        type: AnimationType.fadeSlide,
                                        const Text(
                                          "Welcome Back!",
                                          style: TextStyle(
                                            fontSize: 36,
                                            fontFamily: "Rosario",
                                            color: Color(0xFFFFFFFF),
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
                                            color: Color.fromARGB(
                                              255,
                                              170,
                                              170,
                                              170,
                                            ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 50.0),
                              // Username textfield
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
                              // Password textfield
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
                              // Remember me and forgot password
                              CustomAnimation(
                                0.7,
                                type: AnimationType.swing,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CheckboxTheme(
                                          data: CheckboxThemeData(
                                            side:
                                                WidgetStateBorderSide.resolveWith(
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
                                            value: _rememberMe,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _rememberMe = value ?? false;
                                              });
                                            },
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "Remember me",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Quicksand",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        print("Forgot Password Pressed");
                                      },
                                      child: const Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          color: Color(0xFFA2CFF6),
                                          fontFamily: "Quicksand",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              // Login Button
                              CustomAnimation(
                                0.72,
                                type: AnimationType.fadeSlide,
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      const UserLoginProcess(
                                        username: "testUser",
                                        password: "testPassword",
                                      ).login(
                                        context,
                                        usernameController.text,
                                        passwordController.text,
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
                              // Not a member? Register Now
                              CustomAnimation(
                                0.75,
                                type: AnimationType.swing,
                                GestureDetector(
                                  onTap: () {
                                    print("Navigate to Sign Up Screen");
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Not a member?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Quicksand",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            SlideFadePageRoute(
                                              page: const RegisterScreen(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "Register Now",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFFA2CFF6),
                                            fontFamily: "Quicksand",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
