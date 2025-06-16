import 'package:cinefetch_app/components/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginProcess extends StatefulWidget {
  const LoginProcess({super.key});

  @override
  State<LoginProcess> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginProcess> {
  bool _rememberMe = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF020912),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            //Background Image
            Positioned.fill(
              child: Opacity(
                opacity: 0.09,
                child: Image.asset(
                  "assets/page_background.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              controller: scrollController,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    //Cine Fetch App Logo Corner....
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

                    //Welcome Back , text..
                    const SizedBox(height: 50.0),

                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Welcome Back!",
                              style: TextStyle(
                                fontSize: 36,
                                fontFamily: "Rosario",
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              "Please login to continue",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Quicksand",
                                color: Color.fromARGB(255, 170, 170, 170),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 35.0),

                    //username textfield..
                    MyTextField(
                      controller: usernameController,
                      hinttext: "Username",
                      obsecuretext: false,
                    ),

                    const SizedBox(height: 20.0),
                    //password textfield..
                    MyTextField(
                      controller: passwordController,
                      hinttext: "Password",
                      obsecuretext: true,
                    ),
                    //remember me and forgot password..
                    const SizedBox(height: 25.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CheckboxTheme(
                              data: CheckboxThemeData(
                                side: WidgetStateBorderSide.resolveWith(
                                  (states) => BorderSide(
                                    color: Color(0xFF91ABCE), // Outline color
                                    width: 1,
                                  ),
                                ),
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        return Color.fromARGB(
                                          255,
                                          21,
                                          121,
                                          252,
                                        );
                                      }
                                      return Colors.transparent;
                                    }),
                                checkColor: WidgetStateProperty.all<Color>(
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
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
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
                            // ignore: avoid_print
                            print("Forgot Password Pressed");
                          },
                          child: Text(
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

                    const SizedBox(height: 20.0),
                    //Login Button..
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // ignore: avoid_print
                          print("Login Button Pressed");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1A73E8),
                          padding: EdgeInsets.symmetric(
                            vertical: 14.0,
                            horizontal: 24.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
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

                    const SizedBox(height: 20.0),
                    //Not a member? Register Now
                    GestureDetector(
                      onTap: () {
                        // ignore: avoid_print
                        print("Navigate to Sign Up Screen");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Not a member?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Quicksand",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // ignore: avoid_print
                              print("Register Now Pressed");
                            },
                            child: Text(
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
