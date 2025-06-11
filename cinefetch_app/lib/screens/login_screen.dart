import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginProcess extends StatelessWidget {
  const LoginProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login Screen",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFF051225),
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/page_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Color.fromARGB(229, 5, 18, 37),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo Row
                          Container(
                            width: double.infinity,
                            height: 120,
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  "assets/logo/cine_fetch_logo_tr.png",
                                  width: 80,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Form Section with Welcome Text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Text with 15px bottom margin
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 15,
                            ),
                            child: Text(
                              "Welcome Back!",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Rosario",
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),

                          // Form Container
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 20.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(89, 106, 126, 178),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Username Field
                                Text(
                                  "Username",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFA2CFF6),
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 12, 12, 12),
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFF91ABCE),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Text(
                                  "Password",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFA2CFF6),
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  obscureText: true,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 12, 12, 12),
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFF91ABCE),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                 ),
                                ),
                                const SizedBox(height: 10),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CheckboxTheme(
                                          data: CheckboxThemeData(
                                            side:
                                                WidgetStateBorderSide.resolveWith(
                                                  (states) => BorderSide(
                                                    color: Colors.white,
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
                                                    return Colors.blue;
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
                                        Text(
                                          "Remember me",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Quicksand",
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          color: Colors.blue[200],
                                          fontFamily: "Quicksand",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Sign Up Prompt
                                Center(
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "If you haven't already an Account?",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Quicksand",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}